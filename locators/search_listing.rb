require_relative "../libraries/locator.rb"
include Libraries

module Locators
    class SearchListing
  
		attr_reader :search_listing_header
		
		def initialize

            @search_listing_header = Locator.new(:css, "h1.top-freelancers")
            @search_list_cards = Locator.new(:css, "div.up-card-section")
            @search_list_names = Locator.new(:css, "div.up-card-section div.identity-name")
            @search_list_title = Locator.new(:css, "div.up-card-section p.freelancer-title")
            @search_list_profile_stats = Locator.new(:css, "div.up-card-section div.profile-stats")


		end
  
    end
end
  