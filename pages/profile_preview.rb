require_relative "../locators/profile_preview.rb"

module Pages
    class ProfilePreview < Locators::ProfilePreview
  
      def initialize
        super()
      end

      def create_hash_for_client_details
        name = if @name.is_present? then @name.text else nil end
        title = if @title.is_present? then @title.text else nil end
        price = if @price.is_present? then @price.text else nil end
        success_rate = if @success_rate.is_present? then @success_rate.text else nil end
        earned = if @earned.is_present? then @earned.text else nil end
        @overview_expand_button.click if @overview_expand_button.is_present?
        overview = if @overview.is_present? then @overview.text else nil end
        upskill_tags = if @upskill_tags.is_present? then @upskill_tags.texts else nil end
        associated_with = if @associated_with.is_present? then @associated_with.text else nil end
        result_hash = {
            "name": name,
            "title": title,
            "price": price,
            "success_rate": success_rate,
            "country": country,
            "earned": earned,
            "overview": overview,
            "upskill_tags": upskill_tags,
            "associated_with": associated_with
        }
        return result_hash
      end

      def is_profile_preview_displayed?
        return @overview.is_present_with_wait?(20)
      end
  
      

    end
  end
  