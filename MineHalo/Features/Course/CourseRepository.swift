import Foundation

protocol CourseRepositoryProtocol {
    func fetchCourses(userId: String, category: CourseCategory) async throws -> [CourseListModel]
    func updateCourseStatus(userId: String, courseId: String, update: UpdateCourseStatusRequest) async throws
}

final class CourseRepository: CourseRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchCourses(userId: String, category: CourseCategory) async throws -> [CourseListModel] {
        let req = CourseListRequest(userId: userId, courseCategory: category.rawValue)
        let response: CourseListResponse = try await apiClient.send(.userCourseList, body: req)
        return response.courseList
    }

    func updateCourseStatus(userId: String, courseId: String, update: UpdateCourseStatusRequest) async throws {
        let _: APIResponse = try await apiClient.send(.updateCourseStatus(userId: userId, courseId: courseId), body: update)
    }
}
