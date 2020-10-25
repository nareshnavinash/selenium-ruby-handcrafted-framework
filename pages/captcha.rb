# Page class to hold the methods that are used on captcha page
require_relative "../locators/captcha.rb"
require_relative "../libraries/driver.rb"
require_relative "../libraries/logger.rb"
require_relative "../libraries/config.rb"
include Libraries

module Pages
    # Page class inherits the locator class
    class Captcha < Locators::Captcha
  
      def initialize
        super() # To make all the locators available within this class
      end
      
      # To reload the page once in two minutes for three times if captcha page is displayed
      def handle_captcha_page
        for i in 0..2
            if @captcha.is_present_with_wait?(10)
                Driver.get_current_driver.quit
                Log.warn("Relaunching the browser after 2 mins to mitigate the captcha issue")
                sleep(120)
                @@driver = Driver.new
                @@driver.clear_cookies
                @@driver.get(Config.url)
            end
        end
      end

    end
  end
  