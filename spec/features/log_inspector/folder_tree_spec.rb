require 'rails_helper'

feature 'Folder tree', js: true do
  scenario 'expandable folder tree' do
    visit log_inspector.root_path

    expect(page).to have_selector "ul.folder-list > li.folder[data-path='log'] > span.basename"
    within "ul.folder-list > li.folder[data-path='log'] > span.basename" do
      expect(page).to have_content 'log'
    end

    # binding.pry
  end
end
