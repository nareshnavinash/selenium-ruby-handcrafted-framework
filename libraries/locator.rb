require_relative 'wait.rb'
require_relative 'config.rb'
require_relative 'logger.rb'
include Libraries

module Libraries
    class Locator
        attr_accessor :how
        attr_accessor :what
        attr_accessor :options

        def initialize(how, what)
            @how = how
            @what = what
        end

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

        def self.mouse_over(element, driver = $focus_driver)
            driver.action.move_to(element).perform
        end

        def click(driver = $focus_driver)
            begin
                driver.find_element(self).click
                Log.info("Clicked - #{self.how} => #{self.what}")
            rescue Exception => e
                Log.info("Not clicked at - #{self.how} => #{self.what}")
                Log.info(e.message)
            end
        end

        def text(driver = $focus_driver)
            return driver.find_element(self).text
        end
        
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

        def is_not_present?(driver = $focus_driver)
            return !is_present?(driver)
        end

        def is_present_with_wait?(timeout = Config.implicit_wait, driver = $focus_driver)
            Wait.wait_for_element(self, timeout, driver)
            is_present?(driver)
        end

        def is_not_present_with_wait?(timeout = Config.implicit_wait, driver = $focus_driver)
            Wait.wait_for_element_hide(self, timeout, driver)
            return !is_present?(driver)
        end

        def click_if_present(driver = $focus_driver)
            click(driver) if is_present?(driver)
        end

        def texts(driver = $focus_driver)
            elements_text = []
            driver.find_elements(self).each do |element|
                elements_text.push(element.text)
            end
            return elements_text
        end

        def attribute(name, driver = $focus_driver)
            driver.find_element(self).attribute(name)
        end

        def css_value(prop, driver = $focus_driver)
            driver.find_element(self).css_value(prop)
        end

        def displayed?(driver = $focus_driver)
            driver.find_element(self).displayed?
        end

        def submit(driver = $focus_driver)
            driver.find_element(self).submit
        end

        def count(driver = $focus_driver)
            element_list = driver.find_elements(self)
            return element_list.count
        end

        def scroll_to_locator(driver = $focus_driver)
            $focus_driver.scroll_to_locator(self)
        end

        def click_if_present_with_wait(timeout = Config.implicit_wait, driver = $focus_driver)
            click(driver) if is_present_with_wait?(timeout, driver)
        end

        def to_s
            return "How ===> #{@how}\nWhat ===> #{@what}"
        end

        def mouse_over(index = 1, driver = $focus_driver)
            element = driver.find_elements(self)[index - 1]
            driver.action.move_to(element).perform
        end

        def move_and_click(driver = $focus_driver)
            element = driver.find_element(self)
            driver.action.move_to(element).click.perform
        end

        def get_element(driver = $focus_driver)
            driver.find_element(self)
        end

        ################################
        # Check box methods
        ################################

        def is_checked?(driver = $focus_driver)
            self.attribute("checked") == "true"
        end

        def check(driver = $focus_driver)
            self.click unless self.is_checked?
        end

        def uncheck(driver = $focus_driver)
            self.click if self.is_checked?
        end

        ##############################
        # Text box methods
        ##############################

        def clear(driver = $focus_driver)
            driver.find_element(self).clear
        end

        def send_keys(*args)
            $focus_driver.find_element(self).send_keys(*args)
        end

        def clear_and_send_keys(*args)
            clear($focus_driver)
            send_keys(*args)
        end

        def get_value(driver = $focus_driver)
            driver.find_element(self).attribute("value")
        end
    end
end
