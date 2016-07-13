require 'rails_helper'

feature 'Folder tree', js: true do
  scenario 'expandable folder tree' do
    FileUtils.mkdir Rails.root.join('log', 'log_subfolder') unless File.directory?(Rails.root.join('log', 'log_subfolder'))
    FileUtils.touch Rails.root.join('log', 'log_subfolder', 'subfolder_file.log')
    visit log_inspector.root_path

    root_log = "ul.folder-list > li.folder[data-path='log']"
    subfolder_log = "#{root_log} > ul > li.folder[data-path='log/log_subfolder']"
    {
      "#{root_log} > span.basename" => 'log',
      "#{subfolder_log} > span.basename" => 'log_subfolder',
      "#{root_log} > ul > li.file[data-path='log/test.log'] > span.basename" => 'test.log'
    }.each do |selector, content|
      expect_selector_content selector, content
    end

    page.execute_script "$(\"#{subfolder_log} > span.basename\").trigger('click');"
    expect_selector_content "#{subfolder_log} > ul > li.file[data-path='log/log_subfolder/subfolder_file.log']", 'subfolder_file.log'
  end
end
