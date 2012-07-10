
# The method used here to test the active record extensions with rspec
# has been adapted from https://github.com/rrn/acts_as_dag/blob/master/spec/spec_helper.rb .

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'active_record'
require 'logger'
require 'acts-as-dag'
require 'acts_as_dag_with_paranoia'

ActiveRecord::Base.logger = Logger.new( STDOUT )
ActiveRecord::Base.logger.level = Logger::INFO
ActiveRecord::Base.establish_connection( :adapter => "sqlite3", :database => ":memory:" )

ActiveRecord::Schema.define( :version => 0 ) do

  create_table :users, :force => true do |t|
    t.string :name
  end

  create_table :groups, :force => true do |t|
    t.string :name
  end

  create_table :dag_links, :force => true do |t|
    t.integer :ancestor_id
    t.string  :ancestor_type
    t.integer :descendant_id
    t.string  :descendant_type
    t.boolean :direct
    t.integer :count
    t.datetime :deleted_at
    t.timestamps
  end

end

class User < ActiveRecord::Base
  has_dag_links link_class_name: "DagLink", ancestor_class_names: %w(Group)
end

class Group < ActiveRecord::Base
#  has_dag_links link_class_name: "DagLink", ancestor_class_names: %w(Group), descendant_class_names: %w(Group User)
end

class DagLink < ActiveRecord::Base
#  acts_as_dag_links polymorphic: true
end




#ENV["RAILS_ENV"] = "test"


#require "active_record"
#require "with_model"

#require File.expand_path('../../test_app/config/environment', __FILE__)

#require "rspec/rails"
#require "nokogiri"

# Load support files
#Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each{|f| require f}

#RSpec.configure do |config|

#  require 'rspec/expectations'

#  config.include RSpec::Matchers

#  config.extend WithModel

#  Capybara.javascript_driver = :webkit

#  config.mock_with :rspec
#end


