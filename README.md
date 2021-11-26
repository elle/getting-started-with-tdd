# Getting Started with TDD

Check out the branch [`em-solved`](https://github.com/elle/getting-started-with-tdd/tree/em-solved)
to see the finished solution used in this repo.

## Why?

- Confidence in functionality
- Documentation
- Regression testing
- Leads to more manageable code
- Ability to refactor without fear
- Reduced requirement to test manually, which is slower, automated testing is faster
- Saves time in the long run
- Breaks down the problem
- Easier to cover edge cases

## Rspec or Minitest?

## Rails confusion

- Unit tests: do not involve database connection
- Integration tests: involve the database, thus all the AR models specs are actually integration tests
  - to try and make the test faster, we try to build objects,
    rather than creating and saving them to the db
- Feature tests: system wide under test,browser experience and user workflow,
  testing multiple models
  - creating objects and saving them to the database
  - slower tests

## What to test?

- Public not private methods, basically the model public API,
  and which need to be supported. Private methods can change more.
  Public ones less
- Golden money path
- As a minimum, models and feature specs
- Although, lately I've been writing more types of specs:
  - controller specs: for example posting `params` that are impossible to do
    from the UI, invalid variables
  - view specs: for example checking that
  - presenters specs
  - request specs: for example to check redirects
  - helper specs
  - jobs specs
  - mailer specs
  - services specs

## Example Gemfile

```ruby
group :development, :test do
  gem "factory_bot_rails"
  gem "hirb"
  gem "pry-byebug"
  gem "rspec-rails", "5.0.2"
end

group :test do
  gem "capybara"
  gem "cuprite"
  gem "database_cleaner"
  gem "launchy"
  gem "rails-controller-testing"
  gem "shoulda-matchers", "~> 4.0"
  gem "timecop"
  gem "webmock"
end
```

## Other gems

- [web-console](https://github.com/rails/web-console): access an IRB console on exception pages
  or by using `<% console %>` in views

- [Better Errors](https://github.com/charliesome/better_errors):
  better error page for Rack apps

- [Formulaic](https://github.com/thoughtbot/formulaic):

```ruby
fill_form(:user, { name: "John", email: "john@example.com", "Terms of Service" => true })
click_on submit(:user)
```


## RSpec 3.x +

RSpec 3.x introduces a new `rails_helper.rb` convention,
which contains all the Rails-specific spec configuration
and leaves `spec_helper.rb` minimal, with no Rails code.

`% rails generate rspec:install`

- .rspec
- spec/spec_helper.rb
- spec/rails_helper.rb

### Spec dir

- spec/
- spec/support/
- spec/factories.rb
- spec/spec_helper.rb
- spec/rails_helper.rb

### spec/spec_helper.rb

```ruby
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
```

### spec/rails_helper.rb

```ruby
ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
end
```

## Code

```ruby
# spec/models/user_spec.rb
require "rails_helper"

describe User do
  it { is_expected.to have_many(:pets).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:first_name) }

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

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :pets, dependent: :destroy

  validates :first_name, presence: true

  def full_name
    [first_name, last_name].compact.join(" ").titleize
  end
end
```

```ruby
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

```ruby
class ANiceWalk
  def self.for(person)
    raise CantWalkWithoutPets if person.pets.empty?
    person.update(happiness: 20)
  end
end

class CantWalkWithoutPets < StandardError; end
```

## Speed

- Loading Rails and bundled gems vs just relative loading the only necessary files
- `binstubs`: https://github.com/sstephenson/rbenv/wiki/Understanding-binstubs
  or http://mislav.uniqpath.com/2013/01/understanding-binstubs/

## References

- [Document explicit dependencies through tests](https://robots.thoughtbot.com/document-explicit-dependencies-through-tests)
- [How to learn TDD without getting overwhelmed](http://www.justinweiss.com/blog/2014/06/02/how-to-learn-tdd-without-getting-overwhelmed/)
- [Shoulda Matchers](http://matchers.shoulda.io/)
- [Destroy All Software](https://www.destroyallsoftware.com/screencasts)
- Book: [Rails 5 Test Prescriptions](https://pragprog.com/titles/nrtest3/rails-5-test-prescriptions/)
- Book: [Testing Rails](https://books.thoughtbot.com/assets/testing-rails.pdf)
- Book: [Everyday Rails Testing with RSpec](https://leanpub.com/everydayrailsrspec)

## Special code credit

Some of the code used in this example repo was based on
Destroy All Software's screencast number 10:
[Fast tests with and without Rails](https://www.destroyallsoftware.com/screencasts/catalog/fast-tests-with-and-without-rails)
