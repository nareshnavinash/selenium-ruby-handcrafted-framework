# Selenium Ruby Handcrafted Page Object Model Framework

## Implementations

* Core skeleton structure is built similar to rspec using Nested Layouts in ruby. Simple implementation is in `spec/spec_helper.rb`.
* Logger logic is added `libraries/logger.rb` idea is inherited from JavaScript test frameworks.
* Assertions are implemented using basic ruby `methods` to make it similar to rspec-expectations.
* Flexibility in terms of using the framework is implemented via `libraries/config.rb`. We can either set a configuration file or set environment variables to run the framework.
