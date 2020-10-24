require_relative "config.rb"
require_relative "logger.rb"
require 'selenium-webdriver'

module Libraries

    class Driver
		attr_accessor :driver
		$focus_driver = nil
		@driver = nil
		@main_window = nil
		@click_exception_count = nil
		@@drivers = []
		@@drivers_with_names = {}

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
			@click_exception_count=0
			@@drivers.push(self)
			@@drivers_with_names[self] = "#{driver_name}"
			$focus_driver = self
			return self
		end

		def get_user_agent
			list_of_user_agents = ["Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246",
			"Mozilla/5.0 (X11; CrOS x86_64 8172.45.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.64 Safari/537.36",
			"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9",
			"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36",
			"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1"]
			return list_of_user_agents.sample
		end

		def get(url)
			$focus_driver = self
			@driver.get(url)
			Log.info("#{$focus_driver} browser is loaded with - #{url}")
		end

		def clear_cookies
			$focus_driver = self
			@driver.manage.delete_all_cookies
			Log.info("Cleared cookies from the " + Config.browser + " browser #{$focus_driver}")
		end

		def quit
			Log.info("Quiting the browser - #{$focus_driver}")
			@driver.quit
			@@drivers.delete(self)
		end

		def refresh
			$focus_driver = self
			navigate.refresh
			Log.info("#{$focus_driver} is refreshed")
		end

		def find_element(locator)
			$focus_driver = self
			Libraries::Wait.wait_for_element(locator)
			return @driver.find_element(locator.how,locator.what)
		end

		def save_screenshot(file_name = nil)
			$focus_driver = self
			file_name = "#{Pathname.pwd}/#{Config.screenshot_location}/#{Time.new.strftime("%Y-%m-%d-%H-%M-%S-%L-%N")}.png" if file_name.nil?
			Log.info("#{$focus_driver}'s Screenshot saved in this path => #{file_name}")
			@driver.save_screenshot(file_name)
		end

		def self.get_current_driver
			return $focus_driver
		end

		def find_elements(locator)
			$focus_driver = self
			return @driver.find_elements(locator.how,locator.what)
		end

		def action
			$focus_driver = self
			return @driver.action
		end

		def scroll_to_locator(locator)
			$focus_driver = self
			element = find_element(locator)
			@driver.execute_script("arguments[0].scrollIntoView({behavior: 'smooth', block: 'center', inline: 'nearest'});",element)
			Log.info("Scroll to this locator - #{locator.how} => #{locator.what} on #{$focus_driver}")
			sleep 1
		end

    end
  end
  