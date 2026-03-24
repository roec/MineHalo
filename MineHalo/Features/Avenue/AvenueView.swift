import SwiftUI

struct AvenueView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                NavigationLink(destination: BannerDetailInfoView()) {
                    Text("今日活动 Banner")
                        .frame(maxWidth: .infinity)
                        .cardStyle()
                }.buttonStyle(.plain)
                ForEach(CourseCategory.allCases) { category in
                    NavigationLink("\(category.title) 课程介绍") {
                        CourseIntroView(category: category)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyle()
                }
                NavigationLink("成长报告") { GrowthReportView() }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyle()
            }
            .padding()
        }
        .navigationTitle("大街")
    }
}

struct BannerDetailInfoView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("活动详情")
            AppWebView(urlString: "https://api.xxllm.fun")
        }
        .padding()
    }
}

struct CourseIntroView: View {
    let category: CourseCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(category.title) 课程")
                .font(.title2.bold())
            Text("这里是\(category.title)课程介绍页面，可展示课程亮点、学习路线和成果展示。")
            Spacer()
        }
        .padding()
        .navigationTitle("课程介绍")
    }
}

struct GrowthReportView: View {
    var body: some View {
        ContentUnavailableView("成长报告建设中", systemImage: "chart.line.uptrend.xyaxis")
            .navigationTitle("成长报告")
    }
}
