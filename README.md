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


# 3 Testing configuration

## 3.1 [rspec-rails] configuration  

It's necessary to install [rspec-rails] from the command line  

```
bin/rails g rspec:install
```  

which will add  

- .rspec  
- spec/spec_helper.rb  
- spec/ralis_helper.rb  

to the project.  

[rspec-rails]' command is  `bundle exec rspec` to run all tests.  

Right now, the commend raises an error  

```
Migrations are pending.... run 
     bin/rails db:migrate RAILS_ENV=test
```  

From the command line again  

```
 bin/rails db:migrate RAILS_ENV=test
```  

which produces a test database migration  

![test-migration][test-migration]  

## 3.2 [FactoryGirl] configuration  

Because of `gem 'factory_girl_rails'`, `rails g resource` generates *FactoryGirl* files with factories located at `spec/factories/`.  

Before writing any tests, [FactoryGirl] needs to be configured to run with our app.  Include this line in `spec/rails_helper.rb`  

```ruby
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
```  

Once hooked up, its time to refractor the default factories to suit our test needs.  
In `spec/factories/models/user_spec.rb`  

```ruby
FactoryGirl.define do
  
  factory :user_1 , class: User do
    email "user1@email.com"
    firstName "first Name"
    lastName "last Name"
    about "something about this user"
  end

end
```  

This **factory**  

- is called `:user_1`  
- is of type User (creates instances of User Model)
- no associations are present... yet  

This will allow us to create a in our [rspec-rails] tests, by running [FactoryGirl] commands such as  

```ruby
create(:user_1)
```  

which will create a new user with the factory pre-set fields, or  

```ruby
attributes_for(:user_1)  
```  

which will return a hash with the factory attributes  

```ruby
{:email=>"user1@email.com", :firstName=>"first Name", :lastName=>"last Name", :about=>"something about this user"}
```  

Other factories will be added as we advance.  


# 4 Model Tests  

## 4.1 User Model tests

### 4.1.1 email validation test

For the first test, we will verify that the user **MUST** have an `Email, First Name, Last Name and About` fields.  Without these, the record should **NOT** save.  

For the email in `spec/models/user_spec.rb`  

```ruby
require 'rails_helper'

RSpec.describe User, type: :model do

  describe "\n------------>User VALIDATION<------------\n" do 

    it "\n------------>Doesnt save without email<-------------\n" do 
      @user = build(:user_1)
      @user.email = nil

      expect(@user.save).to eq false
      expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid, /Email can't be blank/)
    end

  end

end
```    

This *rspec* test  

- uses [FactoryGirl]'s `build` method to prepare factory user_1 for saving  
- sets the email to *nil*  
- uses [Rspec Expectations] to run against some code, `@user.save` in this case  
- expects `false`, `ActiveRecord::RecordInvalid` to be the result of a trying to save a record with no *email*  
- uses a *regex* to check the contents of the *error message*  

When this code is runs, if these expectations are not met, the test fails  

![user-test1-fail][user-test1-fail]  

To make this test pass, [Rails Validations] are needed.  
Refractor `app/models/user.rb`  

```ruby
class User < ApplicationRecord

  validates :email, presence: true

end
```  

Now running [rspec-rails]' command `bundle exec rspec spec/models/user_spec.rb`, the test passes.  


### 4.1.2 email uniqueness test  

The test to ensure that the email is unique  

```ruby
it "\n------------>Ensures email uniqueness<-------------\n" do 
  @user1 = create(:user_1)
  @user = build(:user_1)

  expect(@user.save).to eq false
  expect { @user.save! }.to raise_error ActiveRecord::RecordInvalid, /Email Already Taken!/
end   
```  

When `expect(@user.save).to eq false` runs, the test fails and the record is saved because the Model does not have any [Rails Validations] for the *uniqueness* of the email.  

In `app/models/user.rb`  

```ruby
before_save { self.email = email.downcase }

validates :email, 
  presence: true,
  uniqueness: { case_sensitive: false, message: "Email Already Taken!" }
```  

For the purposes of uniqueness, a [Rails Callback] was added to the model to downcase `email`before saving the record to ensure `Tom@example.com` and `tom@example.com` are treated as the *same* email.  

Now the test passes.  


### 4.1.3 firstName validation test  

For `firstName`  

```ruby
it "\n------------>Ensures firstName present<-------------\n" do 
  @user = build(:user_1)
  @user.firstName = nil

  expect(@user.save).to eq false
  expect { @user.save! }.to raise_error ActiveRecord::RecordInvalid, /FirstName can't be blank/
end 
```  

and in `app/models/user.rb`  

```ruby 
validates :firstName,
  presence: true
```  

And similarly for the Model's `lastName` and `about`.  
Once that implemented, we have a working User Model.  

## 4.2 Message Model tests -with associations  

### 4.2.1 Migrations for [Rails Associations]

