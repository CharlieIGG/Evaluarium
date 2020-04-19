![alt text](../app/javascript/images/logo1.svg "Logo Title Text 1")

- [**Writing Specs**](#writing-specs)
  - [**Spec vs Test**](#spec-vs-test)
  - [**Types of Specs**](#types-of-specs)
  - [**How to write any Spec**](#how-to-write-any-spec)
  - [**Factories**](#factories)
    - [**Traits**](#traits)
  - [**Using Guard to accelerate the tesing process**](#using-guard-to-accelerate-the-tesing-process)
  - [**TestProf**](#testprof)
  - [**I hate specs / specs are too complicated / I'm not sure what I'm doing**](#i-hate-specs--specs-are-too-complicated--im-not-sure-what-im-doing)

# **Writing Specs**

All of our specs are based on [RSpec](https://rspec.info/), as well as [Capybara](https://teamcapybara.github.io/capybara/) and [Selenium WebDriver](https://www.selenium.dev/projects/) for Integration specs. [Our Philosophy is completely oriented towards a combination of BDD and DDD](https://medium.com/datadriveninvestor/the-value-at-the-intersection-of-tdd-ddd-and-bdd-da58ea1f3ac8).

## **Spec vs Test**

They're the same! but...

A spec is written in a way that also acts as documentation for the system specifications. The top lines of specs (i.e. whatever is written after the `describe`, `context` and `it` declarations) should be readable and understandable even for a person not acquainted with the programming language of the implementation. These outputs are also what would be echoed out into the STDOUT when processing the specs.

## **Types of Specs**

Although RSpec and Rails enable a very wide variety of Spec Types, the current approach of this project is the following:

- ALWAYS Write [**UNIT specs** for Models](https://relishapp.com/rspec/rspec-rails/docs/model-specs) and [Service-Objects](https://relishapp.com/rspec/rspec-core/v/3-4/docs/example-groups/basic-structure-describe-it)
- Write [**UNIT specs** for Controllers](https://relishapp.com/rspec/rspec-rails/docs/controller-specs) ONLY for API-exposed Controllers
- Write [**INTEGRATION specs** for every major feature](https://relishapp.com/rspec/rspec-rails/docs/system-specs/system-spec) of the Monolithic (MVC, Back-Office) aspect of the application.

## **How to write any Spec**

The anatomy of any spec is simple:

1. All spec files have to end with `_spec.rb` so that RSpec will know to pick them up.
2. In (pretty much) all spec files, we have to add the `require 'rails_helper'` at the top, so that all the tools we use for testing are made available.
3. All spec files are encased within a `describe` block statement (after requiring any files). The first parameter of the `describe` block can be a String, a Class or a Module. The 2nd (optional) parameter is an implicit ["metadata" hash](https://relishapp.com/rspec/rspec-core/docs/metadata/user-defined-metadata).
4. Every test (or group of chained tests) is stated as a spec, using the `it` block statement. Ideally one creates a new `it` statement for every single distinguishable behavior or rule of the tested system part, instead of having one single enormous `it` block with hundreds of assertions inside.
5. Closely related `it` statements can be wrapped inside a `context` clause, and `context`s can also be nested themselves. a `context` acts like a "sub-describ" statement.
6. One can assign variables "test-instance" variables at either the `describe` or `context` levels. Any variables declared at these levels will be shared among the different `it` blocks, but they will reset once they are accessed by the next `it` statement. To assign these top-level, resettable variables one uses the `let`  and `let!` statements.
7. The difference between `let` and `let!` is that the former will only really instantiate the variable once it is used inside the spec, while the latter will be instantiated immediately.

Here's how a spec would look like normally:
```ruby
require 'rails_helper'

describe "Understanding the documentation for 'Writing Specs'", type: :model, focus: true  do # note the "metadata"
  let!(:docs) { create(:documentation) }
  let!(:existing_reader) { create(:user, :reader, name: "The Reader") } # Evaluated instantly. This reader is not in the DB. Also note how we're calling `create` which is really `FactoryBot.create`... see the next section.
  let(:specs_make_sense) { existing_reader.understands_docs? } # Not evaluated until used

  before :each do
    existing_reader.read_docs! # DRY
  end

  context "without the example" do


    it 'Fails to understand' do
      expect(specs_make_sense).to eq(false)
    end

    it 'Sends a notification' do
      expect(Notification.count).to eq(1)
    end
  end

  context "with the example" do
    let!(:docs) { create(:documentation, :with_example) } # Note how we're using a "trait", and how `docs` is being overwritten in this context.

    it 'Fails to understand' do
      expect(specs_make_sense).to eq(true) # Note how this is the just-in-time evaluation of `existing_reader.understands_docs?`
    end

    it 'Does not send a notification' do
      expect(Notification.count).to eq(0) # Did we mention the Database resets automatically?
    end
  end
end
```

> 💡 Note how the database will clean-up automatically after each test.

For more details and extra stuff like `before` hooks, check out the [official RSpec docs](https://rspec.info/)

## **Factories**

We use FactoryBot (formerly known as _FactoryGirl_) to generate semi-realistic data for our testing purposes, without having to manually build up all the data, relationships, etc. for every test. FactoryBot allows you to instantiate complex data model instances, and even save them, using the `build(:<factory_name>)` and `create(:<factory_name>)` notations. You can even create collections of many instances in one operation, using `create_list(:<factory_name>, <number>)`, for instance:
```ruby
  create_list(:thing, 5) # will create 5 unique Things.
```

> ⚠️ Using Fixtures, Stubs, or even complete manual implementations to simulate data during testing is **strongly discouraged**. Please use Factories instead. One notable exception to this rule is [stubbing method calls](https://relishapp.com/rspec/rspec-mocks/v/2-4/docs/method-stubs) that depend on external APIs/Services.

### **Traits**

It is possible to declare Factory "traits", which are basically variants of an existing Factory. Consider the User factory:

```ruby
FactoryBot.define do
  factory :user do
    # ...

    trait :with_roles do
      transient do
        roles { [{ name: nil, resource: nil }] }
      end

      after :create do |user, eval|
        eval.roles.each do |role|
          user.add_role role[:name].to_sym, role[:resource]
        end
      end
    end
  end
end
```

Here, when the user is created using the :with_roles trait, it will look for any roles passed, and will add them after creation. Note that declarations inside traits will override any conflicting declarations with the root factory.

In order to call a trait you just need to pass it as an additional parameter before the implicit attribute hash: `create(:<factory_name>, :<trait_name>)`. In order to call the above factory trait you would do for instance:
```ruby
create(:user, :with_roles, roles: [{name: "admin", resouce: some_resource}, {name: "superadmin"}])
```

> 💡 By default FactoryBot will expect to map any attributes you pass to it after the Factory name to columns in the corresponding table in the Database. For instance if one would just call `create(:user, roles: [{name: "admin", resouce: some_resource}, {name: "superadmin"}])` without the `:with_roles` trait, you would get an ActiveRecord error telling you there is no `roles` column in the users table. The `transient` block declaration seen in the example above helps us circumvent this problem by telling FactoryBot that these named attributes should NOT get mapped to the model/table, but are there to serve as operation variables. Whatever is added after the variable name between `{}` is taken as the default value for this variable for this trait.

> 💡 Note how instead of calling `FactoryBot.create(:factory)` we're omitting the Class name? This is because RSpec will `include` FactoryBot within any specs, so the `create`, `build`, etc. methods can be called directly with a functional notation from within any specs. (note that `require 'rails_helper'` needs to be at the top of each spec.)

For more examples and tricks for using FactoryBot, please refer to the **[FactoryBot cheatsheet](https://devhints.io/factory_bot)**.

## **Using Guard to accelerate the tesing process**

This application comes prepared with **[Guard](https://github.com/guard/guard#readme)**, which is particularly useful when doing TDD. Guard basically detects when changes were made to the codebase, checks if those changes demand certain (or all) specs be run (using the [Guardfile](../Guardfile)), and automatically runs specs.

If you keep iterating over the same files after failures were reported, it will just focus on the files with failures 👍, this until all specs pass, or previously-untouched files are touched, in which case it will add them to the group of focused files.

To run guard simply:

1. Run it in a `test` container instance either through the container's bash and then `guard -c`, or by `plis run test guard -c`.
2. Make changes! (it takes a handful of seconds to start watching files after the initial launch)

> 💡 The `-c` flag tells Guard to clean all the output between runs.

## **TestProf**

We use https://test-prof.evilmartians.io/#/ to profile tests, along with the `let_it_be` and `create_default` recipes there included to minimize the time spent in each test's setup and teardown.
These two recipes are very helpful to keep testing time in check, but they do come with a handful of caveats you need to be aware of, and which you can read [here](https://test-prof.evilmartians.io/#/let_it_be?id=caveats-amp-modifers).

## **I hate specs / specs are too complicated / I'm not sure what I'm doing**

If the above header expresses what's on your mind right now, do yourself a favor and watch ["How to Stop Hating Your Tests"](https://vimeo.com/145917204).