//
//  ViewController.swift
//  ExpandableTableViewController
//
//  Created by enric.macias.lopez on 08/21/2015.
//  Copyright (c) 2015 enric.macias.lopez. All rights reserved.
//

import UIKit
import ExpandableTableViewController

enum TableViewRows: Int {
    case Text = 0, DatePicker, List
}

class DemoTableViewController: ExpandableTableViewController, ExpandableTableViewDelegate {
    
    // MARK: - Properties
    lazy var dateFormatter: NSDateFormatter = {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.expandableTableView.expandableDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:"){
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.respondsToSelector("setLayoutMargins:"){
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onDatePickerValueChanged(sender: UIDatePicker){
        // Find this picker cell
        let position : CGPoint = sender.convertPoint(sender.frame.origin, toView: tableView)
        let pickerCellIndexPath : NSIndexPath = tableView.indexPathForRowAtPoint(position)!
        
        // Creates the index path for the value text
        let valueCellIndexPath = NSIndexPath(forRow: pickerCellIndexPath.row - 1, inSection: pickerCellIndexPath.section)
        
        // Gets the cell we are looking for
        let birthdateCell : BirthdateTableViewCell = tableView.cellForRowAtIndexPath(valueCellIndexPath) as! BirthdateTableViewCell
        
        birthdateCell.birthdateLabel.text = dateFormatter.stringFromDate(sender.date)
    }
    
    // MARK: - Expandable Table View Controller Delegate
    
    // MARK: - Rows
    func expandableTableView(expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func expandableTableView(expandableTableView: ExpandableTableView, cellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch(expandableIndexPath.row){
        case TableViewRows.Text.rawValue:
            let titleCell = expandableTableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: expandableIndexPath) as! TitleTableViewCell
            titleCell.dateLabel.text = dateFormatter.stringFromDate(NSDate())
            titleCell.titleLabel.text = "Today News"
            cell = titleCell
        case TableViewRows.DatePicker.rawValue:
            cell = expandableTableView.dequeueReusableCellWithIdentifier("BirthdateCell", forIndexPath: expandableIndexPath) as UITableViewCell
        case TableViewRows.List.rawValue:
            cell = expandableTableView.dequeueReusableCellWithIdentifier("ListTitleCell", forIndexPath: expandableIndexPath) as UITableViewCell
        default:
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    func expandableTableView(expandableTableView: ExpandableTableView, heightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        return 60.0
    }
    
    func expandableTableView(expandableTableView: ExpandableTableView, estimatedHeightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        return 60.0
    }
    
    func expandableTableView(expandableTableView: ExpandableTableView, didSelectRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) {
        switch(expandableIndexPath.row){
        case TableViewRows.Text.rawValue:
            if let cell = expandableTableView.cellForRowAtIndexPath(expandableIndexPath) as? CommonTableViewCell{
                if expandableTableView.isCellExpandedAtExpandableIndexPath(expandableIndexPath){
                    cell.showSeparator()
                }else{
                    cell.hideSeparator()
                }
            }
        case TableViewRows.DatePicker.rawValue:
            break
        case TableViewRows.List.rawValue:
            break
        default:
            break
        }
        
        expandableTableView.deselectRowAtExpandableIndexPath(expandableIndexPath, animated: true)
    }
    
    // MARK: - SubRows
    func expandableTableView(expandableTableView: ExpandableTableView, numberOfSubRowsInRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> Int {
        switch(expandableIndexPath.row){
        case TableViewRows.Text.rawValue, TableViewRows.DatePicker.rawValue:
            return 1
        case TableViewRows.List.rawValue:
            return 3
        default:
            return 0
        }
    }
    
    func expandableTableView(expandableTableView: ExpandableTableView, subCellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch(expandableIndexPath.row){
        case TableViewRows.Text.rawValue:
            let descriptionCell = expandableTableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: expandableIndexPath) as! DescriptionTableViewCell
            descriptionCell.descriptionLabel.text = "News is packaged information about current events happening somewhere else; or, alternatively, news is that which the news industry sells. News moves through many different media, based on word of mouth, printing, postal systems, broadcasting, and electronic communication. Common topics for news reports include war, politics, and business, as well as athletic contests, quirky or unusual events, and the doings of celebrities. Government proclamations, concerning royal ceremonies, laws, taxes, public health, and criminals, have been dubbed news since ancient times. Humans exhibit a nearly universal desire to learn and share news from elsewhere, which they satisfy by traveling and talking to each other. Technological and social developments, often driven by government communication and espionage networks, have increased the speed with which news can spread, as well as influenced its content. The genre of news as we know it today is closely associated with the newspaper, which originated in China as a court bulletin and spread, with paper and printing press, to Europe. The development of the electric telegraph in the mid-19th century revolutionized news by enabling nearly instantaneous transmissions, and by empowering a cartel of news agencies which consolidated the world news system. In the 20th century, the style of news and its impact on national populations expanded considerably with constant live broadcasting of radio and television, and finally, with the popularization of the internet."
            cell = descriptionCell
        case TableViewRows.DatePicker.rawValue:
            cell = expandableTableView.dequeueReusableCellWithIdentifier("DatePickerCell", forIndexPath: expandableIndexPath) as UITableViewCell
        case TableViewRows.List.rawValue:
            let listTextCell = expandableTableView.dequeueReusableCellWithIdentifier("ListTextCell", forIndexPath: expandableIndexPath) as! ListTableViewCell
            listTextCell.listTextLabel.text = "Item"+String(expandableIndexPath.subRow)
            cell = listTextCell
        default:
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    func expandableTableView(expandableTableView: ExpandableTableView, heightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        switch(expandableIndexPath.row){
        case TableViewRows.Text.rawValue:
            return UITableViewAutomaticDimension
        case TableViewRows.DatePicker.rawValue:
            return 163.0
        case TableViewRows.List.rawValue:
            return 44.0
        default:
            return 0
        }
    }
    
    func expandableTableView(expandableTableView: ExpandableTableView, estimatedHeightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        switch(expandableIndexPath.row){
        case TableViewRows.Text.rawValue:
            return 100.0
        case TableViewRows.DatePicker.rawValue:
            return 163.0
        case TableViewRows.List.rawValue:
            return 44.0
        default:
            return 0
        }
    }
    
    func expandableTableView(expandableTableView: ExpandableTableView, didSelectSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath){
        
    }

}

