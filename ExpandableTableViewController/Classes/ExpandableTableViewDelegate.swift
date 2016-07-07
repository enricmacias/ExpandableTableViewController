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
    func expandableTableView(expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int
    func expandableTableView(expandableTableView: ExpandableTableView, cellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell
    func expandableTableView(expandableTableView: ExpandableTableView, heightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
    func expandableTableView(expandableTableView: ExpandableTableView, estimatedHeightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
    func expandableTableView(expandableTableView: ExpandableTableView, didSelectRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath)
    
    // SubRows
    func expandableTableView(expandableTableView: ExpandableTableView, numberOfSubRowsInRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> Int
    func expandableTableView(expandableTableView: ExpandableTableView, subCellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell
    func expandableTableView(expandableTableView: ExpandableTableView, heightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
    func expandableTableView(expandableTableView: ExpandableTableView, estimatedHeightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
    func expandableTableView(expandableTableView: ExpandableTableView, didSelectSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath)
}