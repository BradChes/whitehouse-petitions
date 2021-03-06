//
//  DetailViewController.swift
//  whitehouse-petitions
//
//  Created by Bradley Chesworth on 15/02/2020.
//  Copyright © 2020 Brad Chesworth. All rights reserved.
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
        
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
            <h2>\(detailItem.title)</h2>
            <h3>Signatures: \(detailItem.signatureCount)</h3>
            <p>\(detailItem.body)</p>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
