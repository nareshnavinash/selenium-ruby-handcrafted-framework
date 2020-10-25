# This library file is to have the common assertion methods that are used across the tests
# The idea of this is inherited from rpsec-expectations,
# where we can call the assertions at anypoint in the tests without using any objects
require_relative 'logger.rb'
include Libraries

# This method gets two values as a mandatory input and logs appropriately in the stdout
# If two values are same, then the log will be printed as PASS else FAIL
# One can send the logger message as well if needed
# For example: 
#       1. expect_to_equal(1,1)
#           -> PASS           > 1 is equal to 1
#       1. expect_to_equal(1,2)
#           -> FAIL           > 1 is not equal to 2
#       1. expect_to_equal(1,1, "custom message")
#           -> PASS           > custom message
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
