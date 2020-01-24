//
//  DetailViewController.swift
//  Project16 Capital Cities
//
//  Created by Jason Pinlac on 1/24/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    var selectedCapital: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedCapital = selectedCapital else { return }
        let strippedSelectedCapital = selectedCapital.replacingOccurrences(of: " ", with: "")
        let urlString = "https://en.wikipedia.org/wiki/\(strippedSelectedCapital)"
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            print("View is loading: \(urlString)")
        }
    }


}
