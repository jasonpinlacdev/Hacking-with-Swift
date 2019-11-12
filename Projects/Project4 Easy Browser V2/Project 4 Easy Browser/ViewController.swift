//
//  ViewController.swift
//  Project 4 Easy Browser
//
//  Created by Jason Pinlac on 10/19/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//


//  Important Concepts Learned
//  1. loadView() - loadView() is called before viewDidLoad(). loadView() is called first, and it's where you create your view; viewDidLoad() is called second, and it's where you configure the view that was loaded. We use loadView() because we arent using storyboard to setup our view. We are directly assigning the view controllers view property to the webView

//  2. WKWebView
//  3. Delegation - Delegation is what allows us to customize the behavior of built-in types without having to sub-class them. To implement this design pattern you conform to a protocol
//  4. URL - URLs have their own specific data type in Swift, called URL.
//  5. URLRequest
//  6. UIToolbar - All view controllers have a toolbarItems property. This property is used to show buttons in a toolbar when the view controller is inside a navigation controller.
//  8. Key-Value observing - Key-value observing lets us monitor many kinds of properties.


import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
	
	var webView: WKWebView!
	var progressView: UIProgressView!
	let websites = ["apple.com", "hackingwithswift.com"]
	
	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//  Do any additional setup after loading the view.
		
		webView.allowsBackForwardNavigationGestures = true
		let url = URL(string: "https://" + websites[0])!
		webView.load(URLRequest(url: url))
		//  KVO (key value observing) set the observer
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(webPagesAlert))
		
		let goBackItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
		let goForwardItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
		let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressBarItem = UIBarButtonItem(customView: progressView)
		toolbarItems = [spacerItem, progressBarItem, goBackItem, goForwardItem, refreshItem]
		navigationController?.isToolbarHidden = false
		
	}
	
	
	
	
	
	@objc func webPagesAlert() {
		let ac = UIAlertController(title: "Open a page", message: nil, preferredStyle: .actionSheet)
		for website in websites {
			ac.addAction(UIAlertAction(title: website, style: .default, handler: openWebPage))
		}
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(ac, animated: true)
	}
	
	func openWebPage(action: UIAlertAction) {
		guard let actionTitle = action.title else { return }
		guard let url = URL(string: "https://" + actionTitle) else { return }
		webView.load(URLRequest(url: url))
	}

	//  On webpage didFinish viewController title is set to website title
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
	
	//  KVO (key value observing) when the observed value gets a new value invoke this method
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}
	
	//  Decide which webpages are allows access
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		
		let url = navigationAction.request.url
		if let host = url?.host {
			for website in websites {
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

