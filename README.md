# Intro Testing
## RSpec Rails


## Setup

Let's start from scratch, and see how far we can get with our dev process.


* `rails new intro_testing -T -d postgresql`
* `cd intro_testing`
* `rake db:migrate`


## Models Models Everywhere...

Let's setup a `1:N` relationship between `articles` and `users`.

* Let's generate the `user` model

	```
	rails g model user email:string, password_diges:string
	```
* Let's generate the `article` model

	```
	rails g model article title:string content:text
	
	```
* Let's migrate our changes

	```
	rake db:migrate
	```
* Let's add the `user_id` foriegn key to the `article` model

	```
	rails g migration AddUserIdToArticles user_id:integer
	```
* Let's migrate our changes

	```
	rake db:migrate
	```
	
* Let's setup the association between the models

	```
	class User < ActiveRecord::Base
		has_many :articles
	end
	
	```

	```	
	class Article < ActiveRecord::Base
		belongs_to :user
	end
	
	```


* Let's play with our models in `rails console` to make sure these were setup correctly.

	```
	> user = User.create({email: "b@b.com", password: "b", password_confirmation: "b"})
	> article = user.articles.create({title: "blah", content: "blah"})
	> article.user
	```
	* If you had any isssues with the last console exercise then you'll probably want to check you model files and migrate your database.
	

## Testing Setup


* Install `rspec-rails` by adding it to your `Gemfile`.

	```
	group :development, :test do
		gem 'rspec-rails', '~> 3.0'
	end
	```
	* run `bundle install` to install
* Setup rspec in you project

	```
	rails generate rspec:install
	```
	
	* Visit the `.rspec` file and remove `--warnings` flag.
* Generate some model spec files

	```
	rails g rspec:model user
	```
	
	```
	rails g rspec:model article
	```

## Testing Our User


* Let's start creating tests for user model [validations](http://guides.rubyonrails.org/active_record_validations.html). Hint: to get these to pass you'll need to use `has_secure_password`, `validates_confirmation_of`, and `validates_presence_of`

```

require 'rails_helper'

RSpec.describe User, :type => :model do

	describe "validations" do
	
		it "should confirm a user :email" do
			user = User.new({email: "blah", email_confirmation: "bla"})
			expect(user.save).to be(false)
		end
		
		it "should confirm a user :password" do
			user = User.new({password: "blah", password_confirmation: "bla"})
			expect(user.save).to be(false)
		end
	
		it "should not create a user with a blank password" do
			user = User.new({email: "blah@blah.com", email_confirmation: "blah@blah.com"})
			expect(user.save).to be(false)
		end
		
		it "should not create a user with a blank email" do
			user = User.new({password: "blah", password_confirmation: "blah"})
			expect(user.save).to be(false)
		end
		
		it "should require :password confirmation" do
			user = User.new({email: "blah@blah.com", email_confirmation: "blah@blah.com", passsword: "blah"})
			expect(user.save).to be(false)
		end
		
		it "should require :email confirmation" do
			user = User.new({email: "blah@blah.com", password: "blah", password_confirmation: "blah"})
			expect(user.save).to be(false)
		end
		
		it "should validate :password length to be greater than 8 characters"  do
			user = User.new({email: "blah@blah.com", password: "abcdefg", password_confirmation: "abcdefg"})
			expect(user.save).to be(false)
		end
		
		## Bonus
		
		it "should validate the :email format" do
			user = User.new({
								email: "blah", 
								email_confirmation: "blah",
								password: "blahblah", 
								password_confirmation: "blahblah"
							})
			expect(user.save).to be(false)
		end
		
		it "should validate the :password format to conain upper and lowercase letters" do
			user = User.new({
								email: "blah@blah.com", 
								email_confirmation: "blah@blah.com",
								password: "blahblah", 
								password_confirmation: "blahblah"
							})
			expect(user.save).to be(false)
		end
	end
	
end

```

* Try to get these model validation tests to pass using your knowledge of validations.

## Model Solution

Hopefully you tried pretty hard before jumping to the solution...


```
	class User < ActiveRecord::Base
		has_many :articles
		
		has_secure_password
		
		validates_confirmation_of :email
		validates_presence_of :password_confirmation
		validates_presence_of :email_confirmation
		validates_length_of :password, minimum: 8
		validates_format_of :email, with: /.+@.+/
		validate_format_of :password, with: /.*(([A-Z].*[a-z])|([a-z].*[A-Z])).*/
		
	end

```

## Testing User Class Methods


Let's continue testing our `user` model

```

require 'rails_helper'

RSpec.describe User, :type => :model do

	describe "validations" do
	
		...
	end
	
	describe "self.confirm" do
		
		it "should return false when user doesn't exist" do
			expect(User.confirm("blahblah", "blahblah")).to be(false)
		end
		
		it "should return false when user password is incorrect" do
			user = User.create({
								email: "blah@blah.com", 
								email_confirmation: "blah@blah.com",
								password: "blahBLAH", 
								password_confirmation: "blahBLAH"
							})
			expect(User.confirm("blah@blah.com", "blahblah")).to be(false)
		end
		
		it "should return user when password is correct" do
			user = User.create({
								email: "blah@blah2.com", 
								email_confirmation: "blah@blah2.com",
								password: "blahBLAH", 
								password_confirmation: "blahBLAH"
							})
			expect(User.confirm("blah@blah2.com", "blahBLAH")).to be(false)
		end

	end
	
end

```

## Testing Further 

Use these ideas for model testing to write methods and tests for your `article` model.
	
