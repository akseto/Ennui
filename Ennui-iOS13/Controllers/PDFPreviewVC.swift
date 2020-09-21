//
//  PDFPreviewVC.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-09-09.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit
import WebKit
import PDFKit

class PDFPreviewVC: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    
    public var documentData: NSMutableData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = documentData {
            pdfView.document = PDFDocument(data: data as Data)
        }
    }
}

//
//    var url: URL!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let req = NSMutableURLRequest(url: url)
//        req.timeoutInterval = 60.0
//        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
//
//        // webView.scalesPageToFit = true
//        webView.load(req as URLRequest)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//
//    @IBAction func close(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
//
//
//    func setupWithURL(_ url: URL) {
//        self.url = url
//    }

