//
//  ItemCell.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-08-28.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell, UITextViewDelegate {
    
    var delegate: ItemCellTableViewDelegate?
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var condition: UISegmentedControl!
    
    @IBAction func itemCondition(_ sender: UISegmentedControl) {
        delegate?.didSelectSegmentControlCell(cell: self)
    }
    

    @IBOutlet weak var itemTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemTextView.delegate = self
        if itemTextView.text.isEmpty {
            itemTextView.text = "Add comment"
            itemTextView.textColor = UIColor.gray
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        itemTextView.endEditing(true)
//        return true
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing(cell: self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(cell: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing(cell: self)
        resignFirstResponder()
    }
    
    
    
}

protocol ItemCellTableViewDelegate {
    func didSelectSegmentControlCell(cell: ItemCell)
    func textViewDidBeginEditing(cell: ItemCell)
    func textViewDidChange(cell: ItemCell)
    func textViewDidEndEditing(cell: ItemCell)
    
}

