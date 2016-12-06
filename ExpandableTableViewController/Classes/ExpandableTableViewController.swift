//
//  ExpandableTableViewController.swift
//
//  Created by Enric Macias Lopez on 6/25/15.
//

import UIKit

enum ExpandableCellType: Int {
    case mainCell, subCell
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

open class ExpandableTableView: UITableView {
    
    open weak var parentViewController: ExpandableTableViewController! = nil
    open var expandableDelegate: ExpandableTableViewDelegate!
    
    open func cellForRowAtIndexPath(_ expandableIndexPath: ExpandableIndexPath) -> UITableViewCell?{
        return parentViewController.indexedCells[expandableIndexPath.string()]
    }
    
    open func dequeueReusableCellWithIdentifier(_ identifier: String, forIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell{
        return self.dequeueReusableCell(withIdentifier: identifier, for: parentViewController.indexPathForExpandableIndexPath(expandableIndexPath)) 
    }
    
    open func isCellExpandedAtExpandableIndexPath(_ expandableIndexPath:ExpandableIndexPath) -> Bool{
        let indexPath = parentViewController.indexPathForExpandableIndexPath(expandableIndexPath)
        
        if parentViewController.cellsTypeArray.get(indexPath.row) == .mainCell{
            let newIndexPath: IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            
            if parentViewController.cellsTypeArray.get(newIndexPath.row) == .subCell{
                return true
            }
            else{
                return false
            }
        }
        
        return false
    }
    
    open func deselectRowAtExpandableIndexPath(_ expandableIndexPath: ExpandableIndexPath, animated: Bool){
        self.deselectRow(at: parentViewController.indexPathForExpandableIndexPath(expandableIndexPath), animated: animated)
    }
}

open class ExpandableTableViewController: UITableViewController {
    
    // MARK: Properties
    fileprivate var cellsTypeArray: [ExpandableCellType] = []
    fileprivate var indexedCells: Dictionary<String,UITableViewCell> = [:]
    
    @IBOutlet open var expandableTableView: ExpandableTableView!

    // MARK: - Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        expandableTableView.parentViewController = self
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init
    
    fileprivate func initExpandableTableViewWithNumberOfRows(_ numOfRows : Int){
        if numOfRows > 0 {
            for _ in 0...(numOfRows - 1){
                cellsTypeArray.append(.mainCell)
            }
        }
    }
    
    // MARK: - Public methods
    
