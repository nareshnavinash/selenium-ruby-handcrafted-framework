require_relative "../libraries/logger.rb"
require_relative "../libraries/driver.rb"
require_relative "../libraries/config.rb"
require_relative "../libraries/assert.rb"
include Libraries

$VERBOSE = nil
$file = 0
$test = 0
$step = 0

def before_all(&block)
    yield if block_given?
end

def after_all(&block)
    $after_all = lambda { yield }
end

def before_each_test(&block)
    $before_each_test = lambda { yield }
end

def after_each_test(&block)
    $after_each_test = lambda { yield }
end

def before_each_step(&block)
    $before_each_step = lambda { yield }
end

def after_each_step(&block)
    $after_each_step = lambda { yield }
end

def describe(description)
    $file = $file + 1
    $test = 0
    $step = 0
    Log.file($file.to_s + ". " + description)
    yield
    $after_all.call if $after_all
end

def step(description)
    $step = $step + 1
    $before_each_step.call if $before_each_step
    Log.step($step.to_s + ". " + description)
    yield
    $after_each_step.call if $after_each_step
end

def it(description)
    $test = $test + 1
    $before_each_test.call if $before_each_test
    Log.test($test.to_s + ". " + description)
    yield
    $after_each_test.call if $after_each_test
end
