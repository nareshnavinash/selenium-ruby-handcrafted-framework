require_relative "../libraries/locator.rb"
include Libraries

module Locators
    class ProfilePreview
  
        attr_reader :name
        attr_reader :title
        attr_reader :price
        attr_reader :success_rate
        attr_reader :country
        attr_reader :earned
        attr_reader :overview_expand_button
        attr_reader :overview
        attr_reader :upskill_tags
        attr_reader :associated_with
		
		
		def initialize

            @name = Locator.new(:css, "section.up-card-section h1[itemprop='name']")
            @title = Locator.new(:css, "section.up-card-section div.mb-30 h2[role*='presentation']")
            @price = Locator.new(:css, "section.up-card-section div.mb-30 h3[role*='presentation']")
            @success_rate = Locator.new(:css, "section.up-card-section div.identity-badges-container")
            @country = Locator.new(:css, "section.up-card-section span[itemprop='country-name']")
            @earned = Locator.new(:css, "//section[contains(@class,'up-card-section')]//div[contains(@class, 'col-compact')][1]")
            @overview_expand_button = Locator.new(:css, "div.up-line-clamp button[aria-expanded='false']")
            @overview = Locator.new(:css, "section.row div.up-line-clamp span.text-pre-line")
            @upskill_tags = Locator.new(:css, "section.row section.up-card-section div.skills span")
            @associated_with = Locator.new(:css, "section.row div.mt-30 div.d-flex")

		end
  
    end
end
  