    open func unexpandAllCells(){
        for (index,cellType) in cellsTypeArray.enumerated(){
            if cellType == .mainCell{
                let indexPath = IndexPath(row: index, section: 0)
                let nextIndexPath: IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                
                if cellsTypeArray.get(nextIndexPath.row) == .subCell{
                    tableView(tableView, didSelectRowAt: indexPath)
                    unexpandAllCells()
                    break
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    fileprivate func expandableIndexPathForIndexPath(_ indexPath: IndexPath) -> ExpandableIndexPath{
        
        return ExpandableIndexPath(forSection: indexPath.section, forRow: rowIndexForRow(indexPath.row), forSubRow: subrowIndexForRow(indexPath.row))
    }
    
    fileprivate func indexPathForExpandableIndexPath(_ expandableIndexPath: ExpandableIndexPath) -> IndexPath{
        var index = 0
        var mainCellIndex = -1
        var subCellIndex = -1
        
        for cellType in cellsTypeArray{
            if cellType == .mainCell{
                mainCellIndex = mainCellIndex + 1
                subCellIndex = -1
            }
            else if cellType == .subCell{
                subCellIndex = subCellIndex + 1
            }
            
            if (mainCellIndex == expandableIndexPath.row) && (subCellIndex == expandableIndexPath.subRow){
                return IndexPath(row: index, section: 0)
            }
            
            index = index + 1
        }
        
        return IndexPath(row: -1, section: -1)
    }
    
    fileprivate func rowIndexForRow(_ row: Int) -> Int{
        var rowIndex : Int = row
        
        // Finds the mother row
        var found : Bool = false
        while !found{
            if cellsTypeArray.get(rowIndex) == .mainCell{
                found = true
            }
            else{
                rowIndex = rowIndex - 1
            }
        }
        
        // Creates a correct index for the user's datasource
        for index in stride(from: rowIndex, through: 0, by: -1) {
            // We substract 1 for each subcell
            if cellsTypeArray.get(index) == .subCell{
                rowIndex = rowIndex - 1
            }
        }
        
        return rowIndex
    }
    
    fileprivate func subrowIndexForRow(_ row: Int) -> Int{
        var rowIndex : Int = row
        
        var subrowIndex = -1
        while cellsTypeArray.get(rowIndex) == .subCell{
            subrowIndex = subrowIndex + 1
            rowIndex = rowIndex - 1
        }
        
        return subrowIndex
    }
    
    fileprivate func numberOfMainCells() -> Int{
        var numberOfMainCells = 0
        
        for cellType in cellsTypeArray{
            if cellType == .mainCell{
                numberOfMainCells = numberOfMainCells + 1
            }
        }
        
        return numberOfMainCells
    }
    
    fileprivate func expandCellAtIndexPath(_ indexPath: IndexPath, tableView:UITableView){
        var newIndexPath: IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        var tableViewContentOffset = self.tableView.contentOffset
        var indexesArray: [IndexPath] = []
        
        let numberOfSubCells = expandableTableView.expandableDelegate.expandableTableView(expandableTableView, numberOfSubRowsInRowAtExpandableIndexPath: expandableIndexPath)
        var heightForNewRows: CGFloat = 0.0

        if numberOfSubCells == 0 {
            return
        }

        for _ in 0...(numberOfSubCells - 1){
            indexesArray.append((newIndexPath as NSIndexPath).copy() as! IndexPath)
            self.cellsTypeArray.insert(.subCell, at: newIndexPath.row)
            newIndexPath = IndexPath(row: newIndexPath.row + 1, section: indexPath.section)
            
            heightForNewRows = heightForNewRows + self.tableView(tableView, heightForRowAt: newIndexPath)
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: indexesArray, with: UITableViewRowAnimation.middle)
        tableView.endUpdates()
        
        // Avoids an old-fashioned scrolling to the top when inserting cells and the table view is scrolled.
        if tableViewContentOffset.y > 0{
            tableViewContentOffset.y = tableViewContentOffset.y + heightForNewRows
            self.tableView.setContentOffset(tableViewContentOffset, animated: true)
        }
    }
    
    fileprivate func unexpandCellAtIndexPath(_ indexPath: IndexPath, tableView:UITableView){
        var newIndexPath: IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        var tableViewContentOffset = self.tableView.contentOffset
        var indexesArray: [IndexPath] = []
        
        let numberOfSubCells = expandableTableView.expandableDelegate.expandableTableView(expandableTableView, numberOfSubRowsInRowAtExpandableIndexPath: expandableIndexPath)
        var heightForNewRows: CGFloat = 0.0
        for _ in 0...(numberOfSubCells - 1){
            indexesArray.append((newIndexPath as NSIndexPath).copy() as! IndexPath)
            self.cellsTypeArray.remove(at: indexPath.row + 1)
            newIndexPath = IndexPath(row: newIndexPath.row + 1, section: indexPath.section)
            
            heightForNewRows = heightForNewRows + self.tableView(tableView, heightForRowAt: newIndexPath)
        }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: indexesArray, with: UITableViewRowAnimation.middle)
        tableView.endUpdates()
        
        // Avoids an old-fashioned scrolling to the top when deleting cells and the table view is scrolled.
        if tableViewContentOffset.y > 0{
            tableViewContentOffset.y = tableViewContentOffset.y - heightForNewRows
            self.tableView.setContentOffset(tableViewContentOffset, animated: true)
        }
    }

    // MARK: - Table view data source
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfRows = expandableTableView.expandableDelegate.expandableTableView(expandableTableView, numberOfRowsInSection: section)
        
        if numOfRows != numberOfMainCells(){
            cellsTypeArray = []
            self.initExpandableTableViewWithNumberOfRows(numOfRows)
        }
        
        return cellsTypeArray.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        
        if cellsTypeArray.get(indexPath.row) == .mainCell {
            cell = expandableTableView.expandableDelegate.expandableTableView(expandableTableView, cellForRowAtExpandableIndexPath: expandableIndexPath)
        }
        else if cellsTypeArray.get(indexPath.row) == .subCell {
            cell = expandableTableView.expandableDelegate.expandableTableView(expandableTableView, subCellForRowAtExpandableIndexPath: expandableIndexPath)
        }
        
        //print(indexPath)
        //print(cell)
        
        indexedCells[expandableIndexPath.string()] = cell
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        
        if cellsTypeArray.get(indexPath.row) == .mainCell {
            return expandableTableView.expandableDelegate.expandableTableView(expandableTableView, heightForRowAtExpandableIndexPath: expandableIndexPath)
        }
        else if cellsTypeArray.get(indexPath.row) == .subCell {
            return expandableTableView.expandableDelegate.expandableTableView(expandableTableView, heightForSubRowAtExpandableIndexPath: expandableIndexPath)
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        
        if cellsTypeArray.get(indexPath.row) == .mainCell {
            return expandableTableView.expandableDelegate.expandableTableView(expandableTableView, estimatedHeightForRowAtExpandableIndexPath: expandableIndexPath)
        }
        else if cellsTypeArray.get(indexPath.row) == .subCell {
            return expandableTableView.expandableDelegate.expandableTableView(expandableTableView, estimatedHeightForSubRowAtExpandableIndexPath: expandableIndexPath)
        }
        
        return super.tableView(tableView, estimatedHeightForRowAt: indexPath)
    }

    // MARK: - Table view delegate
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expandableIndexPath = expandableIndexPathForIndexPath(indexPath)
        
        if cellsTypeArray.get(indexPath.row) == .mainCell{
            let newIndexPath: IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            
            if cellsTypeArray.get(newIndexPath.row) != .subCell{
                expandCellAtIndexPath(indexPath, tableView: tableView)
            }
            else{
                unexpandCellAtIndexPath(indexPath, tableView: tableView)
            }
            
            expandableTableView.expandableDelegate.expandableTableView(expandableTableView, didSelectRowAtExpandableIndexPath: expandableIndexPath)
        }
        else if cellsTypeArray.get(indexPath.row) == .subCell {
            expandableTableView.expandableDelegate.expandableTableView(expandableTableView, didSelectSubRowAtExpandableIndexPath: expandableIndexPath)
        }
    }
}
