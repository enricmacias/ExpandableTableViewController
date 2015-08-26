//
//  CommonTableViewCell.swift
//  DemoExpandableTableViewController
//
//  Created by Enric Macias Lopez on 8/25/15.
//  Copyright (c) 2015 Enric Macias Lopez. All rights reserved.
//

import UIKit

class CommonTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var newIconImageView: UIImageView!
    @IBOutlet weak var arrowIndicatorImageView: UIImageView!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: Animations
    
    func openArrow(){
        UIView.animateWithDuration(0.25, animations: {
            self.arrowIndicatorImageView.transform = CGAffineTransformMakeRotation((CGFloat(M_PI) / 180.0)*0.0);
        })
    }
    
    func closeArrow(){
        UIView.animateWithDuration(0.25, animations: {
            self.arrowIndicatorImageView.transform = CGAffineTransformMakeRotation((CGFloat(M_PI) / 180.0)*180.0);
        })
    }
    
    func showSeparator(){
        self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(self.frame), 0, 0);
    }
    
    func hideSeparator(){
        self.separatorInset = UIEdgeInsetsZero;
    }

}
