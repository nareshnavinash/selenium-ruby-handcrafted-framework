require_relative 'logger.rb'
include Libraries

def expect_to_equal(value1, value2, message = nil)
    if value1 == value2
        Log.pass(message || value1.to_s + " is equal to " + value2.to_s)
    else
        Log.fail(message || value1.to_s + " is not equal to " + value2.to_s)
    end
end

def expect_not_to_equal(value1, value2, message = nil)
    if value1 != value2
        Log.pass(message || value1.to_s + " is not equal to " + value2.to_s)
    else
        Log.fail(message || value1.to_s + " is equal to " + value2.to_s)
    end
end
