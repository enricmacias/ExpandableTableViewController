//
//  BirthdateTableViewCell.swift
//  DemoExpandableTableViewController
//
//  Created by Enric Macias Lopez on 8/25/15.
//  Copyright (c) 2015 Enric Macias Lopez. All rights reserved.
//

import UIKit

class BirthdateTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var birthdateLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
