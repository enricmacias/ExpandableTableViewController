//
//  ExpandableTableViewController.swift
//  scc
//
//  Created by Enric Macias Lopez on 6/25/15.
//  Copyright (c) 2015 株式会社ガラパゴス. All rights reserved.
//

import UIKit

enum ExpandableCellType: Int {
    case MainCell, SubCell
}

public struct ExpandableIndexPath{
    public var section = 0
    public var row = 0
    public var subRow = 0
    
    init(forSection aSection: Int, forRow aRow: Int, forSubRow aSubRow: Int) {
        section = aSection
        row = aRow
        subRow = aSubRow
    }
    
    func string() ->String{
        return String(section)+String(row)+String(subRow)
    }
}

public class ExpandableTableView: UITableView {
    
    public weak var parentViewController: ExpandableTableViewController! = nil
    public var expandableDelegate: ExpandableTableViewDelegate!
    
    public func cellForRowAtIndexPath(expandableIndexPath: ExpandableIndexPath) -> UITableViewCell?{
        return parentViewController.indexedCells[expandableIndexPath.string()]
    }
    
    public func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell{
        return self.dequeueReusableCellWithIdentifier(identifier, forIndexPath: parentViewController.indexPathForExpandableIndexPath(expandableIndexPath)) 
    }
    
    public func isCellExpandedAtExpandableIndexPath(expandableIndexPath:ExpandableIndexPath) -> Bool{
        let indexPath = parentViewController.indexPathForExpandableIndexPath(expandableIndexPath)
        
        if parentViewController.cellsTypeArray.get(indexPath.row) == .MainCell{
            let newIndexPath: NSIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            
            if parentViewController.cellsTypeArray.get(newIndexPath.row) == .SubCell{
                return true
            }
            else{
                return false
            }
        }
        
        return false
    }
    
    public func deselectRowAtExpandableIndexPath(expandableIndexPath: ExpandableIndexPath, animated: Bool){
        self.deselectRowAtIndexPath(parentViewController.indexPathForExpandableIndexPath(expandableIndexPath), animated: animated)
    }
}

public class ExpandableTableViewController: UITableViewController {
    
    // MARK: Properties
    private var cellsTypeArray: [ExpandableCellType] = []
    private var indexedCells: Dictionary<String,UITableViewCell> = [:]
    
    @IBOutlet public var expandableTableView: ExpandableTableView!

    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        expandableTableView.parentViewController = self
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init
    
    private func initExpandableTableViewWithNumberOfRows(numOfRows : Int){
        if numOfRows > 0 {
            for _ in 0...(numOfRows - 1){
                cellsTypeArray.append(.MainCell)
            }
        }
    }
    
    // MARK: - Public methods
    
    public func unexpandAllCells(){
        for (index,cellType) in cellsTypeArray.enumerate(){
            if cellType == .MainCell{
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                let nextIndexPath: NSIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                
                if cellsTypeArray.get(nextIndexPath.row) == .SubCell{
                    tableView(tableView, didSelectRowAtIndexPath: indexPath)
                    unexpandAllCells()
                    break
                }
            }
        }
    }
    
    private func expandableIndexPathForIndexPath(indexPath: NSIndexPath) -> ExpandableIndexPath{
        
        return ExpandableIndexPath(forSection: indexPath.section, forRow: rowIndexForRow(indexPath.row), forSubRow: subrowIndexForRow(indexPath.row))
    }
    
    private func indexPathForExpandableIndexPath(expandableIndexPath: ExpandableIndexPath) -> NSIndexPath{
        var index = 0
        var mainCellIndex = -1
        var subCellIndex = -1
        
        for cellType in cellsTypeArray{
            if cellType == .MainCell{
                mainCellIndex = mainCellIndex + 1
                subCellIndex = -1
            }
            else if cellType == .SubCell{
                subCellIndex = subCellIndex + 1
            }
            
            if (mainCellIndex == expandableIndexPath.row) && (subCellIndex == expandableIndexPath.subRow){
                return NSIndexPath(forRow: index, inSection: 0)
            }
            
            index = index + 1
        }
        
        return NSIndexPath(forRow: -1, inSection: -1)
    }
    
    // MARK: - Private methods
    
    private func rowIndexForRow(row: Int) -> Int{
        var rowIndex : Int = row
        
        // Finds the mother row
        var found : Bool = false
        while !found{
            if cellsTypeArray.get(rowIndex) == .MainCell{
                found = true
            }
            else{
                rowIndex = rowIndex - 1
            }
        }
        
        // Creates a correct index for the user's datasource
        var index: Int
        for index = rowIndex; index >= 0; --index {
            // We substract 1 for each subcell
            if cellsTypeArray.get(index) == .SubCell{
                rowIndex = rowIndex - 1
            }
        }
        
        return rowIndex
    }
    
    private func subrowIndexForRow(row: Int) -> Int{
        var rowIndex : Int = row
        
        var subrowIndex = -1
        while cellsTypeArray.get(rowIndex) == .SubCell{
            subrowIndex = subrowIndex + 1
            rowIndex = rowIndex - 1
        }
        
        return subrowIndex
    }
    
    private func numberOfMainCells() -> Int{
        var numberOfMainCells = 0
        
        for cellType in cellsTypeArray{
            if cellType == .MainCell{
                numberOfMainCells = numberOfMainCells + 1
            }
        }
        
        return numberOfMainCells
    }
    
