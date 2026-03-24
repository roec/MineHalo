import Foundation

@MainActor
final class CourseListViewModel: ObservableObject {
    @Published var courses: [CourseListModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let sessionStore: SessionStore
    private let repository: CourseRepositoryProtocol
    private let downloadManager: CourseDownloadManager

    init(sessionStore: SessionStore, repository: CourseRepositoryProtocol, downloadManager: CourseDownloadManager) {
        self.sessionStore = sessionStore
        self.repository = repository
        self.downloadManager = downloadManager
    }

    func load(category: CourseCategory) async {
        guard let userId = sessionStore.user?.id else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            courses = try await repository.fetchCourses(userId: userId, category: category)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func start(course: CourseListModel) async throws -> [URL] {
        let urls = try await downloadManager.ensureDownloaded(course: course)
        if let uid = sessionStore.user?.id {
            try? await repository.updateCourseStatus(userId: uid, courseId: course.courseId, update: .init(isLocked: nil, isDownloaded: true, isStudied: true, isCompleted: nil))
        }
        return urls
    }
}
