import SwiftUI

struct CourseView: View {
    let images: [URL]
    @Environment(\.dismiss) private var dismiss
    @State private var index = 0

    var body: some View {
        NavigationStack {
            VStack {
                if let imageURL = images[safe: index],
                   let uiImage = UIImage(contentsOfFile: imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    ContentUnavailableView("暂无课件", systemImage: "photo")
                }
                HStack {
                    Button("上一页") { index = max(index - 1, 0) }
                    Spacer()
                    Text("\(min(index + 1, images.count))/\(images.count)")
                    Spacer()
                    Button("下一页") { index = min(index + 1, max(images.count - 1, 0)) }
                }
                .padding()
            }
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("关闭") { dismiss() } } }
        }
    }
}
