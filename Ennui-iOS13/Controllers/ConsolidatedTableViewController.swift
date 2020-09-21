//
//  ConsolidatedTableViewController.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-09-01.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit
import CoreData

class ConsolidatedTableViewController: UITableViewController, ItemCellTableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    var items = [Item]()
    var premises1 = [Item]()
    var premises2 = [Item]()
    var premises3 = [Item]()
    var premises4 = [Item]()
    var premises5 = [Item]()
    var itemArrays = [[Item]]()
    
    
    @IBOutlet weak var checklistSubview: UIView!
    
    var selectedList: Lists? {
        didSet {
            loadItems()
            sortItems()
            itemArrays = appendItemArray()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        title = selectedList?.buildingName
        let headerView: UIView = UIView.init(frame: CGRect(x: 1, y:50, width: tableView.frame.width, height: 50))
        let labelView: UILabel = UILabel.init(frame: CGRect(x: 4, y: 5, width: headerView.frame.width, height: 24))
        labelView.text = "\(String(describing: selectedList!.buildingName!));\(selectedList!.date!)"
        headerView.addSubview(labelView)
        tableView.tableHeaderView = headerView
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "cell")
        scrollToBottom()
        scrollToTop()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemArrays.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        switch itemArrays[section] {
        case premises1:
            sectionTitle = selectedList!.premises1!
        case premises2:
            sectionTitle = selectedList!.premises2!
        case premises3:
            sectionTitle = selectedList!.premises3!
        case premises4:
            sectionTitle = selectedList!.premises4!
        case premises5:
            sectionTitle = selectedList!.premises5!
        default:
            break
        }
        return sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrays[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCell
        cell.delegate = self
        cell.itemName.text = itemArrays[indexPath.section][indexPath.row].title
        if itemArrays[indexPath.section][indexPath.row].comments == nil {
            cell.itemTextView.text = "Add comment"
            cell.itemTextView.textColor = UIColor.lightGray
        } else {
            cell.itemTextView.text = itemArrays[indexPath.section][indexPath.row].comments
        }
        switch itemArrays[indexPath.section][indexPath.row].selectedSegment {
        case "Good":
            cell.condition.selectedSegmentIndex = 0
        case "Fair":
            cell.condition.selectedSegmentIndex = 1
        case "Poor":
            cell.condition.selectedSegmentIndex = 2
        case "N/A":
            cell.condition.selectedSegmentIndex = 3
        default:
            cell.condition.selectedSegmentIndex = -1
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        generatePDF()
        
    }
    
    
    //MARK: - ItemCell Delegate Methods
   
    func didSelectSegmentControlCell(cell: ItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            itemArrays[indexPath.section][indexPath.row].selectedSegment = cell.condition.titleForSegment(at: cell.condition.selectedSegmentIndex)
        }
        saveItems()
    }
    
    func textViewDidBeginEditing(cell: ItemCell) {
        if cell.itemTextView.textColor == UIColor.lightGray {
            cell.itemTextView.text = nil
            cell.itemTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(cell: ItemCell) {
        cell.itemTextView.textContainer.heightTracksTextView = true
        cell.itemTextView.isScrollEnabled = false
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func textViewDidEndEditing(cell: ItemCell) {
        cell.itemTextView.resignFirstResponder()
        if let indexPath = tableView.indexPath(for: cell) {
            if cell.itemTextView.text.isEmpty {
                cell.itemTextView.text = "Add comment"
                cell.itemTextView.textColor = UIColor.lightGray
            } else {
                itemArrays[indexPath.section][indexPath.row].comments = cell.itemTextView.text
                cell.itemTextView.endEditing(true)
            }
        }
        saveItems()
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let listPredicate = NSPredicate(format: "parentList.buildingName MATCHES %@", selectedList!.buildingName!)
        request.predicate = listPredicate
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        print("items loaded")
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func appendItemArray () -> [[Item]] {
        if selectedList!.premises1 != "" {
            itemArrays.append(premises1)
        }
        if selectedList!.premises2 != "" {
            itemArrays.append(premises2)
        }
        if selectedList!.premises3 != "" {
            itemArrays.append(premises3)
        }
        if selectedList!.premises4 != "" {
            itemArrays.append(premises4)
        }
        if selectedList!.premises5 != "" {
            itemArrays.append(premises5)
        }
        
        return itemArrays
    }
    
    func sortItems() {
        for item in items {
            switch item.premisesIndex {
            case 0:
                if selectedList!.premises1 != nil {
                    premises1.append(item)
                    premises1.sort(by: { $0.itemIndex < $1.itemIndex })
                }
            case 1:
                if selectedList!.premises2 != nil {
                    premises2.append(item)
                    premises2.sort(by: { $0.itemIndex < $1.itemIndex })
                }
            case 2:
                if selectedList!.premises3 != nil {
                    premises3.append(item)
                    premises3.sort(by: { $0.itemIndex < $1.itemIndex })
                }
            case 3:
                if selectedList!.premises4 != nil {
                    premises4.append(item)
                    premises4.sort(by: { $0.itemIndex < $1.itemIndex })
                }
            case 4:
                if selectedList!.premises5 != nil {
                    premises5.append(item)
                    premises5.sort(by: { $0.itemIndex < $1.itemIndex })
                }
            default:
                break
            }
        }
        print("items sorted")
    }
    
    //MARK: - Generate PDF using Internet Inquiries
    
    //FUNC that is supposed to create multi-page PDF direct from tableView
    func createPdfFromTableView() -> NSMutableData {
        let priorBounds = tableView.bounds
        let fittedSize = tableView.sizeThatFits(CGSize(width:priorBounds.size.width, height:tableView.contentSize.height))
        tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
        let pdfPageBounds = CGRect(x:0, y:0, width:tableView.frame.width, height:self.view.frame.height)
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds,nil)
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += pdfPageBounds.size.height
        }
        UIGraphicsEndPDFContext()
        tableView.bounds = priorBounds
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("myDocument.pdf")
        print(docURL)
        pdfData.write(to: docURL as URL, atomically: true)
        return pdfData
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // This method creates the PDF when the user calls the segue on the Preview button. It passes the PDF data to the destination PDFPreviewViewController.
        
        if segue.identifier == "PreviewVC" {
            guard let vc = segue.destination as? PDFPreviewVC else { return }
            //        let createdImg = createImg()
            //        vc.documentData = createPDFDataFromImage(image: createdImg)
            vc.documentData = createPdfFromTableView()
        }
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        //        let createdImg = createImg()
        //        let documentData = createPDFDataFromImage(image: createdImg)
        let documentData = createPdfFromTableView()
        let vc = UIActivityViewController(activityItems: [documentData], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    //    func createImg() -> UIImage {
    //        guard tableView.numberOfSections > 0, tableView.numberOfRows(inSection: 0) > 0 else {
    //            let errorImage = UIImage(named: "Error Image")
    //            return errorImage!
    //        }
    //        UIGraphicsBeginImageContextWithOptions(CGSize(width: tableView.contentSize.width, height: tableView.contentSize.height), false, 0.0)
    //        let context = UIGraphicsGetCurrentContext()
    //        let previousFrame = tableView.frame
    //        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.contentSize.width, height: tableView.contentSize.height)
    //        tableView.layer.render(in: context!)
    //        tableView.frame = previousFrame
    //        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    //        UIGraphicsEndImageContext()
    //
    //        return image
    //    }
    
    //    func createPDFDataFromImage(image: UIImage) -> NSMutableData {
    //        let pdfData = NSMutableData()
    //        let imgView = UIImageView.init(image: image)
    //        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    //        let pdfPageBounds = CGRect(x:0, y:0, width: imgView.frame.width, height:self.view.frame.height)
    //        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
    //        var pageOriginY: CGFloat = 0
    //        while pageOriginY < image.size.height {
    //            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
    //            UIGraphicsGetCurrentContext()!.saveGState()
    //            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
    //            imgView.layer.render(in: UIGraphicsGetCurrentContext()!)
    //            UIGraphicsGetCurrentContext()!.restoreGState()
    //            pageOriginY += pdfPageBounds.size.height
    //        }
    //        UIGraphicsEndPDFContext()
    //
    //        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    //        let path = directory?.appendingPathComponent("vacantUnitChecklist.pdf")
    //        do {
    //            try pdfData.write(to: path!, options: NSData.WritingOptions.atomic)
    //        } catch {
    //            print("error catched")
    //        }
    
    //        let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
    //        activityViewController.popoverPresentationController?.sourceView = self.view
    //        self.present(activityViewController, animated: true, completion: nil)
    
    //        return pdfData
    //    }
    
    
    
    //MARK: - Generate PDF from TableView - PDFGenerator
    
    //    @objc fileprivate func generatePDF() {
    //        do {
    //            let dst = NSHomeDirectory() + "/sample_tblview.pdf"
    //            try PDFGenerator.generate(self.tableView, to: dst)
    //            openPDFViewer(dst)
    //        } catch let error {
    //            print(error)
    //        }
    //
    //    }
    //
    //    fileprivate func openPDFViewer(_ pdfPath: String) {
    //        self.performSegue(withIdentifier: "PreviewVC", sender: pdfPath)
    //    }
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let pdfPreviewVC = segue.destination as? PDFPreviewVC, let pdfPath = sender as? String {
    //            let url = URL(fileURLWithPath: pdfPath)
    //            pdfPreviewVC.setupWithURL(url)
    //        }
    //    }
    
}

extension ConsolidatedTableViewController {
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: self.tableView.numberOfSections-1)-1, section: self.tableView.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.tableView.numberOfSections && indexPath.row < self.tableView.numberOfRows(inSection: indexPath.section)
    }
    
}

extension UITableView {
    
    func setAndLayoutTableHeaderView(header: UIView) {
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        self.tableHeaderView = header
    }
    
}
