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
    
    
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        
        if let data = documentData {
            let vc = UIActivityViewController(activityItems: [data], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let data = documentData {
            pdfView.document = PDFDocument(data: data as Data)
        }
    }
}
