require_relative 'spec_helper.rb'
require_relative '../pages/find_professionals.rb'
require_relative '../pages/search_listing.rb'
require_relative '../pages/captcha.rb'
require 'yaml'
# require 'pry'
include Pages

describe("Find Professionals in Upwork") do

    before_all do
        @@find_prof_page = FindProfessionals.new
        @@search_listing = SearchListing.new
        @@captcha = Captcha.new
        @@test_data = YAML.load_file(Dir.pwd + '/test-data/find_professionals.yml')
    end

    after_all do
        @@driver.quit
    end

    @@test_data['search_keyword'].each do |search_key|
        it("Find professionals using search option in Upwork") do
            step("Run " + Config.browser + " brower with headless as " + Config.headless.to_s) do
                @@driver = Driver.new
            end
            step("Clear cookies from the browser") do
                @@driver.clear_cookies
            end
            step("Navigate to Upwork website - " + Config.url) do
                @@driver.get(Config.url)
                sleep(60) if @@captcha.captcha.is_present_with_wait?(10)
                @@captcha.handle_captcha_page if @@captcha.captcha.is_present_with_wait?(10)
                expect_to_equal(@@find_prof_page.find_professionals_and_agencies_text_box.is_present_with_wait?(30), true, "Home page is displayed")
            end 
            step("Select Professionals and Agencies in the search dropdown and search for the keyword - " + search_key) do
                @@find_prof_page.select_professionals_and_agencies_in_search_dropdown
                @@find_prof_page.find_professionals_and_agencies_text_box.flash
                @@find_prof_page.find_professionals_and_agencies_text_box.mouse_over
                @@find_prof_page.find_professionals_and_agencies_text_box.click
                sleep(30)
                @@find_prof_page.search_for_keyword(search_key)
                expect_to_equal(@@search_listing.is_search_listing_displayed?, true, "Search listing page is displayed")
            end
            
        end
    end
end
