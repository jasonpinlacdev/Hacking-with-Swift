//
//  WebViewController.swift
//  Project4 Easy Browser
//
//  Created by Jason Pinlac on 12/13/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    let allowedWebsites = ["www.hackingwithswift.com", "www.apple.com"]
    var selectedWebsite: String?
    var progressView: UIProgressView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progress = UIBarButtonItem(customView: progressView)
        let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        navigationController?.isToolbarHidden = false
        toolbarItems = [spacer, progress, back, forward, refresh]
        
        webView.load(URLRequest(url: URL(string: "https://\(selectedWebsite!)")!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//           let url = navigationAction.request.url
//
//           if let host = url?.host {
//               for website in allowedWebsites {
//                if host.contains(website) {
//                       decisionHandler(.allow)
//                       return
//                   }
//               }
//           }
//           decisionHandler(.cancel)
//           let ac = UIAlertController(title: "Blocked", message: "The page your trying to navigate is blocked.", preferredStyle: .alert)
//           ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//           present(ac, animated: true)
//
//       }
    
    
}
