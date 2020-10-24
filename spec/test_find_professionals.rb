require_relative 'spec_helper.rb'
require_relative '../pages/find_professionals.rb'
require_relative '../pages/search_listing.rb'
require_relative '../pages/profile_preview.rb'
require_relative '../pages/captcha.rb'
require 'yaml'
require 'pry'
include Pages

describe("Find Professionals in Upwork") do

    before_all do
        @@find_prof_page = FindProfessionals.new
        @@search_listing = SearchListing.new
        @@profile_preview = ProfilePreview.new
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
                # sleep(60)
                @@find_prof_page.search_for_keyword(search_key)
                if !@@search_listing.is_search_listing_displayed?
                    @@driver.quit
                    @@driver = Driver.new
                    @@driver.clear_cookies
                    @@driver.get(@@test_data["url_with_search_key"] + search_key)
                end
                expect_to_equal(@@search_listing.is_search_listing_displayed?, true, "Search listing page is displayed")
            end
            step("Parsing the first page with search results and storing the results in hash of hash format") do
                @@result_hash = @@search_listing.parse_results_page_and_store_values
            end
            step("Validate the results hash along with the search key that is used to get the results") do
                @@result_hash.each do |key, value|
                    pass_result = {}
                    fail_result = {}
                    value.each do |k, v|
                        if v == nil
                            fail_result[k] = v
                        elsif v.class.to_s == "Array"
                            val = v*","
                            if val.downcase.include? search_key.downcase
                                pass_result[k] = val
                            else
                                fail_result[k] = val
                            end
                        else
                            if v.downcase.include? search_key.downcase
                                pass_result[k] = v
                            else
                                fail_result[k] = v
                            end
                        end
                    end
                    if pass_result == {}
                        Log.fail("!!! Search keyword is not matched with any attributes for the freelancer - #{value["name"]}")
                    else
                        Log.pass("Key which contains the search text are #{key}. #{pass_result}")
                    end
                    Log.fail("Key which doesn't contain the search text are #{key}. #{fail_result}")
                end
            end
            step("Click on the random profile from the search result and fetch the freelancer details from the freelancers preview page") do
                @@profile_count = rand(1..10)
                @@search_listing.click_on_freelancer_profile(@@profile_count)
                expect_to_equal(@@profile_preview.is_profile_preview_displayed?, true, "Profile preview is displayed on clicking the freelancers profile")
            end
            step("Fetch details from the freelancers profile preview and compare it with the details dispalyed in search results page") do
                preview_hash = @@profile_preview.create_hash_for_client_details
                preview_hash.each do |key, value|
                    expect_to_equal(@@result_hash[@@profile_count][key], value, "Profile preview and search listing details match for #{key} with values #{@@result_hash[@@profile_count][key]} == #{value}")
                end
            end

        end
    end
end
