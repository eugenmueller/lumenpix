require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do

    it "should have the content 'Lumenpix'" do
      visit '/start_pages/home'
      page.should have_content('Lumenpix')  
    end
  end
end
