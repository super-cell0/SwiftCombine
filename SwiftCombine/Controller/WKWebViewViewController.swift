//
//  WKWebViewViewController.swift
//  SwiftCombine
//
//  Created by mac on 2023/9/25.
//

import UIKit
import WebKit

class WKWebViewViewController: UIViewController, WKNavigationDelegate {
    
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        self.webView.navigationDelegate = self
//        localHTML()
        loadURL()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadURL() {
        let url = URL(string: "https://www.apple.com.cn")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func localHTML() {
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
    
    //设置访问控制
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        /*
         if let host = navigationAction.request.url?.host(percentEncoded: true) {
             if host == "https://www.apple.com.cn" {
                 decisionHandler(.allow)
                 return
             }
         }
         decisionHandler(.cancel)
         */
        //访问外部浏览器
        if let host = navigationAction.request.url {
            if host.host(percentEncoded: true) == "https://www.apple.com.cn" {
                UIApplication.shared.open(host)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }

}