    private func expandCellAtIndexPath(indexPath: NSIndexPath, tableView:UITableView){
        var newIndexPath: NSIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        var tableViewContentOffset = self.tableView.contentOffset
        var indexesArray: [NSIndexPath] = []
        
        let numberOfSubCells = expandableTableView.expandableDelegate.expandableTableView(expandableTableView, numberOfSubRowsInRowAtExpandableIndexPath: expandableIndexPath)
        var heightForNewRows: CGFloat = 0.0
        for _ in 0...(numberOfSubCells - 1){
            indexesArray.append(newIndexPath.copy() as! NSIndexPath)
            self.cellsTypeArray.insert(.SubCell, atIndex: newIndexPath.row)
            newIndexPath = NSIndexPath(forRow: newIndexPath.row + 1, inSection: indexPath.section)
            
            heightForNewRows = heightForNewRows + self.tableView(tableView, heightForRowAtIndexPath: newIndexPath)
        }
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(indexesArray, withRowAnimation: UITableViewRowAnimation.Middle)
        tableView.endUpdates()
        
        // Avoids an old-fashioned scrolling to the top when inserting cells and the table view is scrolled.
        if tableViewContentOffset.y > 0{
            tableViewContentOffset.y = tableViewContentOffset.y + heightForNewRows
            if UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending{
                // iOS 7
                // Avoids an occasional not desired animation in i0S 7
                self.tableView.setContentOffset(tableViewContentOffset, animated: false)
            }
            else{
                self.tableView.setContentOffset(tableViewContentOffset, animated: true)
            }
            
        }
    }
    
    private func unexpandCellAtIndexPath(indexPath: NSIndexPath, tableView:UITableView){
        var newIndexPath: NSIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        var tableViewContentOffset = self.tableView.contentOffset
        var indexesArray: [NSIndexPath] = []
        
        let numberOfSubCells = expandableTableView.expandableDelegate.expandableTableView(expandableTableView, numberOfSubRowsInRowAtExpandableIndexPath: expandableIndexPath)
        var heightForNewRows: CGFloat = 0.0
        for _ in 0...(numberOfSubCells - 1){
            indexesArray.append(newIndexPath.copy() as! NSIndexPath)
            self.cellsTypeArray.removeAtIndex(indexPath.row + 1)
            newIndexPath = NSIndexPath(forRow: newIndexPath.row + 1, inSection: indexPath.section)
            
            heightForNewRows = heightForNewRows + self.tableView(tableView, heightForRowAtIndexPath: newIndexPath)
        }
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths(indexesArray, withRowAnimation: UITableViewRowAnimation.Middle)
        tableView.endUpdates()
        
        // Avoids an old-fashioned scrolling to the top when deleting cells and the table view is scrolled.
        if tableViewContentOffset.y > 0{
            tableViewContentOffset.y = tableViewContentOffset.y - heightForNewRows
            if UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending{
                // iOS 7
                // Avoids an occasional not desired animation in i0S 7
                self.tableView.setContentOffset(tableViewContentOffset, animated: false)
            }
            else{
                self.tableView.setContentOffset(tableViewContentOffset, animated: true)
            }
        }
    }

    // MARK: - Table view data source
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfRows = expandableTableView.expandableDelegate.expandableTableView(expandableTableView, numberOfRowsInSection: section)
        
        if numOfRows != numberOfMainCells(){
            cellsTypeArray = []
            self.initExpandableTableViewWithNumberOfRows(numOfRows)
        }
        
        return cellsTypeArray.count
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        
        if cellsTypeArray.get(indexPath.row) == .MainCell {
            cell = expandableTableView.expandableDelegate.expandableTableView(expandableTableView, cellForRowAtExpandableIndexPath: expandableIndexPath)
        }
        else if cellsTypeArray.get(indexPath.row) == .SubCell {
            cell = expandableTableView.expandableDelegate.expandableTableView(expandableTableView, subCellForRowAtExpandableIndexPath: expandableIndexPath)
        }
        
        print(indexPath)
        print(cell)
        
        indexedCells[expandableIndexPath.string()] = cell
        
        return cell
    }
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        
        if cellsTypeArray.get(indexPath.row) == .MainCell {
            return expandableTableView.expandableDelegate.expandableTableView(expandableTableView, heightForRowAtExpandableIndexPath: expandableIndexPath)
        }
        else if cellsTypeArray.get(indexPath.row) == .SubCell {
            return expandableTableView.expandableDelegate.expandableTableView(expandableTableView, heightForSubRowAtExpandableIndexPath: expandableIndexPath)
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        
        if cellsTypeArray.get(indexPath.row) == .MainCell {
            return expandableTableView.expandableDelegate.expandableTableView(expandableTableView, estimatedHeightForRowAtExpandableIndexPath: expandableIndexPath)
        }
        else if cellsTypeArray.get(indexPath.row) == .SubCell {
            return expandableTableView.expandableDelegate.expandableTableView(expandableTableView, estimatedHeightForSubRowAtExpandableIndexPath: expandableIndexPath)
        }
        
        return super.tableView(tableView, estimatedHeightForRowAtIndexPath: indexPath)
    }

    // MARK: - Table view delegate
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        
        if cellsTypeArray.get(indexPath.row) == .MainCell{
            let newIndexPath: NSIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            
            if cellsTypeArray.get(newIndexPath.row) != .SubCell{
                expandCellAtIndexPath(indexPath, tableView: tableView)
            }
            else{
                unexpandCellAtIndexPath(indexPath, tableView: tableView)
            }
            
            expandableTableView.expandableDelegate.expandableTableView(expandableTableView, didSelectRowAtExpandableIndexPath: expandableIndexPath)
        }
        else if cellsTypeArray.get(indexPath.row) == .SubCell {
            expandableTableView.expandableDelegate.expandableTableView(expandableTableView, didSelectSubRowAtExpandableIndexPath: expandableIndexPath)
        }
    }
}
