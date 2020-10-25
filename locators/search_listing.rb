# Locator class to declare the locators in the Upwork Search listing page
require_relative "../libraries/locator.rb"
include Libraries

module Locators
    class SearchListing
  
        attr_reader :search_listing_header
        attr_reader :search_list_cards
        attr_reader :search_list_profile_stats
        attr_reader :back_to_freelancers_list_button

		def initialize

            @search_listing_header = Locator.new(:css, "h1.top-freelancers")
            @search_list_cards = Locator.new(:css, "div.up-card-section")
            @search_list_profile_stats = Locator.new(:css, "div.up-card-section div.profile-stats")
            @back_to_freelancers_list_button = Locator.new(:css, "div.profile-slider-header button.up-btn-link")

        end

        def search_list_name(itr)
            @search_list_name = Locator.new(:xpath, "//div[contains(@class,'up-card-section')][#{itr}]//div[contains(@class,'identity-name')]")
        end

        def search_list_title(itr)
            @search_list_title = Locator.new(:xpath, "//div[contains(@class,'up-card-section')][#{itr}]//p[contains(@class,'freelancer-title')]")
        end
        
        def search_list_cost(itr)
            @search_list_cost = Locator.new(:xpath, "//div[contains(@class,'up-card-section')][#{itr}]//div[contains(@class,'profile-stats')]//p[@class='mb-5']")
        end
        
        def search_list_success_rate(itr)
            @search_list_success_rate = Locator.new(:xpath, "//div[contains(@class,'up-card-section')][#{itr}]//div[contains(@class,'profile-stats')]//div[@class='d-flex']")
        end
        
        def search_list_country(itr)
            @search_list_country = Locator.new(:xpath, "//div[contains(@class,'up-card-section')][#{itr}]//div[contains(@class,'profile-stats')]//span[@itemprop='country-name']")
        end

        def search_list_earned(itr)
            @search_list_earned = Locator.new(:xpath, "//div[contains(@class,'up-card-section')][#{itr}]//div[contains(@class,'profile-stats')]//div[@class='mb-5']")
        end

        def search_list_overview(itr)
            @search_list_overview = Locator.new(:xpath, "//div[contains(@class,'up-card-section')][#{itr}]//p[contains(@class,'overview')]")
        end

        def search_list_upskill_badge(itr)
            @search_list_upskill_badge = Locator.new(:xpath, "//div[contains(@class,'up-card-section')][#{itr}]//div[contains(@class,'skills')]//div[@class='up-skill-badge']")
        end

        def search_list_asssociated_with(itr)
            @search_list_asssociated_with = Locator.new(:xpath, "//div[contains(@class,'up-card-section')][#{itr}]//div[contains(@class,'freelancer-tile-agency-box-legacy')]//div[contains(@class,'agency-box-logo-name')]")
        end

        def search_list_asssociated_with_stats(itr)
            @search_list_asssociated_with_stats = Locator.new(:xpath, "//div[contains(@class,'up-card-section')][#{itr}]//div[contains(@class,'freelancer-tile-agency-box-legacy')]//div[contains(@class,'agency-box-stats')]")
        end
  
    end
end
  