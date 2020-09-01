//
//  ItemCell.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-08-28.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: ItemCellTableViewDelegate?
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var condition: UISegmentedControl!
    
    @IBAction func itemCondition(_ sender: UISegmentedControl) {
        delegate?.didSelectSegmentControlCell(cell: self)
    }
    
    @IBOutlet weak var itemTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         delegate?.textFieldDidEndEditing(cell: self)
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemTextField.endEditing(true)
        return true
    }
    
    
}

protocol ItemCellTableViewDelegate {
    func didSelectSegmentControlCell(cell: ItemCell)
    func textFieldDidEndEditing(cell: ItemCell)
}

