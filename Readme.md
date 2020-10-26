# Selenium Ruby Handcrafted Page Object Model Framework

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Made with Ruby](https://img.shields.io/badge/Made%20with-Ruby-red.svg)](https://www.ruby-lang.org/en/)
[![StackOverflow](http://img.shields.io/badge/Stack%20Overflow-Ask-blue.svg)]( https://stackoverflow.com/users/10505289/naresh-sekar )
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen.svg)](CONTRIBUTING.md)
[![email me](https://img.shields.io/badge/Contact-Email-green.svg)](mailto:nareshnavinash@gmail.com)

![alt text](libraries/selenium_handcrafted_framework.png)

## Prerequsite
* Install RVM in the machine
* Clone the project to a directory.
* Do `gem install bundler` in the folder path "../selenium-ruby-basic" in commandline
* Give `bundle install`
* Required package will be installed from Gemfile.
* Install chromedriver `brew cask install chromedriver` (for mac machines).
* Install firefox driver `brew install geckodriver` (for mac machines).
* Ideally the browser drivers should be under /usr/local/bin/ in mac or /usr/bin/ in linux where the drivers are accessible across the instance

## Implementations

* Core skeleton structure is built similar to rspec using Nested Layouts in ruby. Simple implementation is in `spec/spec_helper.rb`.
* Logger logic is added `libraries/logger.rb` idea is inherited from JavaScript test frameworks.
* Assertions are implemented using basic ruby `methods` to make it similar to rspec-expectations.
* Flexibility in terms of using the framework is implemented via `libraries/config.rb`. We can either set a configuration file or set environment variables to run the framework.
* Page object model is chosen to reduce maintanance effort and implemented the same with Ruby's Object Oriented Programming concept

## Page Object Model

* Page object model is supported by using two classes Pages and Locators under `pages/` and `locators/` folder. These page classes are then imported in the tests.

### Adding Locators to the project

1. Add Locators to the that are going to be used inside the project inside the `Locators` module
```
module Locators
	# Add a class for each page and add the locators
end
```
2. For each page add a new class inside the `Locators` module.

```
module Locators
  class TestPage

    # All the Locators in the initialize block need to be declared here for read write permission.
    attr_accessor :TEST_LOCATOR

    def initialize
      # Locators can be declared here by mentioning {how?(xpath,css,id) and what?(identifier)}
      @TEST_LOCATOR = Locator.new(:id, "")
    end

    # Dynamic locators can be declared here as a seperate method (This method doesnot need to be declared with attr_accessor)
    def TEST_DYNAMIC_LOCATOR(variable)
      @TEST_DYNAMIC_LOCATOR = Locator.new(:xpath,"//*[text()=#{variable}]")
    end

  end
end
```

3. Ideally each web page should have a new file inside locators folder (with the same name as the web page) and all the locators inside a web page has to be declared inside a page class(Class name also should be same as the web page name).
* If the web page name is `home page` then the locator file name should be `home_page.rb` inside `locators` folder and the class name should be `HomePage` inside `Locators` module.

### Adding page methods to the project

1. Add page specific methods inside the `Pages` module.

```
module Pages
  # add the page class here
end
```

2. For each page add a new class inside `Pages` module and each page class should inherit the locators class of the same page

```
module Pages
  class TestPage < Locators::TestPage

    def initialize()
      super()
    end

    def test_method(attribute_text)
    	puts "#{attribute_text}"
    end

  end
end
```

3. Ideally each web page should have a new page file inside `pages` folder with the class name same as the web page name.
* If the web page name is `home page` then the pages file name should be `home_page.rb` inside `pages` folder and the class name should be `HomePage` inside `Pages` module.

### Adding new tests in this project

1. Add a file under `spec` folder. and then follow the following basic skeleton to describe the tests

```
describe("Find Professionals in Upwork") do

    before_all do
        # Before all block if needed
    end

    after_all do
        # After all block if needed
    end

    it("Find professionals using search option in Upwork") do
        # One it corresponds to a single test. Each describe can have multiple tests
        step("Clear cookies from the browser") do
            # Each test can have multiple steps
        end
    end
end
```

2. This above skeleton is built to look similar to rspec using nested layouts concept in ruby. All these are implemented under `spec/spec_helper.rb` file.

3. In this tests, one has to import the page class and then invoke the browser actions across the browser.

## Layout responsibilities

Since we are using multiple folder structures to run the tests, there is a high possibility that we might get lost with the purpose of each entity. Following are the core actions that has to be done in each folder.

* `config/` - To have all the run configurations. Can be modified in `libraries/config.rb`
* `libraries/` - To have all the support methods that are used across all the tests like driver actions, locator actions, logger etc., Ideally we should convert this to a new ruby gem so that even cross functional team can use the same and avoid inventing the wheel again.
* `locators/` - Where all the locators are declared under `Locators` class. Here only declaring the locators are allowed
* `pages/` - Where all the browser actions are declared under `Pages` class. Here all the actions that is performed in the browser should be added.
* `spec/` - Where the actual test declaration is added. Here all the assertions should be added by using the Pages class
* `reports/` - Where the run logs and failed screenshots are added.
* `test-data/` - Where the test specific test data are added.

## Flexibility

The browser used for the test, the headless mode for the browser and other configurations are fetched from environment variables first and then have given a fall back fetch from the global.yml file. This gives us flexibility to run the tests in multiple options without even changing the code.

For ex: If we need to run the same tests in dockerized container, we can actually initialize the docker with predefined environment variable like browser as 'firefox' and logger level as 'info' and the initialize the tests directly without change in the code. Ideally we should build this as run time configurations instead of environment variables, but environment variables have an higher edge when we go with CI CD pipelines built with docker or kubernetes.

In the example provided in the `spec/test_find_professionals.rb` file, we can actually set the search keyword from the command line by sending,

```
search_keyword=rails ruby spec/test_find_professionals.rb
search_keyword=rails,python ruby spec/test_find_professionals.rb    # For multiple runs with different keywords
ruby spec/test_find_professionals.rb    # This will take the search key from the testdata file
```
Browsers can be set by,
```
browser=firefox ruby spec/test_find_professionals.rb    # For firefox
ruby spec/test_find_professionals.rb    # For chrome, since chrome is set as default
```
for headless mode,
```
browser=firefox headless=true ruby spec/test_find_professionals.rb  # Firefox headless
headless=true ruby spec/test_find_professionals.rb      # Chrome headless
```
If we run the tests in linux environment, no matter what the variable is set in commandline or in the config files, the tests will run only in headless mode.

## Scallability

This framework structure can be scalled to support mulitple tests in a same application by reducing the maintance effort with the use of page object model. 

For ex: 
* If an element in the home page is changed, we don't want to change in the entire test suite, rather we can change only in the locators file
* If an actions in a page is changed, we don't want to change in the entire tests, rather we can directly change only in the pages file which be reflected across all the tests

This framework also supports multiple tests within a same file, along with iteration for each tests.

For ex:
* If a functionality has 10 tests, we can have a single test file with single describe with the funtionality name and have 10 `it` blocks within the describe block. And if each tests have n number of iterations with the test data, that can also be supported by using a proper loop around the `it` block

Apart from this this also supports the before all, before each test, before each step, after all, after each test, after each step block within each `describe` block, which is mandatory to have if we are going with extensive tests.

Assertions are built and logged automatically with the usage of assert.rb file in libraries. This takes of the burden in validating each test with different combinations.

A wrapper around the driver and locator ensures that we can have n number browsers initiated for a single test and to have multi-browser support.

Basic logger is getting saved under results/logs folder which can be leveraged to build sophesticated html test reports.

## Contributing

1. Clone the repo!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a pull request.

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on code of conduct, and the process for submitting pull requests.

## Authors

* **[Naresh Sekar](https://github.com/nareshnavinash)**

## License

This project is licensed under the GNU GPL-3.0 License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* To all the open source contributors whose code has been referred in this project.