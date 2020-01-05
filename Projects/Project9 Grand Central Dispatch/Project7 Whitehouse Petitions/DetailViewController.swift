//
//  DetailViewController.swift
//  Project7 Whitehouse Petitions
//
//  Created by Jason Pinlac on 12/29/19.
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
            let html =
            """
            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                            body {font-size: 150%; background-color: black; color: white;}
                    </style>
                </head>
                <body>
                    <strong>(\(detailItem.signatureCount)) \(detailItem.title)</strong>
                    <hr/>
                    \(detailItem.body)
                </body>
            </html>
            """
            webView.loadHTMLString(html, baseURL: nil)
        }
        
    }
    
}
