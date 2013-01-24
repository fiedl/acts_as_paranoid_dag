# ActsAsParanoidDag  [![Build Status](https://secure.travis-ci.org/fiedl/acts_as_paranoid_dag.png?branch=master)](http://travis-ci.org/fiedl/acts_as_paranoid_dag)

**acts_as_paranoid_dag** is a **ruby on rails gem** that combines the gems [acts-as-dag](https://github.com/resgraph/acts-as-dag) and [rails3_acts_as_paranoid](https://github.com/goncalossilva/rails3_acts_as_paranoid) to order model instances in a polymorphic directed acyclic graph and to be able to retrieve connections deleted in the past.

For example, I'm using this to have a user-group structure, where I can query for group memberships deleted in the past.


## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_paranoid_dag'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_paranoid_dag
	
## Preparation

I'm assuming that you would like to extend the functionality of your existing DagLink model. That is, you already have a model `DagLink`.
```ruby
class DagLink < ActiveRecord::Base
  acts_as_dag_links polymorphic: true
end
```

In your DagLink model, you'll need an extra column for saving the datetime of deletion.
```
$ bundle exec rails generate migration AddDeletedAtToDagLink deleted_at:datetime
$ rake db:migrate
```

Have a look at [this database schema from the gem's specs](https://github.com/fiedl/acts_as_paranoid_dag/blob/master/spec/support/schema.rb). 

## Usage

In your DagLink model, just add the option `paranoid: true`.

```ruby
class DagLink < ActiveRecord::Base
  acts_as_dag_links polymorphic: true, paranoid: true
end
```

Then you can retrieve links using the scopes `now`, `ìn_the_past` and `now_and_in_the_past`.

```ruby
# create link between user and group, just as in acts-as-dag
group1 = Group.create( ... )
group2 = Group.create( ... )
user = User.create( ... )
group1.child_users << user
user.links_as_child.first.destroy
group2.child_users << user

# now use the new scopes
user.links_as_child.now.count # => 1
user.links_as_child.in_the_past.count # => 1
user.links_as_child.now_and_in_the_past.count # => 2
user.links_as_child.at_time( 1.hour.ago ).count # => 0

# deleting links
link = user.links_as_child.now.first
link.destroy # mark this link as deleted, but leave it in the database
link.destroy! # really delete the link from the database
```

You may want to have [a look at this specs](https://github.com/fiedl/acts_as_paranoid_dag/blob/master/spec/acts_as_paranoid_dag/model_additions_spec.rb).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
