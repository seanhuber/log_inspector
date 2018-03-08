[![Gem Version](https://badge.fury.io/rb/log_inspector.svg)](https://badge.fury.io/rb/log_inspector)
[![Build Status](https://travis-ci.org/seanhuber/log_inspector.svg?branch=master)](https://travis-ci.org/seanhuber/log_inspector)
[![Coverage Status](https://coveralls.io/repos/github/seanhuber/log_inspector/badge.svg?branch=master)](https://coveralls.io/github/seanhuber/log_inspector?branch=master)

log_inspector
==============

`log_inspector` is a mountable Rails engine with routes/views for displaying the contents of your Rails log directory (or any other directory).


Demo
-----------------------------

A live demo can be found at:

http://log-inspector.seanhuber.com

![Screenshot](https://cdn.rawgit.com/seanhuber/log_inspector/master/screenshot.png)


Requirements and Dependencies
-----------------------------

Unix based operating system (Apple OSX or Linux).

  > The unix commands `wc` and `tail` are used to get log file contents and line counts.

Rails >= 4.2

  > This engine was developed with Rails 4.2 and has been tested to work with Rails 5.0.x and 5.1.x.

jQuery and jQuery-ui.

  > These are required by the `folder-tree` jQuery widget (which is used to display the contents of the log folder).  For more information on `folder-tree`, see: https://github.com/seanhuber/folder-tree


Installation
-----------------------------

Add to your `Gemfile`:

```ruby
gem 'log_inspector', '~> 1.1.2'
```

Then, `bundle install`.


Configuration and Usage
-----------------------------

For basic usage, mount the engine in `config/routes.rb`, e.g.,

```ruby
Rails.application.routes.draw do
  mount LogInspector::Engine => '/log_inspector'
  # ... your other application routes
end
```

Restart your rails server and navigate to <http://localhost:3000/log_inspector>

Click on subfolders to expend them and click on text-based files to view their contents in the preview pane.

If your log directory is located somewhere that is not `<app root>/log`, you can set the path in an initializer:

```ruby
LogInspector.log_path = '/path/to/log/directory'
```

If you want to embed `log_inspector` inside of a custom view, you'll first need to add to `log_inspector`'s assets to the pipeline.  In `app/assets/stylesheets/application.css`, add:

```css
/*
 *= require log_inspector/folder-tree
 *= require log_inspector/log-inspector
 */
```

In `app/assets/javascripts/application.js`, add:

```javascript
//= require log_inspector/folder-tree
//= require log_inspector/log_inspector
```

Then in an `erb` view file, render `log_inspector`'s primary partial:

```
<%= render partial: 'log_inspector/panes' %>
```


### Security

Generally you would not want to expose the contents of your log files in the production environment, but `log_inspector` does not have any restrictions built in.  To add constraints it's advised that you add them yourself, see: http://guides.rubyonrails.org/routing.html#advanced-constraints

To simply disable all routes in the production environment you could modify your `config/routes.rb` to something like:

```ruby
Rails.application.routes.draw do
  mount LogInspector::Engine => '/log_inspector' unless Rails.env.production?
  # ... your other application routes
end
```

Or if you do want the engine enabled in production and wish to limit access to specific users, try a strategy like this:

```ruby
Rails.application.routes.draw do
  mount LogInspector::Engine => '/log_inspector', constraints: CustomConstraint.new
  # ... your other application routes
end
```

And define your `CustomConstraint` class in `lib/custom_constraint.rb`:

```ruby
class CustomConstraint
  # this class assumes you've set a session variable 'user_roles' which is an array of strings
  def matches?(request)
    request.session['user_roles'].is_a?(Array) && request.session['user_roles'].include?('admin')
  end
end
```


License
-----------------------------

MIT-LICENSE.
