import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack { StudyHomeView() }
                .tabItem { Label("学习", systemImage: "book.fill") }

            NavigationStack { CoursePracticeView() }
                .tabItem { Label("练习", systemImage: "pencil.and.outline") }

            NavigationStack { AvenueView() }
                .tabItem { Label("大街", systemImage: "sparkles") }

            NavigationStack { ProfileView() }
                .tabItem { Label("我的", systemImage: "person.fill") }
        }
    }
}
