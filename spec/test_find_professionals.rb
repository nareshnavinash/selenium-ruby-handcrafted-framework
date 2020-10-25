require_relative 'spec_helper.rb'
require_relative '../pages/home.rb'
require_relative '../pages/search_listing.rb'
require_relative '../pages/profile_preview.rb'
require_relative '../pages/captcha.rb'
require 'yaml'
include Pages

describe("Find Professionals in Upwork") do

    before_all do
        @@find_prof_page = Home.new
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
                if @@captcha.captcha.is_present_with_wait?(10)
                    sleep(60)
                    @@captcha.handle_captcha_page
                end
                expect_to_equal(@@find_prof_page.find_professionals_and_agencies_text_box.is_present_with_wait?(30), true, "Home page is displayed")
            end 
            step("Select Professionals and Agencies in the search dropdown and search for the keyword - " + search_key) do
                @@find_prof_page.select_professionals_and_agencies_in_search_dropdown
                @@find_prof_page.find_professionals_and_agencies_text_box.flash
                @@find_prof_page.find_professionals_and_agencies_text_box.mouse_over
                @@find_prof_page.find_professionals_and_agencies_text_box.click
                @@find_prof_page.search_for_keyword(search_key)
                if !@@search_listing.is_search_listing_displayed?
                    @@driver.quit
                    @@driver = Driver.new
                    @@driver.clear_cookies
                    @@driver.get(@@test_data["url_with_search_key"] + search_key)
                end
                sleep(60) if @@captcha.captcha.is_present_with_wait?(10)
                expect_to_equal(@@search_listing.is_search_listing_displayed?, true, "Search listing page is displayed")
            end
            step("Parsing the first page with search results and storing the results in hash of hash format") do
                @@result_hash = @@search_listing.parse_results_page_and_store_values
                Log.info("Search results parsed data -> #{@@result_hash}")
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
                        Log.fail("Search keyword is not matched with any attributes for the freelancer - #{key}. #{value[:name]}")
                        Log.info("Attributes that doesn't have keyword are #{fail_result}")
                    else
                        Log.pass("Search keyword is matched with few attributes for the freelancer - #{key}. #{value[:name]}")
                        Log.info("Matched attributes with the keyword are #{pass_result}")
                        Log.info("Attributes that doesn't have keyword are #{fail_result}")
                    end
                end
            end
            step("Click on the random profile from the search result and fetch the freelancer details from the freelancers preview page") do
                @@profile_count = rand(1..10)
                @@search_listing.click_on_freelancer_profile(@@profile_count)
                if !@@profile_preview.is_profile_preview_displayed?
                    @@driver.quit
                    @@driver = Driver.new
                    @@driver.clear_cookies
                    @@driver.get(@@test_data["url_with_profile_preview"])
                    @@profile_count = 1
                end
                expect_to_equal(@@profile_preview.is_profile_preview_displayed?, true, "Profile preview is displayed on clicking the freelancers profile")
            end
            step("Fetch details from the freelancers profile preview and compare it with the details dispalyed in search results page") do
                preview_hash = @@profile_preview.create_hash_for_client_details
                Log.info("Freelancer profile fetched details -> #{preview_hash}")
                expect_to_equal(@@result_hash[@@profile_count][:name], preview_hash[:name], "Profile preview and search listing details match for name with values #{@@result_hash[@@profile_count][:name]} == #{preview_hash[:name]}")
                expect_to_equal(@@result_hash[@@profile_count][:title], preview_hash[:title], "Profile preview and search listing details match for title with values #{@@result_hash[@@profile_count][:title]} == #{preview_hash[:title]}")
                expect_to_equal(@@result_hash[@@profile_count][:country], preview_hash[:country], "Profile preview and search listing details match for country with values #{@@result_hash[@@profile_count][:country]} == #{preview_hash[:country]}")
                expect_to_equal(preview_hash[:earned]&.split(" ")[0], @@result_hash[@@profile_count][:earned]&.split("\n")[0], "Profile preview and search listing details match for earned with values #{@@result_hash[@@profile_count][:earned]} == #{preview_hash[:earned]&.delete("\n")}") if @@result_hash[@@profile_count][:earned]
                expect_to_equal(@@result_hash[@@profile_count][:overview]&.delete("\n")&.delete(' '), preview_hash[:overview]&.delete("\n")&.delete(' '), "Profile preview and search listing details match for overview with values #{@@result_hash[@@profile_count][:overview]&.delete("\n")} == #{preview_hash[:overview]&.delete("\n")}")
                expect_to_equal(@@result_hash[@@profile_count][:upskill_tags], preview_hash[:upskill_tags], "Profile preview and search listing details match for upskill_tags with values #{@@result_hash[@@profile_count][:upskill_tags]} == #{preview_hash[:upskill_tags]}")
                expect_to_equal(@@result_hash[@@profile_count][:price]&.delete(' '), preview_hash[:price]&.delete(' '), "Profile preview and search listing details match for price with values #{@@result_hash[@@profile_count][:price]&.delete(' ')} == #{preview_hash[:price]&.delete(' ')}")
                expect_to_equal((preview_hash[:success_rate]&.delete("\n")&.delete(' ')&.include? @@result_hash[@@profile_count][:success_rate]&.delete(' ')), true, "Profile preview and search listing details match for success_rate with values #{preview_hash[:success_rate]&.delete("\n")} == #{@@result_hash[@@profile_count][:success_rate]&.delete(' ')}")
                expect_to_equal(@@result_hash[@@profile_count][:associated_with]&.split("\n")[1], preview_hash[:associated_with]&.split("\n")[0], "Profile preview and search listing details match for associated_with with values #{@@result_hash[@@profile_count][:associated_with]&.split("\n")[1]} == #{preview_hash[:associated_with]&.split("\n")[0]}") if @@result_hash[@@profile_count][:associated_with]
            end
        end
    end

end
