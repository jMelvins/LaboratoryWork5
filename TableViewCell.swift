//
//  TableViewCell.swift
//  [laba 5] ios
//
//  Created by Vladislav Shilov on 04.06.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var timeDestinationLabel: UILabel!
    @IBOutlet weak var timeDepartureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var numberOfBusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
