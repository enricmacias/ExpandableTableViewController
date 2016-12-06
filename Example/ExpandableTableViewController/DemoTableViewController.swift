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
    case text = 0, datePicker, list
}

class DemoTableViewController: ExpandableTableViewController, ExpandableTableViewDelegate {
    
    // MARK: - Properties
    lazy var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
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
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)){
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onDatePickerValueChanged(_ sender: UIDatePicker){
        // Find this picker cell
        let position : CGPoint = sender.convert(sender.frame.origin, to: tableView)
        let pickerCellIndexPath : IndexPath = tableView.indexPathForRow(at: position)!
        
        // Creates the index path for the value text
        let valueCellIndexPath = IndexPath(row: pickerCellIndexPath.row - 1, section: pickerCellIndexPath.section)
        
        // Gets the cell we are looking for
        let birthdateCell : BirthdateTableViewCell = tableView.cellForRow(at: valueCellIndexPath) as! BirthdateTableViewCell
        
        birthdateCell.birthdateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - Expandable Table View Controller Delegate
    
    // MARK: - Rows
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch(expandableIndexPath.row){
        case TableViewRows.text.rawValue:
            let titleCell = expandableTableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: expandableIndexPath) as! TitleTableViewCell
            titleCell.dateLabel.text = dateFormatter.string(from: Date())
            titleCell.titleLabel.text = "Today News"
            cell = titleCell
        case TableViewRows.datePicker.rawValue:
            cell = expandableTableView.dequeueReusableCellWithIdentifier("BirthdateCell", forIndexPath: expandableIndexPath) as UITableViewCell
        case TableViewRows.list.rawValue:
            cell = expandableTableView.dequeueReusableCellWithIdentifier("ListTitleCell", forIndexPath: expandableIndexPath) as UITableViewCell
        default:
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        return 60.0
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, estimatedHeightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        return 60.0
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) {
        switch(expandableIndexPath.row){
        case TableViewRows.text.rawValue:
            if let cell = expandableTableView.cellForRowAtIndexPath(expandableIndexPath) as? CommonTableViewCell{
                if expandableTableView.isCellExpandedAtExpandableIndexPath(expandableIndexPath){
                    cell.showSeparator()
                }else{
                    cell.hideSeparator()
                }
            }
        case TableViewRows.datePicker.rawValue:
            break
        case TableViewRows.list.rawValue:
            break
        default:
            break
        }
        
        expandableTableView.deselectRowAtExpandableIndexPath(expandableIndexPath, animated: true)
    }
    
    // MARK: - SubRows
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfSubRowsInRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> Int {
        switch(expandableIndexPath.row){
        case TableViewRows.text.rawValue, TableViewRows.datePicker.rawValue:
            return 1
        case TableViewRows.list.rawValue:
            return 3
        default:
            return 0
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, subCellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch(expandableIndexPath.row){
        case TableViewRows.text.rawValue:
            let descriptionCell = expandableTableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: expandableIndexPath) as! DescriptionTableViewCell
            descriptionCell.descriptionLabel.text = "News is packaged information about current events happening somewhere else; or, alternatively, news is that which the news industry sells. News moves through many different media, based on word of mouth, printing, postal systems, broadcasting, and electronic communication. Common topics for news reports include war, politics, and business, as well as athletic contests, quirky or unusual events, and the doings of celebrities. Government proclamations, concerning royal ceremonies, laws, taxes, public health, and criminals, have been dubbed news since ancient times. Humans exhibit a nearly universal desire to learn and share news from elsewhere, which they satisfy by traveling and talking to each other. Technological and social developments, often driven by government communication and espionage networks, have increased the speed with which news can spread, as well as influenced its content. The genre of news as we know it today is closely associated with the newspaper, which originated in China as a court bulletin and spread, with paper and printing press, to Europe. The development of the electric telegraph in the mid-19th century revolutionized news by enabling nearly instantaneous transmissions, and by empowering a cartel of news agencies which consolidated the world news system. In the 20th century, the style of news and its impact on national populations expanded considerably with constant live broadcasting of radio and television, and finally, with the popularization of the internet."
            cell = descriptionCell
        case TableViewRows.datePicker.rawValue:
            cell = expandableTableView.dequeueReusableCellWithIdentifier("DatePickerCell", forIndexPath: expandableIndexPath) as UITableViewCell
        case TableViewRows.list.rawValue:
            let listTextCell = expandableTableView.dequeueReusableCellWithIdentifier("ListTextCell", forIndexPath: expandableIndexPath) as! ListTableViewCell
            listTextCell.listTextLabel.text = "Item"+String(expandableIndexPath.subRow)
            cell = listTextCell
        default:
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        switch(expandableIndexPath.row){
        case TableViewRows.text.rawValue:
            return UITableViewAutomaticDimension
        case TableViewRows.datePicker.rawValue:
            return 163.0
        case TableViewRows.list.rawValue:
            return 44.0
        default:
            return 0
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, estimatedHeightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        switch(expandableIndexPath.row){
        case TableViewRows.text.rawValue:
            return 100.0
        case TableViewRows.datePicker.rawValue:
            return 163.0
        case TableViewRows.list.rawValue:
            return 44.0
        default:
            return 0
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath){
        
    }

}

