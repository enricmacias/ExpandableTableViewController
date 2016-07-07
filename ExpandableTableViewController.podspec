Pod::Spec.new do |s|
  s.name             = 'ExpandableTableViewController'
  s.version          = '1.0'
  s.summary          = 'Swift library to easily show, hide and customize table view cells as an expandable list of items.'

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