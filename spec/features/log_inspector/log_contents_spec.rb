require 'rails_helper'

feature 'Log contents', js: true do
  scenario 'display logfile contents' do
    random_string = SecureRandom.hex(50) + "\n"
    File.open(Rails.root.join('log', 'testfile.log'), 'w') {|f| f.write(random_string)}

    visit log_inspector.root_path
    expect(page).to have_content 'testfile.log'
    page.execute_script "$(\"ul.folder-list > li.folder[data-path='log'] > ul > li.file[data-path='log/testfile.log'] > span.basename\").trigger('click');"

    expect_selector_content 'div.log-inspector > div.file-pane > div.file-details > p.basename', 'testfile.log'
    expect_selector_content 'div.log-inspector > div.file-pane pre', random_string
  end
end
