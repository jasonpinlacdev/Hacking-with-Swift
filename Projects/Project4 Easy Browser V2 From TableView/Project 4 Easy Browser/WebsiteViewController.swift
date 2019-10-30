//
//  WebsiteViewController.swift
//  Project 4 Easy Browser
//
//  Created by Jason Pinlac on 10/19/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController, WKNavigationDelegate  {
	
	var chosenWebsite: String?
	var websitesAllowed: [String]?
	
	var webView: WKWebView!
	var progressView: UIProgressView!
	
	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView.allowsBackForwardNavigationGestures = true
		navigationController?.isToolbarHidden = false
		
		// Load the chosen website.
		if let chosenWebsite = chosenWebsite {
			if let url = URL(string: "https://" + chosenWebsite) {
				print(url.absoluteString)
				webView.load(URLRequest(url: url))
			}
		}
		
		let goBackItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
		let goForwardItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
		let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressBarItem = UIBarButtonItem(customView: progressView)
		toolbarItems = [spacerItem, progressBarItem, goBackItem, goForwardItem, refreshItem]
		
		// KVO (key value observing) set the observer.
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		
	}
	// MARK: - ViewDidLoad() above this line
	
	
	
	
	
	// On webpage didFinish viewController title is set to website title.
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
	
	// webView progress KVO to progressBarItem (key value observing) when the observed value gets a new value invoke this method.
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}
	
	// Decide which webpages are allows access.
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		if let host = url?.host {
			for website in websitesAllowed! {
				if host.contains(website) {
					decisionHandler(.allow)
					return
				}
			}
		}
		let ac = UIAlertController(title: "Stop!", message: "This webpage is blocked.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
		present(ac, animated: true)
		decisionHandler(.cancel)
	}
	
}
