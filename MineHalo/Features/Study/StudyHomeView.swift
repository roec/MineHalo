import SwiftUI

struct StudyHomeView: View {
    @State private var showGuide = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                BannerCardView()
                Text("课程导学")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(CourseCategory.allCases) { category in
                    NavigationLink(destination: CourseListView(category: category)) {
                        HStack {
                            Text(category.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .cardStyle()
                    }
                    .buttonStyle(.plain)
                }
                Button("指导师") { showGuide.toggle() }
            }
            .padding()
        }
        .navigationTitle("学习")
        .sheet(isPresented: $showGuide) {
            TeacherGuideSidebarView()
        }
    }
}

private struct BannerCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("今日推荐")
                .font(.headline)
            Text("坚持学习，解锁你的知识光环！")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

struct TeacherGuideSidebarView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("1. 按顺序学习课程内容。")
                Text("2. 每节课完成后进入练习巩固。")
                Text("3. 遇到问题先查看提示，再尝试代码调试。")
            }
            .navigationTitle("指导师建议")
        }
    }
}
