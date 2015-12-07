require 'spec_helper'

describe 'home page' do
  it 'welcomes guest user', :js => true do
    visit '/'
    page.should have_content('Log In')
  end
end
