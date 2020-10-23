require_relative "../libraries/locator.rb"
include Libraries

module Locators
    class FindProfessionals
  
		attr_reader :search_dropdown
		attr_reader :professionals_and_agencies_option
		attr_reader :find_professionals_and_agencies_text_box
		attr_reader :search_button
		
		def initialize

			@search_dropdown = Locator.new(:css, "button[data-cy*=search-switch-button]")
			@professionals_and_agencies_option = Locator.new(:xpath, '//a[contains(text(),"Professionals & Agencies")]')
			@find_professionals_and_agencies_text_box = Locator.new(:css, 'input[data-cy="search-input"]')
			@search_button = Locator.new(:css, "button[type='submit']")

		end
  
    end
end
  