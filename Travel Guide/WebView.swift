import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    var url: URL?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}
