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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: Animations
    
    func openArrow(){
        UIView.animate(withDuration: 0.25, animations: {
            self.arrowIndicatorImageView.transform = CGAffineTransform(rotationAngle: (CGFloat(M_PI) / 180.0)*0.0);
        })
    }
    
    func closeArrow(){
        UIView.animate(withDuration: 0.25, animations: {
            self.arrowIndicatorImageView.transform = CGAffineTransform(rotationAngle: (CGFloat(M_PI) / 180.0)*180.0);
        })
    }
    
    func showSeparator(){
        self.separatorInset = UIEdgeInsetsMake(0, self.frame.width, 0, 0);
    }
    
    func hideSeparator(){
        self.separatorInset = UIEdgeInsets.zero;
    }

}
