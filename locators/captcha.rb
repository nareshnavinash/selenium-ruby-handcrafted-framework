require_relative "../libraries/locator.rb"
include Libraries

module Locators
    class Captcha
  
		attr_reader :captcha
		
		def initialize

			@captcha = Locator.new(:css, "div#px-captcha")

		end
  
    end
end
  