# Logger method to log the message in the console
# Idea is inspired from Javascript test frameworks like webdriverio
# Logger level can be set from environment variable or via global.yml file
require "date"
require_relative "config.rb"
require_relative "driver.rb"

$logger_text_array = []

module Libraries
    class Log
        
        # To return the current time
        def self.current_time
            return "[" + Time.now.localtime.to_s + "] "
        end

        # To return the string in green colour
        def self.green_string(message)
            return "\e[32m#{message}\e[0m"
        end

        # To return the string in red colour
        def self.red_string(message)
            return "\e[31m#{message}\e[0m"
        end

        # To set the logger level
        def self.logger_level
            logger_level ||= Config.logger_level
            case logger_level
            when "info"
                result = 0
            when "test", "file", "step"
                result = 1
            when "warn"
                result = 2
            else
                result = 3
            end
            return result
        end

        # To print the info logs
        def self.info(message)
            if Log.logger_level <= 0
                message = Log.current_time + "INFO           " + message
                $logger_text_array.append(message)
                puts(message)
            end
        end

        # To print the file logs
        def self.file(message)
            if Log.logger_level <= 1
                message = Log.current_time + "FILE    " + message
                $logger_text_array.append(message)
                puts(message)
            end
        end

        # To print the step logs
        def self.step(message)
            if Log.logger_level <= 1
                message = Log.current_time + "STEP        " + message
                $logger_text_array.append(message)
                puts(message)
            end
        end

        # To print the test logs
        def self.test(message)
            if Log.logger_level <= 1
                message = Log.current_time + "TEST      " + message
                $logger_text_array.append(message)
                puts(message)
            end
        end

        # To print the warning messages
        def self.warn(message)
            if Log.logger_level <= 2
                message = Log.current_time + "WARN           > " + message
                $logger_text_array.append(message)
                puts(message)
            end
        end
        
        # To print the pass message
        def self.pass(message)
            time = Log.current_time + "PASS           > "
            print_message = time + Log.green_string(message)
            logger_file_message = time + message
            $logger_text_array.append(logger_file_message)
            puts(print_message)
        end

        # To print the fail message
        def self.fail(message)
            time = Log.current_time + "FAIL           > "
            print_message =  time + Log.red_string(message)
            logger_file_message = time + message
            $logger_text_array.append(logger_file_message)
            puts(print_message)
            Libraries::Driver.get_current_driver.save_screenshot
        end

    end
end

# At the end of all the test run, the console logs will be written to a new log file under reports/logs which can be used for future reference
at_exit {
    File.open("reports/logs/[" + Time.now.localtime.to_s + "].log", "w+") do |f|
        f.puts($logger_text_array)
    end
}