require_relative "../locators/search_listing.rb"

module Pages
    # Page class inherits the locator class
    class SearchListing < Locators::SearchListing
  
      def initialize
        super() # To make all the locators available within this class
      end
      
      # To return whether the search listing page is displayed
      def is_search_listing_displayed?
        return @search_listing_header.is_present_with_wait?(30)
      end

      # To return the parced details from the search listing page
      def parse_results_page_and_store_values
        final_hash = {}
        for i in 1..10
            name = if search_list_name(i).is_present? then search_list_name(i).text else nil end
            title = if search_list_title(i).is_present? then search_list_title(i).text else nil end
            price = if search_list_cost(i).is_present? then search_list_cost(i).text else nil end
            success_rate = if search_list_success_rate(i).is_present? then search_list_success_rate(i).text else nil end
            country = if search_list_country(i).is_present? then search_list_country(i).text else nil end
            earned = if search_list_earned(i).is_present? then search_list_earned(i).text else nil end
            overview = if search_list_overview(i).is_present? then search_list_overview(i).text else nil end
            upskill_tags = if search_list_upskill_badge(i).is_present? then search_list_upskill_badge(i).texts else nil end
            associated_with = if search_list_asssociated_with(i).is_present? then search_list_asssociated_with(i).text else nil end
            associated_with_stats = if search_list_asssociated_with_stats(i).is_present? then search_list_asssociated_with_stats(i).text else nil end
            result_hash = {
                "name": name,
                "title": title,
                "price": price,
                "success_rate": success_rate,
                "country": country,
                "earned": earned,
                "overview": overview,
                "upskill_tags": upskill_tags,
                "associated_with": associated_with,
                "associated_with_stats": associated_with_stats
            }
            final_hash[i] = result_hash
        end
        return final_hash
      end

      # To click on the freelancer profile given the profile count in the list
      def click_on_freelancer_profile(listed_count)
        search_list_overview(listed_count).click
      end

    end
  end
  