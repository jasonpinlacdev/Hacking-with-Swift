//
//  ViewController.swift
//  Project4 Easy Browser
//
//  Created by Jason Pinlac on 10/18/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit
import WebKit

// Delegate design patter where our class will implement and conform to the WKNavigationDelegate protocol
class ViewController: UIViewController, WKNavigationDelegate {
	
	var webView: WKWebView!
	var progressView: UIProgressView!
	var websitesAllowed = ["apple.com", "hackingwithswift.com"]
	
	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
		
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)
		
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		 
		toolbarItems = [spacer, progressButton, refreshButton]
		navigationController?.isToolbarHidden = false
		
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		
		
		let url = URL(string: "https://" + websitesAllowed[0])!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
		
	}
	
	@objc func openTapped() {
		let ac = UIAlertController(title: "Select a web page to open", message: nil, preferredStyle: .actionSheet)
		
		for webSite in websitesAllowed {
			ac.addAction(UIAlertAction(title: webSite, style: .default, handler: openPage))
		}
		 
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(ac, animated: true)
	}

	func openPage(action: UIAlertAction) {
		guard let actionTitle = action.title else { print("ERROR"); return }
		guard let url =  URL(string: "https://" + actionTitle) else { print("ERROR"); return }
		webView.load(URLRequest(url: url))
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		if let host = url?.host {
			for website in websitesAllowed {
				if host.contains(website) {
					decisionHandler(.allow)
					return
				}
			}
		}
		decisionHandler(.cancel)
	}
	
	

}

