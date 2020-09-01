//
//  NewList.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-08-26.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit
import SwipeCellKit

class NewList: SwipeTableViewCell {

    @IBOutlet weak var tenantName: UILabel!
    
    @IBOutlet weak var premises: UILabel!
        
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
