import Foundation

protocol LocalCourseStoreProtocol {
    func courseDirectory(for course: CourseListModel) -> URL
    func extractedImageURLs(for course: CourseListModel) throws -> [URL]
    func isCourseDownloaded(_ course: CourseListModel) -> Bool
    func prepareCourseDirectory(_ course: CourseListModel) throws -> URL
}

final class LocalCourseStore: LocalCourseStoreProtocol {
    private let fm = FileManager.default

    func courseDirectory(for course: CourseListModel) -> URL {
        let doc = fm.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: NSTemporaryDirectory())
        return doc.appendingPathComponent("courses").appendingPathComponent(course.courseId)
    }

    func prepareCourseDirectory(_ course: CourseListModel) throws -> URL {
        let url = courseDirectory(for: course)
        try fm.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    func extractedImageURLs(for course: CourseListModel) throws -> [URL] {
        let dir = courseDirectory(for: course)
        let files = try fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
            .filter { ["png", "jpg", "jpeg", "webp"].contains($0.pathExtension.lowercased()) }
        return files.sorted { lhs, rhs in
            numericKey(lhs.lastPathComponent) < numericKey(rhs.lastPathComponent)
        }
    }

    func isCourseDownloaded(_ course: CourseListModel) -> Bool {
        (try? extractedImageURLs(for: course).isEmpty == false) ?? false
    }

    private func numericKey(_ value: String) -> [Int] {
        value.split(whereSeparator: { !$0.isNumber }).compactMap { Int($0) }
    }
}
