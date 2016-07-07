//
//  TitleTableViewCell.swift
//  DemoExpandableTableViewController
//
//  Created by Enric Macias Lopez on 8/25/15.
//  Copyright (c) 2015 Enric Macias Lopez. All rights reserved.
//

import UIKit

class TitleTableViewCell: CommonTableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
