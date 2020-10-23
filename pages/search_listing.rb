require_relative "../locators/search_listing.rb"

module Pages
    class SearchListing < Locators::SearchListing
  
      def initialize
        super()
      end
  
      def is_search_listing_displayed?
        return @search_listing_header.is_present_with_wait?(30)
      end

    end
  end
  