require_relative "../locators/home.rb"

module Pages
    class Home < Locators::Home
  
      def initialize
        super()
      end
  
      def select_professionals_and_agencies_in_search_dropdown
        @search_dropdown.is_present_with_wait?
        @search_dropdown.click
        @professionals_and_agencies_option.is_present_with_wait?
        @professionals_and_agencies_option.click
      end

      def search_for_keyword(keyword)
        @find_professionals_and_agencies_text_box.clear_and_send_keys(keyword)
        @find_professionals_and_agencies_text_box.scroll_to_locator
        @find_professionals_and_agencies_text_box.mouse_over
        @search_button.mouse_over
        @search_button.click
      end

    end
  end
  