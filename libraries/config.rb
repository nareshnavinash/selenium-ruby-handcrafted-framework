# This file is where the global configs and run configs are parsed 
# Here we are giving preference in the following order
# Environment variable > Vaiable declared in the global.yml file > default value
require 'yaml'

# All the methods under this config class are class methods
# This gives us flexibility in fethching the values directly across the framework
module Libraries
    class Config

        # To parse and read the global config and run config files
        # Files will be parsed only once irrespective of any number of method calls
        # One can direcly use the global vaiables $config or $run_config directly within the tests 
        # Or use the custom methods for specific entities to have default fallback.
        def self.read_config_file
            $config ||= YAML.load_file(File.dirname(__FILE__).split("/libraries")[0] + '/config/global.yml')
            run_config_file = ENV["run_config"] || "production.yml"
            $run_config ||= YAML.load_file(File.dirname(__FILE__).split("/libraries")[0] + '/config/' + run_config_file)
        end

        # To set the logger level that is needed for a run, one can change by running,
        #`logger_level=test ruby spec/test_find_professionals.rb`
        def self.logger_level
            Config.read_config_file
            return ENV["logger_level"] || $config["logger_level"] || "info"
        end

        # To specify which browser to be used for running the tests, change durning run time by,
        # `browser=firefox ruby spec/test_find_professionals.rb`
        def self.browser
            Config.read_config_file
            return ENV["browser"] || $config["browser"] || "chrome"
        end

        # To specify weather to run the tess in headless mode, If we are running the tests in linux, headless mode is forced
        def self.headless
            Config.read_config_file
            linux_check = true if Gem::Platform.local.os.include? "linux"
            return linux_check || ENV["headless"] || $config["headless"] || false
        end

        # To mention the implicit wait that is used by selenium during a page load
        def self.implicit_wait
            Config.read_config_file
            return ENV["implicit_wait"] || $config["implicit_wait"] || 10
        end

        # To specify the screenshots that is taken during test run path.
        def self.screenshot_location
            Config.read_config_file
            return ENV["screenshot_location"] || $config["screenshot_location"] || "reports/screenshots"
        end

        # To specify the browser screen horizontal size
        def self.screen_horizontal
            Config.read_config_file
            return $config["screen_horizontal"] || 1200
        end

        # To specify the browser screen vertical size
        def self.screen_vertical
            Config.read_config_file
            return $config["screen_vertical"] || 700
        end

        # To return the url used for the tests
        def self.url
            Config.read_config_file
            return ENV["url"] || $run_config["url"]
        end

    end
end