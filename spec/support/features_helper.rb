module FeatureHelpers
  def expect_selector_content selector, content
    expect(page).to have_selector selector
    within selector do
      expect(page).to have_content content
    end
  end
end
