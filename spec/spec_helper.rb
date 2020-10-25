# This is to implement the rspec's test flow structure that is used to define the tests
# This is implemented using Nested Layouts concept
# This is responsible for the logging of description, test steps and the numbering are happening here
# Before all, before each, after all, after each steps are also declared here
# This file can be taken as a backbone for the tests that are going to be scripted in this framework
require_relative "../libraries/logger.rb"
require_relative "../libraries/driver.rb"
require_relative "../libraries/config.rb"
require_relative "../libraries/assert.rb"
include Libraries

$VERBOSE = nil
$file = 0
$test = 0
$step = 0

# Before all block which can be declared for each test file
def before_all(&block)
    yield if block_given?
end

# After all block which can be declared for each test file
def after_all(&block)
    $after_all = lambda { yield }
end

# This will be executed before each `it` described in the tests
def before_each_test(&block)
    $before_each_test = lambda { yield }
end

# This will be executed after each `it` described in the tests
def after_each_test(&block)
    $after_each_test = lambda { yield }
end

# This will be executed before each `step` described in the tests
def before_each_step(&block)
    $before_each_step = lambda { yield }
end

# This will be executed after each `step` described in the tests
def after_each_step(&block)
    $after_each_step = lambda { yield }
end

# This is to log the description and reset the counter for the tests and steps
def describe(description)
    $file = $file + 1
    $test = 0
    $step = 0
    Log.file($file.to_s + ". " + description)
    yield
    $after_all.call if $after_all
end

# This is to log the steps declared in the tests
def step(description)
    $step = $step + 1
    $before_each_step.call if $before_each_step
    Log.step($step.to_s + ". " + description)
    yield
    $after_each_step.call if $after_each_step
end

# This is to log the `it` declared in the tests
def it(description)
    $test = $test + 1
    $before_each_test.call if $before_each_test
    Log.test($test.to_s + ". " + description)
    yield
    $after_each_test.call if $after_each_test
end
