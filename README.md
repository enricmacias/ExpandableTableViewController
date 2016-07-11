# ExpandableTableViewController

[![Version](https://img.shields.io/cocoapods/v/ExpandableTableViewController.svg?style=flat)](http://cocoapods.org/pods/ExpandableTableViewController)
[![License](https://img.shields.io/cocoapods/l/ExpandableTableViewController.svg?style=flat)](http://cocoapods.org/pods/ExpandableTableViewController)
[![Platform](https://img.shields.io/cocoapods/p/ExpandableTableViewController.svg?style=flat)](http://cocoapods.org/pods/ExpandableTableViewController)

## Description

Swift library to easily show, hide and customize table view cells as an expandable list of items.

![alt tag](https://raw.github.com/enricmacias/ExpandableTableViewController/master/Preview/preview.gif)

## Requirements

- iOS 8.0
- UIKit

## In detail

An ExpandableTableView is a normal UITableView, but with subrows under its rows.
If a normal UITableView has sections and rows, an ExpandableTableView has sections, rows and subrows.

<img src="https://github.com/enricmacias/ExpandableTableViewController/blob/master/Preview/ExpandableTableView.png" width="300" />

## Usage

1.Implement your UITableViewController class with the ExpandableTableViewController class and ExpandableTableViewDelegate protocol.

```swift
class DemoTableViewController: ExpandableTableViewController, ExpandableTableViewDelegate {
	...
}
```

2.In your Storyboard, set the UITableView object with the ExpandableTableView class.

<img src="https://github.com/enricmacias/ExpandableTableViewController/blob/master/Preview/Image1.png" width="600" />

3.In your Storyboard, connect the IBOutlet expandableTableView with your current UITableView object.

<img src="https://github.com/enricmacias/ExpandableTableViewController/blob/master/Preview/Image2.png" width="600" />

4.Set the expandableDatasource and expandableDelegate properties to self in your viewDidLoad()

```swift
override func viewDidLoad() {
	super.viewDidLoad()

	self.expandableTableView.expandableDelegate = self
}
```

5.Add and implement the ExpandableTableViewDelegate required methods:

```swift
// Rows
func expandableTableView(expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int
func expandableTableView(expandableTableView: ExpandableTableView, cellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell
func expandableTableView(expandableTableView: ExpandableTableView, heightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
func expandableTableView(expandableTableView: ExpandableTableView, estimatedHeightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
func expandableTableView(expandableTableView: ExpandableTableView, didSelectRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath)

// Subrows
func expandableTableView(expandableTableView: ExpandableTableView, numberOfSubRowsInRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> Int
func expandableTableView(expandableTableView: ExpandableTableView, subCellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell
func expandableTableView(expandableTableView: ExpandableTableView, heightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
func expandableTableView(expandableTableView: ExpandableTableView, estimatedHeightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
func expandableTableView(expandableTableView: ExpandableTableView, didSelectSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath)
```

*Use the "dequeueReusableCellWithIdentifier(identifier:, expandableIndexPath:)" method from the expandableTableView property to deque cells with the given ExpandableIndexPath.
```swift
func expandableTableView(expandableTableView: ExpandableTableView, cellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell
{
    let cell = expandableTableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: expandableIndexPath)

    return cell
}
```

#### Useful methods
```swift
//////////// * ExpandableTableView Methods * ////////////
// Returns the cell at the ExpandableIndexPath given.
public func cellForRowAtIndexPath(expandableIndexPath: ExpandableIndexPath) -> UITableViewCell?

// Deques a cell a the ExpandableIndexPath given.
public func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell

// Shows if the ExpandableIndexPath provided is an expanded cell or not.
public func isCellExpandedAtExpandableIndexPath(expandableIndexPath:ExpandableIndexPath) -> Bool

// Deselects the cell at the ExpandableIndexPath given.
public func deselectRowAtExpandableIndexPath(expandableIndexPath: ExpandableIndexPath, animated: Bool)

//////////// * ExpandableTableViewController Methods * ////////////
// Unexpands all the expanded cells at once.
public func unexpandAllCells()
```

## Installation

#### Cocoapods

```ruby
pod "ExpandableTableViewController"
```

#### Manually

Import the following files into your project:

ExpandableTableViewController/ExpandableTableViewController/Classes folder:
```ruby
ExpandableTableViewController.swift
ExpandableTableViewDelegate.swift
ArrayExtension.swift
```

## Author

enric.macias.lopez, enric.macias.lopez@gmail.com

## License

ExpandableTableViewController is available under the MIT license. See the LICENSE file for more info.
