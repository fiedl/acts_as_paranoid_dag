

require 'acts_as_dag_with_paranoia'

# This is the required database structure.
ActiveRecord::Schema.define( :version => 1 ) do

  create_table :users, force: true do |t|
    t.string :name
  end

  create_table :groups, force: true do |t|
    t.string :name
  end

  create_table :dag_links, force: true do |t|
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


# This is how to include the functionality in the models.
class DagLink < ActiveRecord::Base
  acts_as_dag_links polymorphic: true, paranoia: true
end

class User < ActiveRecord::Base
  has_dag_links link_class_name: "DagLink", ancestor_class_names: %w(Group)
end

class Group < ActiveRecord::Base
  has_dag_links link_class_name: "DagLink", ancestor_class_names: %w(Group), descendant_class_names: %w(Group User)
end

