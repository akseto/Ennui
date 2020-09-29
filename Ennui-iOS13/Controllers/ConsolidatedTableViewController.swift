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
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var previewPDF: UIButton!
    
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
        
        //        let headerView: UIView = UIView.init(frame: CGRect(x: 1, y:50, width: tableView.frame.width, height: 50))
        //        let labelView: UILabel = UILabel.init(frame: CGRect(x: 4, y: 5, width: headerView.frame.width, height: 24))
        //        labelView.text = "\(String(describing: selectedList!.buildingName!)) Vacant Unit Checklist, \(selectedList!.date!)"
        //        headerView.addSubview(labelView)
        //        tableView.tableHeaderView = headerView
        
    
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "cell")
        //        scrollToBottom()
        //        scrollToTop()
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
            cell.itemTextView.textColor = UIColor.black
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
    
    //MARK: - PDF Generation Methods
    
    @IBAction func generatePdfPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Generate PDF?", message: "Before generating a PDF, scroll continuously from the top of the checklist to the bottom to ensure that all items are captured. Checklist items may be cut off if this step is missed.", preferredStyle: .alert)
        let scroll = UIAlertAction(title: "Scroll", style: .default) { (scroll) in
            self.scrollToTop()
        }
        let generatePDF = UIAlertAction(title: "Generate PDF", style: .default) { (generatePDF) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "PreviewPDF", sender: self)
            }
        }
        alert.addAction(scroll)
        alert.addAction(generatePDF)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func completePressed(_ sender: UIButton) {
//        scrollToTop {
//            scrollToBottom()
//        }
    }
    
    func createPdfFromTableView() -> NSMutableData {
        let page = CGRect(x: -25, y: 25, width: 612, height: 792)
        let pageWithMargin = CGRect(x: 0, y: 0, width: page.width-50, height: page.height-50)
        let fittedSize = tableView.sizeThatFits(CGSize(width:pageWithMargin.size.width, height:tableView.contentSize.height))
        tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, page, nil)
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(page, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += page.size.height
        }
        UIGraphicsEndPDFContext()
        tableView.bounds = pageWithMargin
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("vacantUnitChecklist.pdf")
        print(docURL)
        pdfData.write(to: docURL as URL, atomically: true)
        return pdfData
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // This method creates the PDF when the user calls the segue on the Preview button. It passes the PDF data to the destination PDFPreviewViewController.
        if segue.identifier == "PreviewPDF" {
            guard let vc = segue.destination as? PDFPreviewVC else { return }
            vc.documentData = createPdfFromTableView()
        }
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        let documentData = createPdfFromTableView()
        let vc = UIActivityViewController(activityItems: [documentData], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
}

extension ConsolidatedTableViewController {
    func scrollToBottom() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: self.tableView.numberOfSections-1)-1, section: self.tableView.numberOfSections - 1)
                if self.hasRowAtIndexPath(indexPath: indexPath) {
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }
    
    func scrollToTop() {
        UIView.animate(withDuration: 0.5) {
            let top = NSIndexPath(row: Foundation.NSNotFound, section: 0)
            self.tableView.scrollToRow(at: top as IndexPath, at: .top, animated: false)
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
