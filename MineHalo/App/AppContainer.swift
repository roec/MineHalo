import Foundation
import SwiftUI

final class AppContainer: ObservableObject {
    let apiClient: APIClientProtocol
    let keychain: KeychainStoreProtocol
    let preferences: UserPreferencesProtocol
    let localCourseStore: LocalCourseStoreProtocol
    let authRepository: AuthRepositoryProtocol
    let courseRepository: CourseRepositoryProtocol
    let practiceRepository: PracticeRepositoryProtocol
    let sandboxRepository: SandboxRepositoryProtocol

    let sessionStore: SessionStore
    let router: AppRouter
    let downloadManager: CourseDownloadManager
    let theme: ThemeManager

    init(apiClient: APIClientProtocol,
         keychain: KeychainStoreProtocol,
         preferences: UserPreferencesProtocol,
         localCourseStore: LocalCourseStoreProtocol,
         authRepository: AuthRepositoryProtocol,
         courseRepository: CourseRepositoryProtocol,
         practiceRepository: PracticeRepositoryProtocol,
         sandboxRepository: SandboxRepositoryProtocol,
         sessionStore: SessionStore,
         router: AppRouter,
         downloadManager: CourseDownloadManager,
         theme: ThemeManager) {
        self.apiClient = apiClient
        self.keychain = keychain
        self.preferences = preferences
        self.localCourseStore = localCourseStore
        self.authRepository = authRepository
        self.courseRepository = courseRepository
        self.practiceRepository = practiceRepository
        self.sandboxRepository = sandboxRepository
        self.sessionStore = sessionStore
        self.router = router
        self.downloadManager = downloadManager
        self.theme = theme
    }

    static func bootstrap() -> AppContainer {
        let keychain = KeychainStore()
        let preferences = UserPreferences()
        guard let baseURL = URL(string: "https://api.xxllm.fun") else {
            preconditionFailure("Invalid base URL")
        }
        let apiClient = APIClient(baseURL: baseURL, tokenProvider: { keychain.read(key: .authToken) })
        let localStore = LocalCourseStore()
        let authRepository = AuthRepository(apiClient: apiClient)
        let courseRepository = CourseRepository(apiClient: apiClient)
        let practiceRepository = PracticeRepository(apiClient: apiClient)
        let sandboxRepository = SandboxRepository(apiClient: apiClient)
        let sessionStore = SessionStore(authRepository: authRepository, keychain: keychain, preferences: preferences)
        let router = AppRouter(sessionStore: sessionStore)
        let downloadManager = CourseDownloadManager(apiClient: apiClient, localStore: localStore)

        return AppContainer(apiClient: apiClient,
                            keychain: keychain,
                            preferences: preferences,
                            localCourseStore: localStore,
                            authRepository: authRepository,
                            courseRepository: courseRepository,
                            practiceRepository: practiceRepository,
                            sandboxRepository: sandboxRepository,
                            sessionStore: sessionStore,
                            router: router,
                            downloadManager: downloadManager,
                            theme: ThemeManager())
    }
}
