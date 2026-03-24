import SwiftUI

struct CourseListView: View {
    let category: CourseCategory
    @EnvironmentObject private var sessionStore: SessionStore
    @EnvironmentObject private var downloadManager: CourseDownloadManager
    @Environment(\.appContainer) private var container
    @StateObject private var holder = Holder()
    @State private var selectedImages: [URL] = []

    final class Holder: ObservableObject { @Published var vm: CourseListViewModel? }

    var body: some View {
        let vm = bindVM()
        List {
            ForEach(vm.courses, id: \.id) { course in
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(course.courseNo) - \(course.courseName)").font(.headline)
                    HStack {
                        Button("开始学习") {
                            Task {
                                do { selectedImages = try await vm.start(course: course) }
                                catch { vm.errorMessage = error.localizedDescription }
                            }
                        }.buttonStyle(.borderedProminent)
                        if course.hasExams {
                            NavigationLink("去练习") {
                                CPPPracticeView(courseId: course.courseId)
                            }
                        }
                        Button("指导师") {}
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .navigationTitle(category.title)
        .task { await vm.load(category: category) }
        .alert("提示", isPresented: Binding(get: { vm.errorMessage != nil }, set: { _ in vm.errorMessage = nil })) {
            Button("知道了", role: .cancel) {}
        } message: {
            Text(vm.errorMessage ?? "")
        }
        .fullScreenCover(isPresented: Binding(get: { !selectedImages.isEmpty }, set: { if !$0 { selectedImages = [] } })) {
            CourseView(images: selectedImages)
        }
    }

    private func bindVM() -> CourseListViewModel {
        if holder.vm == nil {
            holder.vm = CourseListViewModel(sessionStore: sessionStore, repository: container.courseRepository, downloadManager: downloadManager)
        }
        guard let vm = holder.vm else {
            let fallback = CourseListViewModel(sessionStore: sessionStore, repository: container.courseRepository, downloadManager: downloadManager)
            holder.vm = fallback
            return fallback
        }
        return vm
    }
}
