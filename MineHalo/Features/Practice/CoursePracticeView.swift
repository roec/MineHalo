import SwiftUI

struct CoursePracticeView: View {
    var body: some View {
        List {
            Section("题库练习") {
                ForEach(CourseCategory.allCases) { category in
                    NavigationLink("\(category.title) 选择题") {
                        QuizView(category: category)
                    }
                }
            }
            Section("编程练习") {
                NavigationLink("C++ 沙盒练习") {
                    CPPPracticeView(courseId: "cpp-default")
                }
            }
        }
        .navigationTitle("练习")
    }
}
