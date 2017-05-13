![rails-pic][rails-pic]  

# [Ruby] On [Rails] Message Board  


<small>Follow at: **<a href="http://zencodemaster.com/coding-post/3" target="_blank">ZenCodeMaster.com**</a></small>

[Rails] is a very popular [MVC] framework.  

![mvc-pic][mvc-pic]

We are going to use it to let a user:  

- connect to a db
- create an account
- display other users
- display other users messages (root view)
- display single message with comments
- create a message (if logged in)
- create a comment to a message (if logged in)

We will be styling our message board with [Bootstrap].  

Lets begin.  

I am assumming that you have all the requirements installed:  

- ruby
- rails
- postgres  
(if using other databases, *configure config/database.yml accordingly*)


## 1. Crate a rails application via `rails new`  

Create a folder for the application and call it... anything you want;I'll use `railsmessageboard`  

```
rails new railsMessageBoard
```  

Initiate a [Git] repository  

```
git init
```  

then commit and do your first push.  

Now it's time to configure `configure/database.yaml` to connect to the database.  
Make it look like this:  

![database.yml][database.yml]  

[Rails]' default database is sqlite3.  
Accomodate accordingly, I am using [Postgre] :  

```
source 'http://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap-sass'


group :development do 
  gem 'web-console'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 3.5'
  gem 'rails-controller-testing'
  gem 'factory_girl_rails', "~> 4.0"
  gem 'capybara'
  gem 'faker'

end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise'

```

A few things here,  

- `gen devise` 
 + is an authentication mechanism 
- `gem gootstrap-sass`
 + for styling (we have to manually hook  
 this up at `app/assets/stylesheets/application.css`) 
- testing gems (we're gonna test before we implement)  

To install all of these dependencies run  

```
bundle install
```  

As of Rails 5, rake commands are build into the [Rails] executable.  `bin/rails` is the new way of running commands (more on [bin/rails]).  
Now check that the app scaffolded app runs by launching [Rails]' build in server  

```
bin/rails server
```  

from the root of the app.  

![bin/rails server][bin/rails server]  

Open a browser and navigate to the default [Rails] port 3000 `localhost:3000`.  
If you get a `Yay! You're on Rails!` welcome page, all is well.  
If not... check the rails server output in the console from where you ran the command.  


# 2. Generate Models and Migrations

Before preparing the database for usage ([Rails Migration]) and beginning our testing, we could generate a scaffold which is a full set of  

- Model
- migration
- Controller (with methods for all HTTP requests)
- Views (to fullfil each Controller#method)  

to manipulate data by running  

```
bin/rails g scaffold User email:string firstName:string lastName:string about:text
```  

*This tends to generate too much unnecessary code for our simple application.  
We will use another kind of generator*  

```
bin/rails g resource User email:string firstName:string lastName:string about:text
```

Which generates a stripped down version of the former command.  
We are also going to generate the same for the Messages and the Comments.  

```
bin/rails g resource Message title:string body:text
```  

```
bin/rails g resource Comment body:text
```  

We are going to take care of the [Rails Associations] in a little bit.  Associations are a way of connecting models.  
Running the server right now will produce an error because there are migrations that have not run on the database.  It's time to run a [Rails Migration] to prepare the database.  

```
bin/rails db:migrate
```  

Now, the server will work just fine.  


# 3. [Devise] (Authentication)


[Devise] is an Authentication system, it will alter the User Model and add some fields to the table.  Run   

```
bin/rails g devise:install
```  

Before connecting [Devise] to a Model (User), some configuration is due:  

In `config/environments/development.rb` add  

```
config.action_mailer.defulat_url_options = { host: 'localhost', port: 3000 }
```

To satisfy [Devise]'s and [Rails]' **flash** messages, add `app/views/layouts/application.html.erb`

```html
<div class="">
  <% flash.each do |message_type, message| %>
    <div class="alert alert-<%= message_type %> cFlashMsg"><%= message %></div>
  <% end %>
</div> 
```  

to `app/views/layouts/application.html.erb`

Devise is now ready to create/authenticate users.  


# 4. A bit about [MVC] frameworks

The server will **not** serve our app at this stage, because there are a few components missing from our [Rails] framework.  

Following the [MVC] framework *(Model-View-Controller)*  

- `User` is the model
- `MessagesController` satisfies the controller
    + and `#index` the action that renders the *view*  

To satisfy the view part of the [Rails] framework, create `app/views/messages/index.html.erb`, empty code is fine just like `MessagesController#index`

In `config/routes.rb` a root route needs to be hard coded  

```ruby
root to: 'message#index'
```  

In `app/controllers/messages_controller.rb` implement `#index`   

```ruby
def index

end
```  
  
The body's of `#index` and `index.html.erb` will be coded as we test the application.  

Now the server will point to our root configuration in `config/routes.rb` and render an empty page, which is exactly what we have thus far.  


# 4. First Tests Rspec -Models  






















[Ruby]: https://www.ruby-lang.org/en/
[Rails]: http://rubyonrails.org/
[MVC]: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller`
[Bootstrap]: http://getbootstrap.com/getting-started/
[Git]: https://git-scm.com/
[Postgre]: https://www.postgresql.org/about/
[Rails Migration]: http://guides.rubyonrails.org/active_record_migrations.html
[bin/rails]: http://guides.rubyonrails.org/command_line.html#bin-rails
[Rails Associations]: http://guides.rubyonrails.org/association_basics.html
[Devise]: https://github.com/plataformatec/devise



[rails-pic]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/rail.png
[mvc-pic]: https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/MVC-Process.svg/300px-MVC-Process.svg.png
[bootstrap-pic]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/bootstrap.png
[database.yml]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/databaseYaml.png
[bin/rails server]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/railsServer.png
[User scaffold]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/userScaffold.png