The database table for the `Message` Model needs column `user_id` for the [Rails] association  
```
bin/rails g migration AddUserRefToMessages user:references
```  

This generates  

```ruby
class AddUserRefToMessages < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :user, foreign_key: true
  end
end
```  

which will create the corresponding column for the association on the `Message` Model.  
To make this happen run  

```
bin/rails db:migrate
```  

The shema, at `db/schema.rb` now looks like  

```ruby
create_table "messages", force: :cascade do |t|
  t.string   "title"
  t.text     "body"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.integer  "user_id"
  t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
end
```  

The test database needs to be prepared too  

```
bin/rails db:migrate RAILS_ENV=test
```  


### 4.2.2 Message Model Spec  

To test the `Message` & `User` association, create a message and make the `user_id = nil`.    If the *association* exists, then saving this record with a **nil** *reference* to the association would return *false*; if this returns true, the test for the association failed.  

```ruby
it "should not save message without association" do 
  @message = Message.new title: 'some title', body: 'some body', user_id: nil
  
  expect(@message.save).to be false
end
```  

Which *fails*  

![association fail][association fail]  

To make this test pass, the `Message` and `User` *Model* must contain the appropriate associations  


#### [Rails Associations]  

Each `User` can have multiple *messages* and *comments*

```ruby
class User < ApplicationRecord
  has_many :messages
  has_many :comments
end
```  

Each `Message` belongs to a `User` **and** can have multiple *comments*  

```ruby
class Message < ApplicationRecord
  belongs_to :user
  has_many :comments
end
```  

Note the plural on both associations.  
Finally, each `Comment` belongs to a `User` and a `Message`  

```ruby
class Comment < ApplicationRecord
  
  belongs_to :user
  belongs_to :message
  
end
```  

Note the plural for the `has_many` vs the singular for the `belongs_to`.  
Now the test passes because the Models have been linked and the database expects a *reference* in Model objects that are linked.  

The rest of the tests pertain to *validation* for the title and the body

```ruby
# for the title 

expect(@message.save).to be false
expect{ @message.save! }.to raise_error ActiveRecord::RecordInvalid, /Title can't be blank/

# for the body

expect(@message.save).to be false
expect{ @message.save! }.to raise_error ActiveRecord::RecordInvalid, /Body can't be blank/
```  


## 4.3 FactoryGirl for Controller specs  

[FactoryGirl Associations] are very convenient for testing.  

```ruby
factory :user_with_messages, class: User do 
  email "user_with_messages@example.com"
  firstName "first Name"
  lastName "last Name"
  about "something about this user"

  factory :messages_for_user do 

    transient do 
      message_count 3
    end

    after(:create) do |user, evaluator| 
      create_list(:message_1, evaluator.message_count, user: user)
    end

  end

end
```  

Here, `:messages_for_user` factory  

- is inside `user_with_messages`  
- has a `transient` attribute: `message_count`  
    + available as a factory attribute and in [FactoryGirl Callback]s
- [FactoryGirl Callback] `after()` yields  
    + User instance `:user_with_messages` in this case  
    + an `evaluator` with ALL the factory values  
- `create_list()` method takes
    + factory to use: `:message_1` in this case  
    + number of records to create: *transient attribute* `message_count`
    + **associating** to user 


Factory `:message_1` looks like this  

```ruby
FactoryGirl.define do

  factory :message_1, class: Message do
    association :user
    
    title "some title for a message"
    body "Some message I have for the world to read!"
  end
  
end
```  

Here, `association :user` ties this factory to the *User Model* and the factory will **FAIL** to create if the *association* is not present.     


Code like  

```
create(:messages_for_user)
```  

will  

- automatically create the parent factory: `:user_with_messages`
- run the `after(:create)` callback and produce `message_count` messages  

It's possible to override the `transient attribute`  

```
create(:messages_for_user, message_count: 10)
```  

# **TO BE CONTINUED IN PART II ...**


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
[Eager Loading Associations]: http://guides.rubyonrails.org/active_record_querying.html#eager-loading-multiple-associations
[rspec-rails]: https://github.com/rspec/rspec-rails
[FactoryGirl]: https://github.com/thoughtbot/factory_girl
[FactoryGirl Associations]: http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Associations
[FactoryGirl Callback]: http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Callbacks
[Rspec Expectations]: https://github.com/rspec/rspec-expectations
[Rails Validations]: http://guides.rubyonrails.org/active_record_validations.html
[Rails Callback]: http://guides.rubyonrails.org/active_record_callbacks.html#callbacks-overview


[rails-pic]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/rail.png
[mvc-pic]: https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/MVC-Process.svg/300px-MVC-Process.svg.png
[bootstrap-pic]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/bootstrap.png
[database.yml]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/databaseYaml.png
[bin/rails server]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/railsServer.png
[User scaffold]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/userScaffold.png
[test-migration]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/test-migration.png
[user-test1-fail]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/test1_fail.png
[association fail]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/associationFail.png