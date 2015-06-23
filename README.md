# Getting Started with TDD
================================

Check out the branch `em-solved` [https://github.com/elle/getting-started-with-tdd/tree/em-solved]
to see the finished solution used in this repo.

## Why?
================================

* Confidence in functionality
* Documentation
* Regression testing
* Leads to more manageable code
* Ability to refactor without fear
* Reduced requirement to test manually, which is slower, automated testing is faster
* Saves time in the long run
* Breaks down the problem
* Easier to cover edge cases


## Rspec or Minitest?
================================


## Rails confusion
================================

* Unit tests: do not involve database connection
* Integration tests: involve the database, thus all the AR models specs are actually integration tests
  - to try and make the test faster, we try to build objects,
    rather than creating and saving them to the db
* Feature tests: system wide under test,browser experience and user workflow, testing multiple models
  - creating objects and saving them to the database
  - slower tests


## What to test?
================================

* Public not private methods, basically the model public API, and which need to be supported. Private methods can change more. Public ones less
* Golden money path
* As a minimum, models and feature specs
* Although, lately I've been writing more types of specs:
 - controller specs: for example posting params that are impossible to do from the ui, invalid variables
 - view specs: for example checking that
 - presenters specs
 - request specs: for example to check redirects
 - helper specs
 - jobs specs
 - mailer specs
 - services specs

## Example Gemfile
================================
```
group :development, :test do
  gem "byebug" # "pry-byebug"
  gem "factory_girl_rails"
  gem "hirb"
  gem "pry-rails"
  gem "rspec-rails"
end

group :test do
  gem "capybara-webkit", ">= 1.2.0"
  gem "database_cleaner"
  gem "launchy"
  gem "shoulda-matchers", require: false
  gem "timecop"
  gem "webmock"
end
```

## Other gems
================================
" Access an IRB console on exception pages or by using `<%= console %>` in views

`gem "web-console", "~> 2.0"`

" https://github.com/thoughtbot/formulaic
```
fill_form(:user, { name: "John", email: "john@example.com", "Terms of Service" => true })
click_on submit(:user)
```


## RSpec 3.x
================================

RSpec 3.x introduces a new `rails_helper.rb` convention which contains all the
Rails-specific spec configuration and leaves `spec_helper.rb` minimal, with no Rails code.

`% rails generate rspec:install`

* .rspec
* spec/spec_helper.rb
* spec/rails_helper.rb

## Spec dir
================================

* spec/
* spec/support/
* spec/factories.rb
* spec/spec_helper.rb
* spec/rails_helper.rb

## spec/spec_helper.rb
================================

```
require "webmock/rspec"

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  config.order = :random
end

WebMock.disable_net_connect!(allow_localhost: true)
```

## spec/rails_helper.rb
================================

```
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

RSpec.configure do |config|
  config.include Features, type: :feature
  
  # it creates a subclass of `ApplicationController`
  config.infer_base_class_for_anonymous_controllers = false
  
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
  
  config.use_transactional_fixtures = false
end

ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :webkit
```

## Code
================================


```
# spec/models/user_spec.rb
require "rails_helper"

describe User do
  it { should have_many(:pets).dependent(:destroy) }
  it { should validate_presence_of(:first_name) }

  describe "#full_name" do
    it "returns title cased first and last names" do
      user = User.new(first_name: "homer", last_name: "simpson")

      expect(user.full_name).to eq "Homer Simpson"
    end

    it "returns only first_name if no last_name" do
      user = User.new(first_name: "homer")

      expect(user.full_name).to eq "Homer"
    end
  end
end
```

```
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :pets, dependent: :destroy

  validates :first_name, presence: true

  def full_name
    [first_name, last_name].compact.join(" ").titleize
  end
end
```

```
require_relative "../../app/models/a_nice_walk"

describe ANiceWalk do
  context "without a pet" do
    it "is impossible" do
      alice = double(pets: [])

      expect do
        ANiceWalk.for(alice)
      end.to raise_error CantWalkWithoutPets
    end
  end

  context "with a pet" do
    it "does not raise an error" do
      alice = double(pets: [double])
      allow(alice).to receive(:update)

      expect do
        ANiceWalk.for(alice)
      end.not_to raise_error
    end

    it "makes the walker happy" do
      alice = double(pets: [double])
      allow(alice).to receive(:update)

      ANiceWalk.for(alice)

      expect(alice).to have_received(:update).with(happiness: 20)
    end
  end
end
```

```
class ANiceWalk
  def self.for(person)
    raise CantWalkWithoutPets if person.pets.empty?
    person.update(happiness: 20)
  end
end

class CantWalkWithoutPets < StandardError; end
```

## Speed
================================

* Loading Rails and bundled gems vs just relative loading the only necessary files
* `binstubs`: https://github.com/sstephenson/rbenv/wiki/Understanding-binstubs
  or http://mislav.uniqpath.com/2013/01/understanding-binstubs/


## References
================================

* https://robots.thoughtbot.com/document-explicit-dependencies-through-tests
* http://www.justinweiss.com/blog/2014/06/02/how-to-learn-tdd-without-getting-overwhelmed/
* Shoulda Matchers: http://matchers.shoulda.io/
* Screencats: Destroy All Software: https://www.destroyallsoftware.com/screencasts
* Book: Rails 4 Test Prescriptions: https://pragprog.com/book/nrtest2/rails-4-test-prescriptions
* Book: Everyday Rails Testing with RSpec: https://leanpub.com/everydayrailsrspec
* Book: Testing Rails: https://gumroad.com/l/testing-rails

## Special code credit
================================

Some of the code used in this example repo was based on Destroy All Software's
screencast number 10: Fast tests with and without Rails:
https://www.destroyallsoftware.com/screencasts/catalog/fast-tests-with-and-without-rails
