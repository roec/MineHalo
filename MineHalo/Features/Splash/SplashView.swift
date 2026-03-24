import SwiftUI

struct SplashView: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.white)
                    .scaleEffect(pulse ? 1.12 : 0.95)
                Text("MineHalo")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("快乐学习，点亮成长")
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) { pulse = true }
        }
    }
}
