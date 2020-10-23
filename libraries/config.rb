require 'yaml'

module Libraries
    class Config

        def self.read_config_file
            $config ||= YAML.load_file(File.dirname(__FILE__).split("/libraries")[0] + '/config/global.yml')
            run_config_file = ENV["run_config"] || "production.yml"
            $run_config ||= YAML.load_file(File.dirname(__FILE__).split("/libraries")[0] + '/config/' + run_config_file)
        end

        def self.logger_level
            Config.read_config_file
            return ENV["logger_level"] || $config["logger_level"] || "info"
        end

        def self.browser
            Config.read_config_file
            return ENV["browser"] || $config["browser"] || "chrome"
        end

        def self.headless
            Config.read_config_file
            linux_check = true if Gem::Platform.local.os.include? "linux"
            return linux_check || ENV["headless"] || $config["headless"] || false
        end

        def self.implicit_wait
            Config.read_config_file
            return ENV["implicit_wait"] || $config["implicit_wait"] || 10
        end

        def self.screenshot_location
            Config.read_config_file
            return ENV["screenshot_location"] || $config["screenshot_location"] || "reports/screenshots"
        end

        def self.screen_horizontal
            Config.read_config_file
            return $config["screen_horizontal"] || 1200
        end

        def self.screen_vertical
            Config.read_config_file
            return $config["screen_vertical"] || 700
        end

        def self.url
            Config.read_config_file
            return ENV["url"] || $run_config["url"]
        end

    end
end