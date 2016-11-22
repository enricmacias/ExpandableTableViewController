//
//  ExpandableTableViewDatasource.swift
//  DemoExpandableTableViewController
//
//  Created by Enric Macias Lopez on 8/25/15.
//  Copyright (c) 2015 Enric Macias Lopez. All rights reserved.
//

import UIKit

public protocol ExpandableTableViewDelegate {
    
    // Rows
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
    func expandableTableView(_ expandableTableView: ExpandableTableView, estimatedHeightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath)
    
    // SubRows
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfSubRowsInRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> Int
    func expandableTableView(_ expandableTableView: ExpandableTableView, subCellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
    func expandableTableView(_ expandableTableView: ExpandableTableView, estimatedHeightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath)
}
