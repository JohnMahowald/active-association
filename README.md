# Active-Association

ActiveAssociation aims to recreate the basic functionaly of Rails Active Record. It is an exercise in meta programming and understanding the how Active Record is able to dynamically create active record relations and simplify database interactions. 

This project was built in pair with [Ruby on Sails](https://github.com/JohnMahowald/ruby-on-sails) where I build the basic functionality of Rails' controller, router & server. To view the project, check out the [repo here](https://github.com/JohnMahowald/ruby-on-sails).

## Key Features:

1. Meta programming techniques to create methods for generating SQL queries to databases.
2. Automatically produces methods for the Rails has_many, belongs_to, and has_one_through associations.
3. Follows Rails naming convention by automatically generating association names by utilizing Rails inflector module.

## To Run (specs):

1. Clone Repo
2. bundle install
3. rspec spec/

## About:

To learn more about me and my work as a developer, please visit my website at: [www.johnmahowald.com](http://www.johnmahowald.com)