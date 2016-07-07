//
//  ExpandableTableViewDelegate.swift
//  DemoExpandableTableViewController
//
//  Created by Enric Macias Lopez on 8/25/15.
//  Copyright (c) 2015 Enric Macias Lopez. All rights reserved.
//

import UIKit

public protocol ExpandableTableViewDelegate {
    
    // Rows
    func expandableTableView(expandableTableView: ExpandableTableView, didSelectRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath)
    
    // SubRows
    func expandableTableView(expandableTableView: ExpandableTableView, didSelectSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath)
}