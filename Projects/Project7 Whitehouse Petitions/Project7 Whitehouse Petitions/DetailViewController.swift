//
//  DetailViewController.swift
//  Project7 Whitehouse Petitions
//
//  Created by Jason Pinlac on 11/13/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let detailItem = detailItem {
            let html = """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style> body { font-size: 150% } </style>
            </head>
            <body>
            \(detailItem.body)
            </body>
            </html>
            """
            
            webView.loadHTMLString(html, baseURL: nil)
        }

    }
    
    
    
    
}
