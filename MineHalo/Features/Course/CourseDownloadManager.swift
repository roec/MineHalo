import Foundation

@MainActor
final class CourseDownloadManager: NSObject, ObservableObject {
    @Published var progressByCourse: [String: Double] = [:]
    @Published var speedByCourse: [String: String] = [:]

    private let apiClient: APIClientProtocol
    private let localStore: LocalCourseStoreProtocol

    init(apiClient: APIClientProtocol, localStore: LocalCourseStoreProtocol) {
        self.apiClient = apiClient
        self.localStore = localStore
    }

    func prepareCourseImages(course: CourseListModel) throws -> [URL] {
        try localStore.extractedImageURLs(for: course)
    }

    func ensureDownloaded(course: CourseListModel) async throws -> [URL] {
        if localStore.isCourseDownloaded(course) {
            return try localStore.extractedImageURLs(for: course)
        }
        let tmpZip = try await apiClient.download(.downloadCourseZip(courseId: course.courseId, courseName: course.courseName))
        let dst = try localStore.prepareCourseDirectory(course)
        try unzipFallback(zipURL: tmpZip, destination: dst)
        return try localStore.extractedImageURLs(for: course)
    }

    private func unzipFallback(zipURL: URL, destination: URL) throws {
        // Placeholder extraction: in production, replace with ZIPFoundation integration.
        // Keeps architecture and call site stable.
        let fm = FileManager.default
        let target = destination.appendingPathComponent(zipURL.lastPathComponent)
        if fm.fileExists(atPath: target.path) { try fm.removeItem(at: target) }
        try fm.copyItem(at: zipURL, to: target)
    }
}
