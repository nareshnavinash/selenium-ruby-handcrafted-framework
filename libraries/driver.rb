# This file holds the driver methods that are going to be used across this framework
# This is to create a wrapper around the selenium-webdriver in order to combine and use to our convinience
# This wrapper class helps us to use the browser of our choice and could use with high flexibility
require_relative "config.rb"
require_relative "logger.rb"
require 'selenium-webdriver'

module Libraries

    class Driver
		attr_accessor :driver
		$focus_driver = nil
		@driver = nil
		@@drivers = []
		@@drivers_with_names = {}

		# While initilizing the driver class a browser driver is initialized of our choice and assigned to the class object
		# Ex: chrome_driver = Driver.new
		# Ex: firefox_driver = Driver.new(browser="firefox") # or set the firefox variable as environment variable or in the global.yml file
		def initialize(driver_name = "Driver", browser = Config.browser)
			begin
				start(driver_name,browser)
				Log.info("Driver initialized is - #{driver_name} - #{self}")
			rescue Exception => e
				Log.info("#{driver_name} is failed to initialize \n\n #{e.backtrace}\n\nRetrying to initialize #{driver_name}")
				start(driver_name,browser)
				Log.info("#{driver_name} is initialized after an exception")
			end
		end

		##############################
		# Custom methods of driver #
		##############################
		
		# This is the main method to initialize the browser of our choice along with the specified options
		# Specify the browser name and the current driver name to get the browser initiated
		# List of browsers supported as of now chrome & firefox
		# If you need to initialize the browser in headless mode set the headless true either in global.yml or in the environment variable
		# Browser dimentions are also set from the global.yml file. If the tests are supposed to run in different dimentions change the settings promptly
		def start(driver_name, browser)

			case browser
			when 'chrome'
				options = Selenium::WebDriver::Chrome::Options.new
				user_agent = "user-agent=#{get_user_agent}"
				if Config.headless
					switches = ["disable-infobars", "disable-gpu", "disable-dev-shm-usage", "no-sandbox", "headless", "--enable-javascript", user_agent]
				else
					switches = ["disable-infobars", "disable-gpu", "disable-dev-shm-usage", "no-sandbox", "--enable-javascript", user_agent]
				end
				switches.map { |k| options.add_argument(k) }
				@driver = Selenium::WebDriver.for(:chrome, options: options)
				@driver.manage.timeouts.implicit_wait = Config.implicit_wait

			when 'firefox', 'ff'
				options = Selenium::WebDriver::Firefox::Options.new
				if Config.headless
					switches = ["disable-infobars", "--enable-javascript", "-headless"]
				else
					switches = ["disable-infobars", "--enable-javascript"]
				end
				switches.map { |k| options.add_argument(k) }
				@driver = Selenium::WebDriver.for(:firefox, options: options)
				@driver.manage.timeouts.implicit_wait = Config.implicit_wait

			when 'ie', 'internet_explorer'
				# to be added

			when 'edge'
				# to be added 

			when 'safari'
				# to be added

			else
				raise ArgumentError, "Specify a proper browser while initiating a driver \n \n#{browser.inspect}"
			end

			target_size = Selenium::WebDriver::Dimension.new(Config.screen_horizontal, Config.screen_vertical)
			@driver.manage.window.size = target_size
			@@drivers.push(self)
			@@drivers_with_names[self] = "#{driver_name}"
			$focus_driver = self
			return self
		end

		# This is to generate different user agent for each run
		# This avoids captcha verification to some extent
		def get_user_agent
			list_of_user_agents = ["Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246",
			"Mozilla/5.0 (X11; CrOS x86_64 8172.45.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.64 Safari/537.36",
			"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9",
			"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36",
			"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1"]
			return list_of_user_agents.sample
		end

		# TO load the browser with specific URL.
		def get(url)
			$focus_driver = self
			@driver.get(url)
			Log.info("#{$focus_driver} browser is loaded with - #{url}")
		end

		# To Clear cookies from the current browser driver
		def clear_cookies
			$focus_driver = self
			@driver.manage.delete_all_cookies
			Log.info("Cleared cookies from the " + Config.browser + " browser #{$focus_driver}")
		end

		# To quit the current browser driver
		def quit
			Log.info("Quiting the browser - #{$focus_driver}")
			@driver.quit
			@@drivers.delete(self)
		end

		# To refresh the current browser driver
		def refresh
			$focus_driver = self
			navigate.refresh
			Log.info("#{$focus_driver} is refreshed")
		end

		# To find element in the current browser driver
		def find_element(locator)
			$focus_driver = self
			Libraries::Wait.wait_for_element(locator)
			return @driver.find_element(locator.how,locator.what)
		end

		# To save screenshot of the current browser driver
		def save_screenshot(file = nil)
			$focus_driver = self
			if file.nil?
				file_name = "#{Pathname.pwd}/#{Config.screenshot_location}/#{Time.new.strftime("%Y-%m-%d-%H-%M-%S-%L-%N")}.png"
			else
				file_name = "#{Pathname.pwd}/#{Config.screenshot_location}/#{file}.png"
			end
			Log.info("#{$focus_driver}'s Screenshot saved in this path => #{file_name}")
			@driver.save_screenshot(file_name)
		end

		# To return the current browser driver element. This can be used to perform direct selenium actions over the browser driver
		def self.get_current_driver
			return $focus_driver
		end

		# To find multiple elements in the current browser. This returns a list of elements found for a specific locator
		def find_elements(locator)
			$focus_driver = self
			return @driver.find_elements(locator.how,locator.what)
		end

		# This is to perform action in the browser driver
		def action
			$focus_driver = self
			return @driver.action
		end

		# This is to scroll the browser window to a specific element
		def scroll_to_locator(locator)
			$focus_driver = self
			element = find_element(locator)
			@driver.execute_script("arguments[0].scrollIntoView({behavior: 'smooth', block: 'center', inline: 'nearest'});",element)
			Log.info("Scroll to this locator - #{locator.how} => #{locator.what} on #{$focus_driver}")
			sleep 1
		end

    end
  end
  