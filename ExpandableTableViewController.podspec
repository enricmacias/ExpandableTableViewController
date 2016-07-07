Pod::Spec.new do |s|
  s.name             = 'ExpandableTableViewController'
  s.version          = '0.0.1'
  s.summary          = 'Swift library to easily show, hide and customize table view cells as an expandable list of items.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Swift library to easily show, hide and customize table view cells as an expandable list of items, long text or pickers.
                       DESC

  s.homepage         = 'https://github.com/enricmacias/ExpandableTableViewController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Enric Macias Lopez' => 'enric_maciaslopez@gmail.com' }
  s.source           = { :git => 'https://github.com/enricmacias/ExpandableTableViewController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ExpandableTableViewController/Classes/**/*'
end