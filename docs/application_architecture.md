![alt text](../app/javascript/images/logo1.svg "Logo Title Text 1")

# **Application Architecture**

- [**Application Architecture**](#application-architecture)
  - [**Major Facets**](#major-facets)
  - [**Responsibility-separation Patterns**](#responsibility-separation-patterns)
  - [**Application Layers**](#application-layers)
  - [**Migrations and DB Schema**](#migrations-and-db-schema)
    - [Noteworthy](#noteworthy)
  - [**Models**](#models)
  - [**ActiveStorage Attachments**](#activestorage-attachments)
  - [**Policies and Policy Scopes**](#policies-and-policy-scopes)
    - [**Policies**](#policies)
    - [**Scopes**](#scopes)
    - [**Convention**](#convention)
  - [**Roles and Authentication**](#roles-and-authentication)
    - [**Authentication**](#authentication)
    - [**Roles**](#roles)
  - [**Controllers**](#controllers)
  - [**Decorators**](#decorators)
  - [**Views**](#views)
  - [**Javascript**](#javascript)

## **Major Facets**

The application is divided into **two "Major Facets"**: a "monolithic" **back-office service**, which serves as the management system for our staff and our partners (in the near future?), and a "decoupled" back-end which stems from the former facet, and is expressed in it's majority as a [RESOURCEful API](https://medium.com/@trevorhreed/you-re-api-isn-t-restful-and-that-s-good-b2662079cf0e).

## **Responsibility-separation Patterns**

This application's back-office follows as [MVC Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller), while the API follows a "Resource-Controller" pattern in its majority.

## **Application Layers**

1. **Migrations and DB Schema**: Manage and map the Database
2. **Models**: Add higher-level rules and behaviors that correlate to the Database schema and enhance existing instances of every entry in every "modelled" table in the database.
3. **Resources**: Map and Serialize Models that shall be exposed via the API, as well as certain rules and behavior for said exposition.
4. **Policies and Policy Scopes**: determine the ability (or inability) to interact in different ways with specific Models/Resources, in a Identity- and Role-based way. Policy Scopes determine exactly what records can be accessed (if at all) by a given user, based on the user's identity and role(s).
5. **Controllers**: Recieve requests, delegate execution to the lower layers, respond something.
6. **Decorators**: Augment models with additional representational behavior, while helping us encapsulate and isolate representational behavior from inherent relational and functional behavior. **Helps us keep our Views clean and simple**.
7. **Views**: Render the GUI, typically served by the controllers based on the controller action name.
8. **Javascript**: Augment the views with dynamic, client-side behavior and logic, from pre-compiled libraries, to our own React components, we drive all assets, in particular Javascript using Webpack.

## **Migrations and DB Schema**

The preferred way to modify the database is through [ActiveRecord Migrations](https://guides.rubyonrails.org/active_record_migrations.html), which help us keep the history of changes, which in turn are useful for things like rolling back changes between releases of code.

> ⚠️ You should under no circumstances make structural changes to the database, this will lead to serious problems down the road.

> 💡 One of the largest dev-ops and CI issues that frequently come up with databases are incompatibilities across local installations of the Database Server (PostgreSQL in this case). We are able to 100% forget about any of that thanks to the fact that we're using Docker.

For changes to the data database itself it is always recommended to still go through ActiveRecord (i.e. the Rails models), since they are there to validate data consistency, as well as run callbacks (and even automatically roll-back changes). As opposed to the above point regarding structural data, there are exceptions that could be considered valid while sill circumventing ActiveRecord.

The Schema represents the current shape of the database, and it is managed by the Migrations. NEVER change this file manually.

**[Here](./erd.pdf)'s** a glimpse of the current Entity Relationships.

### Noteworthy

Here are a list of things that may not be immediately apparent to you:

1. Certain tables (i.e. 'users', and 'customer_leads') manage their unique id using the `UUID` data type instead of `BIGINT`. This is to make them transferrable across systems, and to have less traceable user ids. This introduces a couple of caveats mentioned in the next points.
2. When creating a migration that involves references to tables that use `UUID`, one must manually change the migration file to make the types of both columns match. For instance

```ruby
  t.references :user, null: false, foreign_key: true # WRONG! Will cause an error upon running migrations.
  # SHOULD BE:
  t.references :user, null: false, foreign_key: true, type: :uuid
```

3. ActiveRecord uses `BIGINT` by default for all primary-id columns, and orders queries using the primary-id column to `ORDER BY ASC` by default. When `UUID`s are used, ActiveRecord will STILL try to sort using the ID column, but this leads to unpredictable sorts (it will sort the UUID as if it was a string, but UUIDs follow no sequence). For consistency's sake, in controllers and specs, it is highly recommended to specify an ordering, otherwise things like `@users.last` will NOT be deterministic.
4. If you're a developer not familiar with PostgreSQL, you might not know that you have advanced features for column types by default, such as `JSONB` and Arrays. These are extremely powerful features of PSQL. Use them, but use them wisely.
5. The fact that Ruby is dynamically typed gives a lot of flexibility, but can also lead to lots of small, yet accumulating issues in the code when dealing with database data. In particular beware of ["truthiness" and "falsiness" in Ruby](https://gist.github.com/jfarmer/2647362). You'll find that after a year a TON of your code will be repeated variations of conditional logic and nil checks. THIS IS A CODE SMELL. In order to prevent these types of problems from creeping in, please try to specify a `:default` value whenever possible in your migration files:

```ruby
  t.boolean "active", default: true, null: false
```

> 💡 The above snippet does not just prevent `nil` from getting passed down into the `active` column, but also makes sure that it will ALWAYS be either one of `true` or `false`, eliminating the chance of it being `NULL` in the database, and thus avoiding a bunch of code-smells down the road!

## **Models**

The models represent the way (almost) each and every table in the database should behave. They declare explicit relationships, and relationship rules, as well as data validation, and lifecycle callbacks. A model should only represent business rules inherent to any specific instance of the data it encapsulates (i.e. every row of the corresponding table), and how they relate to other models, for more (see here)[https://guides.rubyonrails.org/active_model_basics.html].

> ⚠️ Be careful to maintain the [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single-responsibility_principle) as much as possible when using models. Separate concerns, and DRY.

> ⚠️ Models should NOT know about representational logic (i.e. how to format their output), nor serialization or authorization logic. ALWAYS encapsulate representational logic in [Decorators](#decorators), serialization and authorization in [Resources](#resources) and [Policies](#policies-and-policy-scopes) respectively.

## **ActiveStorage Attachments**

Models can have attachments declared without having to create new migrations or database columns. We use [ActiveStorage](https://edgeguides.rubyonrails.org/active_storage_overview.html) to handle attaching documents to ActiveResource Model instances. You can create associated attachments to models like this:

```ruby
# thing.rb
has_one_attached :image
has_one_attached :icon
```

Which automatically allows us to do the following:

```ruby
@thing.image.attached? # checks if there is an existing attachment
@thing.image.attachment # gets the existing attachment
@thing.image.attach( # attach a file manually
  io: File.open('/path/to/file'),
  filename: 'file.pdf',
  content_type: 'application/pdf',
  identify: false
)
```

And also allows us to automatically pass files to attach using a file_field to get the path to the file:

```erb
<%= form.file_field :image %>
```

and in your controller:

```ruby
def create
  @thing = Thing.create(thing_params)
end

def thing_params
  params.require(:thing).permit(:image)
end
```

<!-- ## **Resources**

Resources define the public interface to your API. A resource defines which attributes are exposed, as well as relationships to other resources.

Resource definitions should by convention be placed in a directory under app named resources, app/resources. The file name should be the single underscored name of the model that backs the resource with \_resource.rb appended. For example, a Contact model’s resource should have a class named ContactResource defined in a file named contact_resource.rb.

👉 Note the use of the methods `creatable_fields` and `updatable_fields` in some of our resources, such as ThingSubscriptionResource, where any user can create a subscription, but we don't want subscription's relationships to be editable through the API once created.

In some cases we want to limit the relationships that are exposed by JSON:API. For instance, a Thing can have multiple ThingSubscriptions, and by default wit the JSON:API standard they would be exposed by a related URL, for instance: `"http://example.com/api/v1/things/1/relationships/thing_subscriptions"`, which is pretty useful for navigating relationships, BUT it could lead to a User finding out about other Users' ThingSubscriptions. In order to prevent this, we can manually override the scope of the relationship in the ThingResource, like this:

```ruby
# thing_resource.rb
has_many :thing_subscriptions, apply_join: lambda { |records, relationship, _resource_type, join_type, options|
  case join_type
  when :inner # this is boilerplate to allow different types of joins later on...
    records = records.joins(relationship.relation_name(options))
  when :left # this is boilerplate to allow different types of joins later on...
    records = records.joins_left(relationship.relation_name(options))
  end
  # Here we ensure that when calling things/1/relationships/thing_subscriptions, only subscriptions that are relevant to the current user will be exposed.
  records.where(thing_subscriptions: { user_id: options[:context][:user].id })
}
```

**[Learn More about Resources here](https://jsonapi-resources.com/v0.10/guide/resources.html)** -->

## **Policies and Policy Scopes**

In order to encapsulate responsibilities associated with resource authorization, we're using [Pundit](https://github.com/varvet/pundit):

> Pundit provides a set of helpers which guide you in leveraging regular Ruby classes and object oriented design patterns to build a simple, robust and scalable authorization system.

The whole authorization system consists on having one Policy per resource (i.e. per model), which in turn may contain a nested Scope class. The former is used to authorize specific actions for each resource, based on the resource instance, and the user's roles. The latter is used to filter ActiveRecord collections based on the user.

> 💡 This section talks a lot about roles. To understand more about how we handle roles check out the [Roles](#roles-and-authentication) section.

### **Policies**

Policies are simple classes that contain question-like methods for a specific resource, each of which return a `true` or `false` when invoked (typically called at the controller level):

```ruby
class ThingPolicy < ApplicationPolicy
  def update?
    user.has_role?("admin") || !record.published?
  end
end

class ThingsController < ApplicationController
  before_action :set_thing, only: %i[show edit update destroy]
  before_action :authorize_resource # We typically try to authorize as early as possible

  def update
    # ... update logic here
  end

  private

  def set_thing
    @thing = Thing.find(params[:id])
  end

  def authorize_resource
    resource = @thing || Thing # It is possible to authorize a specific class instance, or an entire Class... as long as YOUR logic inside the ThingPolicy#<method>? can handle both.
    authorize resource # would return `true` if the @thing is not published, or if the person trying to update the @thing is an admin.
  end
end
```

Note how we're just using the `authorize(resource_or_class, , query = nil, policy_class: nil)` helper in our controller. This is the MAIN thing you'll be doing for authorization.

By default Pundit will try to match the controller action in which it was called to an action in the corresponding Policy. In the example above `update` in the controller will automatically try to find an `update?` method in the policy. This is all overrideable in a per-case basis... check out Pundit's docs.

If `authorize` ever returns `false`, then the user will be redirected (or given a 403 in the case of the API) and given a corresponding "not authorized" message (see [ApplicationController#user_not_authorized](../app/controllers/application_controller.rb) for how we implement this).

You can also check authorization from the View layer by using the `policy` view helper:

```erb
<% if policy(@thing).update? %>
  <%= link_to "Edit thing", edit_thing_path(@thing) %>
<% end %>
```

> 💡 When a policy is initialized it automatically loads the current user and the record it will be authorizing for, and makes them available throughout the whole of the new policy instance. Check out the [ApplicationPolicy](../app/policies/application_policy.rb) to see the implementation.

> 💡 You will probably always want to make your policies inherit from [ApplicationPolicy](../app/policies/application_policy.rb) in order to DRY, as well as to make authorization work out-of-the-box. Notice how in [ApplicationPolicy](../app/policies/application_policy.rb) full access is given to admins by default, and no access for any other role is given.

### **Scopes**

Scopes are classes that live inside each resource-specific Policy class. They determine a filter for collections based on the User's context and/or roles:

```ruby
class ThingPolicy < ApplicationPolicy
  # ... policy methods ...
  class Scope < Scope # inherits from ApplicationPolicy::Scope
    def resolve
      if user.has_role?("admin")
        scope.all
      else
        scope.where(published: true)
      end
    end
  end
end

class ThingsController < ApplicationController
  def index
    @things = policy_scope(Thing.order(created_at: :desc)).limit(30) # policy_scope activates the filter for the provided class or ActiveRecord Relation.
  end
end
```

See how above the Index action calls `policy_scope` on top of a rather basic, and not user specific query? The result will only show records that are "published", unless the user is an admin.

Moreover, notice how we're able to chain ActiveRecord methods after filtering using our scopes. This is thanks to the fact that the Scope returns an ActiveRecord Relation.

### **Convention**

Pundit will infer the name of the Policy to invoke based on the `model_name` of the record it gets passed, or the `name` of the class it gets passed. This is, unless an explicit `policy_class` is passed in the options of `authorize`. The same goes for the name of the method, matching the name of the controller action it was invoked from.

## **Roles and Authentication**

### **Authentication**

We use [Devise](https://github.com/heartcombo/devise) as our authentication solution. Please refer to their instructions for how-to-use, and remember that our users have a modification from the Devise standard... we use `uuid` as the primary key type of the Users table.

<!-- For the API we use [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) as a plugin on top of Devise to enable access-token authentication on top of the default Devise's (cookie-based) method. -->

<!-- ### Facebook-API authentication

We currently allow users to sign-up and sign-in using Facebook from our front-end client. For this we have a "custom" `CustomerFacebookAuthController`. The controller exposes only one action, which is `facebook_login`. This is a find-or-create-by strategy, where the flow is:

1. The Client logs in to Facebook on the front-end, using the Facebook SDK or a wrapper.
2. The Client transfers the Facebook session to the back-end by hitting `<APP_PATH>/api/v1/facebook_login` and passing the Facebook access token as the `access_token` param.
3. We grab the `access_token` and instantiate "the same" Facebook session in our controller using the [Koala](https://github.com/arsduo/koala) library.
4. It then finds-or-creates the User and, if creating, populates the User details based on their Facebook profile.
5. It sends a response with the same shape as the standard Devise-based controller, passing a session, but this time the session is our own, instead of Facebook's. -->

### **Roles**

We use [Rolify](https://github.com/RolifyCommunity/rolify) to sprinkle our users with roles. With this schema, each user can have many roles, and a role can have many users. You'll typically find yourself using the following two helpers:

```ruby
# Add a role to a user
user.add_role "admin"
# or (interchangeably)
user.add_role :admin
# Add a role to a user for a specific resource
user.add_role :editor, Thing.first
# check if a user has a role
user.has_role?("admin") # true
user.has_role?(:admin) # also true
user.has_role?(:admin, Thing.first) # false
user.has_role?(:editor) # false
user.has_role?(:editor, Thing.first) # true
user.has_role?(:editor, :any) # true
```

> 💡 There are many more helpers that allow to remove roles, and create roles _en-masse_, check out Rolify's docs for more.

## **Controllers**

Controllers should be kept as RESTful as possible. Moreover the only logic that fits in a controller should be:

1. Get Authentication for the request
2. Authorize the action
3. Sanitize Parameters
4. Load the necessary data
5. Respond to the request

Anything beyond this should be properly encapsulated inside other corresponding layers, and/or be made redundant by a good system design. For instance, representational logic should be kept inside [Decorators](#decorators).

<!-- ### **API**

The API controllers are special in our application. Because we designed our API to be [JSON:API-compliant](https://jsonapi.org/), we are able to automate and delegate a lot of things to our API-sub-framework: [JSON:API Resources](https://github.com/cerebris/jsonapi-resources).

All you need to do is add `include JSONAPI::ActsAsResourceController` to your controller, and it will automatically include all the methods necessary for all the JSON:API-compliant routes.

After doing this, all you need to add is

```ruby
jsonapi_resources :things
```

to [routes.rb](../config/routes.rb).

Note that currently almost all of our API controllers inherit from [JSONAPIController](../app/controllers/api/v1/json_api_controller.rb), where we restrict (authorize) access, and add extra context to the request. Thanks to the magic of [JSON:API Resources](https://github.com/cerebris/jsonapi-resources) all of our API-specific controller except authorization are no more than a handful of lines long. -->

## **Decorators**

Decorators are meant to encapsulate anything that could be considered "conditional logic". Say for instance if an object's attribute is `nil` instead we wanted to show "Unknown" in the front-end. The obvious way would be to do the following:

```erb
  <% if thing.stuff %>
    <%= thing.stuff >
  <% else %>
    Unknown
  <% end %>
```

However, there are two main problems with doing this:

1. You are making the view more complex to read and to work with, by spreading extra logic all over the place.
2. It's hard to keep things DRY, since it is very likely that there are several places where we're displaying `thing.stuff`.

A number of hacky solutions could come to mind to solve these problems, for instance using partials (which could help with DRY, but the consequences of using partials for these tiny use cases just to prevent repetition could have equally unfortunate costs), or encapsulating this logic in the Model, which would lead to bloated models, and to a blatant disregard of responsibility boundaries (the model should not care about anything "View" specific!).

The solution we opted for instead is to use Decorators. We use [Draper](https://github.com/drapergem/draper) as a solution to streamline the use of Decorators. You can define decorators like this:

```ruby
class ThingDecorator < ApplicationDecorator
  delegate_all

  def stuff
   object.stuff || 'Unknown'
  end
end
```

In order to have a Decorated instance of an object just call `decorate` for instance or ActiveRecordRelation:

```ruby
thing = Thing.first.decorate
```

and then, from the view, just:

```erb
<%= thing.stuff >
```

The view code just got reduced by 80%!

👉 Note how Draper automatically matches the Decorator to the Model by matching the class names, i.e. "Thing" will look for a "ThingDecorator" to decorate the model. Alternatively a decorator can be specified as an option in the `decorate` method.
👉 See how the decorated instance will have access to the underlying original instance through the attribute accessor `object`. If we ommitted the `object` call in the above example for `ThingDecorator#stuff`, then we would get a stack overflow due to the method recursively calling itself.
👉 Notice the `delegate_all` declaration at the top of the Decorator? When we do this, if we call any method that is not declared in the Decorator, then it will try to pass it down to the underlying "Thing" instance. This is useful when we want to still work with the ActiveRecord methods/representation of an already-decorated object.

> 💡 For more advanced use-cases check out Draper's documentation.

## **Views**

Views in this application are rendered using the `.erb` extension, which stands for "embedded ruby" and basically allows us to sprinkle Ruby logic on top of html (and other file types too).

The way views are served is simple: any controller that inherits from `ActionController::Base` will execute whatever is given (if anything) as a block for the called action – e.g. `ThingsController#index` – and then by default responds with a view that matches the controller and the action name. In the previous example, the controller will look the file `app/views/things/index.html.erb` if the request was made through a browser with a GUI (i.e. by following a link, or entering an address in the address bar).

By default Rails tries to match the file it looks for to the request. That means that if the request is explicitly in a `js` or `json` format, then it would instead look for `app/views/things/index.js.erb` or `app/views/things/index.json.erb` respectively. Naturally serving a JSON document using ERB is probably overkill, therefore the render action can be overriden and passed a literal JSON-compliant hash instead.

As mentioned, one can use all kinds of Ruby statements when using ERB, just by using the `<% %>` and `<%= %>` brackets, to signify that there is Ruby to be interpreted before the view gets served. The `<% %>` brackets just execute whatever is put inside, but don't print anything themselves, while the latter actually print whatever they return into the HTML/JS document. This allows to do things like:

```erb
<ul>
  <% @things.each do |thing| %>
  <li><%= thing.name %></li>
  <% end %>
</ul>
```

**HOWEVER** if you find yourself doing a lot of conditional logic on your views, this is a great sign that you're not properly encapsulating your responsibilities. Consider:

```erb
<!-- DON'T DO THIS! -->
<ul>
  <% @things.each do |thing| %>
    <li>
      <% if thing.name.present? %>
        <%= thing.name %>
      <% else %>
        Unknown Name!
      <% end %>
    </li>
  <% end %>
</ul>
```

Both the fact that this makes views more complex and polluted, as well as the fact that you will probably want to reproduce this code in other parts of the application indicate that you should encapsulate that logic withing a [Decorator](#decorators):

```ruby
  class ThingDecorator < ApplicationDecorator
    # ...
    def name
      default = object.name
      return default if default.present?

      'Unknown Name!'
    end
  end

  # Then just decorate your object(s)
  class ThingsController < ApplicationController
    # ...
    def index
      @things = Thing.all.decorate
    end
  end
```

and go back to a happy, clean, and simple HTML template:

```erb
<ul>
  <% @things.each do |thing| %>
  <li><%= thing.name %></li>
  <% end %>
</ul>
```

<!-- ### React Components

This application is capable of rendering React components, and through the `react-on-rails` gem, we are able to pass data from our Rails controllers into the components, as props (and react-on-rails even auto-parses and camelizes the keys!).

For more details on how to use React components together with Rails, check out the [react-on-rails](https://github.com/shakacode/react_on_rails) gem documentation.

You can see a working example in this application by checking out the [Foos pack](../app/javascript/packs/foos.js), which loads the [FooThings Component](../app/javascript/components/foos/foo_things.jsx). This is in turn used in the HTML+ERB [foo form](../app/views/foos/_form.html.erb) in order to allow us to dynamically manage nested data for each foo's things, in a way similar to the [Cocoon gem](https://github.com/nathanvda/cocoon), but with more flexibility, without JQuery, and fully compatible with Rails 6. -->

## **Javascript**

This application moves away from the "traditional" way of managing javascript in Rails applications through the "asset pipeline", and instead moves to use [Webpack](https://webpack.js.org/) as its main driver, fully integrated into Rails thanks to the [Webpacker gem](https://github.com/rails/webpacker). You will find that we're serving javascripts, but also other assets, such as images, fonts, and stylesheets, all managed through javascript by using webpack, from the [app/javascript](app/javascript) folder.

Things that should get loaded globally (like tooltips) live in the [app/javascript/global](app/javascript/global) folder.

Things that are context, or domain-specific, as well as React components that are "react-on-rails-enabled" get packaged into "packs" (check the Webpacker documentation).

Basically anything you can do with Webpack is at the tips of your fingers here.
