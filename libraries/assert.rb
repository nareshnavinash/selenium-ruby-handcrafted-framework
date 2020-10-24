require_relative 'logger.rb'
include Libraries

def expect_to_equal(value1, value2, message = nil)
    case value1.class.to_s
    when "Array"
        flag = true
        value1.each do |each|
            if !value2.include? each
                flag = false
                break
            end
        end
        if flag
            Log.pass(message || "#{value1} is equal to #{value2}")
        else
            Log.fail(message || "#{value1} is not equal to #{value2}")
        end
    else
        if value1 == value2
            Log.pass(message || "#{value1} is equal to #{value2}")
        else
            Log.fail(message || "#{value1} is not equal to #{value2}")
        end
    end
end

def expect_not_to_equal(value1, value2, message = nil)
    if value1 != value2
        Log.pass(message || "#{value1} is not equal to #{value2}")
    else
        Log.fail(message || "#{value1} is equal to #{value2}")
    end
end
