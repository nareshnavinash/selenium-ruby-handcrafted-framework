require "date"
require_relative "config.rb"

$logger_text_array = []

module Libraries
    class Log
        
        def self.current_time
            return "[" + Time.now.localtime.to_s + "] "
        end

        def self.green_string(message)
            return "\e[32m#{message}\e[0m"
        end

        def self.red_string(message)
            return "\e[31m#{message}\e[0m"
        end

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

        def self.info(message)
            if Log.logger_level <= 0
                message = Log.current_time + "INFO           " + message
                $logger_text_array.append(message)
                puts(message)
            end
        end

        def self.file(message)
            if Log.logger_level <= 1
                message = Log.current_time + "FILE    " + message
                $logger_text_array.append(message)
                puts(message)
            end
        end

        def self.step(message)
            if Log.logger_level <= 1
                message = Log.current_time + "STEP        " + message
                $logger_text_array.append(message)
                puts(message)
            end
        end

        def self.test(message)
            if Log.logger_level <= 1
                message = Log.current_time + "TEST      " + message
                $logger_text_array.append(message)
                puts(message)
            end
        end

        def self.warn(message)
            if Log.logger_level <= 2
                message = Log.current_time + "WARN           > " + message
                $logger_text_array.append(message)
                puts(message)
            end
        end
        
        def self.pass(message)
            time = Log.current_time + "PASS           > "
            print_message = time + Log.green_string(message)
            logger_file_message = time + message
            $logger_text_array.append(logger_file_message)
            puts(print_message)
        end

        def self.fail(message)
            time = Log.current_time + "FAIL           > "
            print_message =  time + Log.red_string(message)
            logger_file_message = time + message
            $logger_text_array.append(logger_file_message)
            puts(print_message)
        end

    end
end

at_exit {
    File.open("reports/logs/[" + Time.now.localtime.to_s + "].log", "w+") do |f|
        f.puts($logger_text_array)
    end
}