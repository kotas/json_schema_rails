# json_schema_rails

[![Build Status](https://travis-ci.org/kotas/json_schema_rails.svg?branch=master)](https://travis-ci.org/kotas/json_schema_rails) [![Code Climate](https://codeclimate.com/github/kotas/json_schema_rails.png)](https://codeclimate.com/github/kotas/json_schema_rails)

[JSON Schema v4](http://json-schema.org/) validator and generator for Rails 3+

## Installation

Add this line to your application's Gemfile:

    gem 'json_schema_rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_schema_rails

## Usage

### Generate schema file

You can use generators to generate schema files for your controller.

    $ rails g schema:controller posts create update

It creates schema files at:

* app/schemas/posts/create.yml
* app/schemas/posts/update.yml

You can also generate a schema for specific action with some parameters.

    $ rails g schema:action posts::create title body:required published:boolean:required

It creates a schema file at:

* app/schemas/posts/create.yml

And it has title, body and published as parameters.

### Validate request parameters

You can validate request parameters with helper method `validate_schema` (which is before_filter):

```ruby
class PostsController < ApplicationController
  # Validate requests for all actions in this controller
  validate_schema

  def create
  end

  def update
  end
end
```

You can use options for `before_filter` if you want stop validation for specific actions:

```ruby
validate_schema excpet: :get
validate_schema only: [:create, :update]
```

If you want to specify a schema file to use, you can use `validate_schema` or `validate_schema!` in action methods:

```ruby
class PostsController < ApplicationController
  def create
    validate_schema! "my_schema"   # uses "app/schemas/my_schema.{yml,yaml,json}"
  end
end
```

`validate_schema!` raises `JsonSchemaRails::ValidationError` when the validation failed.

`validate_schema` just returns `true` or `false` as the validation result.

### Error handling

When validation fails, it raises `JsonSchemaRails::ValidationError` which is handled by `schema_validation_failed` method of controllers.

The default handler re-raises the error in development, and renders 400 response (Bad Request) in any other env.

If you want to handle errors by yourself, just define `schema_validation_failed` method to your ApplicationController:

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

  def schema_validation_failed(exception)
    # Do It Yourself
  end
end
```

### Serve schemas in your application

If you want to use your schemas in your client JavaScript, the mountable engine `JsonSchemaRails::Engine` provides a route for serving schemas in you application.

To use it, write the following in your `config/routes.rb`:

```ruby
Your::Application.routes.draw do
  mount JsonSchemaRails::Engine => '/schemas'
end
```

And you can get your schemas through the path `/schemas` like following:

```
# Get `app/schemas/posts/create.*` as application/json
GET /schemas/posts/create.json
GET /schemas/posts/create

# Get `app/schemas/posts/update.*` as text/yaml
GET /schemas/posts/update.yaml
```

To get a path to a specific schema's endpoint, call `json_schema_rails.schema_path(schema_name)` or `json_schema_rails.schema_url(schema_name)`.

```ruby
# In your controller or view
json_schema_rails.schema_path("posts/create")  # "/schemas/posts/create"
json_schema_rails.schema_url("posts/update")   # "http://example.com/schemas/posts/create"
```

You can change `json_schema_rails` part of above by specifying `as` parameter when mounting the route:

```ruby
Your::Application.routes.draw do
  mount JsonSchemaRails::Engine => '/schemas', as: 'json_schema'
end

# And you can call the helpers as
json_schema.schema_path("posts/create")
json_schema.schema_url("posts/update")
```

### Validate schema files

json_schema_rails provides a rake task `schema:check` to validate your schema files.

    $ bundle exec rake schema:check

By default, it uses the strict schema which does not allow you to define unknown properties so that misspelling is checked.

If you want to use official schemas which is more loose, pass `LOOSE=1` to rake command.

    $ LOOSE=1 bundle exec rake schema:check

## TODO

* Hook generators like controller or resource to generate schema files as well
* Write about hyper schema support

## Contributing

1. Fork it ( https://github.com/kotas/json_schema_rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
