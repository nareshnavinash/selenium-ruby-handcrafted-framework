# This is the wrapper class against the locator actions that is to be performed in the browser
# This class helps us to declare the locator elements seperately and then call when needed
# This also helps us to combine mutiple actions to a single one, so that we can conviniently use across the project
require_relative 'wait.rb'
require_relative 'config.rb'
require_relative 'logger.rb'
include Libraries

module Libraries
    class Locator
        attr_accessor :how
        attr_accessor :what
        attr_accessor :options

        # On initializing we need to give the locator finder key as well as the locator path
        # Ex: Locator.new(:css, "div.header")
        def initialize(how, what)
            @how = how
            @what = what
        end

        # This is to flash the locator with red so that we can identify in the browser view
        def flash(driver = $focus_driver)
            element = driver.find_element(self)
            attr = element.attribute("backgroundColor")
            driver.driver.execute_script "arguments[0].style.backgroundColor = 'red';", element
            sleep 0.1
            driver.driver.execute_script "arguments[0].style.backgroundColor = arguments[1];", element, attr
            sleep 0.1
            driver.driver.execute_script "arguments[0].style.backgroundColor = 'red';", element
            sleep 0.1
            driver.driver.execute_script "arguments[0].style.backgroundColor = arguments[1];", element, attr
        end

        ##################################################
        # Methods inherited and overriden from Selenium  #
        ##################################################

        # This is a class method to mouse hover an element
        def self.mouse_over(element, driver = $focus_driver)
            driver.action.move_to(element).perform
        end

        # To click an element
        def click(driver = $focus_driver)
            begin
                driver.find_element(self).click
                Log.info("Clicked - #{self.how} => #{self.what}")
            rescue Exception => e
                Log.info("Not clicked at - #{self.how} => #{self.what}")
                Log.info(e.message)
            end
        end

        # To get the text and return from the element
        def text(driver = $focus_driver)
            return driver.find_element(self).text
        end
        
        # To validate whether the element is present at that moment. Here implicit wait is made to zero.
        def is_present?(driver = $focus_driver)
            driver.driver.manage.timeouts.implicit_wait = 0
            begin
                return driver.driver.find_element(self.how, self.what).displayed?
            rescue Exception => e
                driver.driver.manage.timeouts.implicit_wait = Config.implicit_wait
                return false
            ensure
                driver.driver.manage.timeouts.implicit_wait = Config.implicit_wait
            end
        end

        # To validate whether the element is not present at that moment. Here implicit wait is made to zero.
        def is_not_present?(driver = $focus_driver)
            return !is_present?(driver)
        end

        # To validate whether the element is present with a wait which is mentioned as implicit wait. One can send a custom wait time while calling this method
        def is_present_with_wait?(timeout = Config.implicit_wait, driver = $focus_driver)
            Wait.wait_for_element(self, timeout, driver)
            is_present?(driver)
        end

        # To validate whether the element is not present with a wait which is mentioned as implicit wait. One can send a custom wait time while calling this method
        def is_not_present_with_wait?(timeout = Config.implicit_wait, driver = $focus_driver)
            Wait.wait_for_element_hide(self, timeout, driver)
            return !is_present?(driver)
        end

        # To click the element if present at that moment. Here implicit wait is made to zero.
        def click_if_present(driver = $focus_driver)
            click(driver) if is_present?(driver)
        end

        # To return the array of texts that is found when multiple elements are available for a specific locator
        def texts(driver = $focus_driver)
            elements_text = []
            driver.find_elements(self).each do |element|
                elements_text.push(element.text)
            end
            return elements_text
        end

        # To return the attribute value for an element
        def attribute(name, driver = $focus_driver)
            driver.find_element(self).attribute(name)
        end

        # To return the css_value for an element
        def css_value(prop, driver = $focus_driver)
            driver.find_element(self).css_value(prop)
        end

        # to validate whether the element is dispalyed in the browser
        def displayed?(driver = $focus_driver)
            driver.find_element(self).displayed?
        end

        # To submit the current web page
        def submit(driver = $focus_driver)
            driver.find_element(self).submit
        end

        # To get the number of elements matched for a specific locator
        def count(driver = $focus_driver)
            element_list = driver.find_elements(self)
            return element_list.count
        end

        # To scroll to the locator
        def scroll_to_locator(driver = $focus_driver)
            $focus_driver.scroll_to_locator(self)
        end

        # To click if the element is present with a wait time
        def click_if_present_with_wait(timeout = Config.implicit_wait, driver = $focus_driver)
            click(driver) if is_present_with_wait?(timeout, driver)
        end

        # To return the value that current locator holds
        def to_s
            return "How ===> #{@how}\nWhat ===> #{@what}"
        end

        # Instance method to mouse hover the current element
        def mouse_over(index = 1, driver = $focus_driver)
            element = driver.find_elements(self)[index - 1]
            driver.action.move_to(element).perform
        end

        # To move to the element and then perform the click action
        def move_and_click(driver = $focus_driver)
            element = driver.find_element(self)
            driver.action.move_to(element).click.perform
        end

        # To directly get the element where we can perform locator specific actions directly in the tests
        def get_element(driver = $focus_driver)
            driver.find_element(self)
        end

        ##############################
        # Text box methods
        ##############################

        # To clear the text area available in the UI
        def clear(driver = $focus_driver)
            driver.find_element(self).clear
        end

        # To set a text value in a text area
        def send_keys(*args)
            $focus_driver.find_element(self).send_keys(*args)
        end

        # To clear the text area and then set the value in the text area
        def clear_and_send_keys(*args)
            clear($focus_driver)
            send_keys(*args)
        end
    end
end
