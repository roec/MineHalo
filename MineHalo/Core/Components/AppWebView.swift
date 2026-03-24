import SwiftUI
import WebKit

struct AppWebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else { return }
        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }
}
