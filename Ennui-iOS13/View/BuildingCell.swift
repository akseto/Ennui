//
//  BuildingCell.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-10-03.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit
import SwipeCellKit

class BuildingCell: SwipeTableViewCell {

    @IBOutlet weak var buildingName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
