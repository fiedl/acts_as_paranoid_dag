
require 'spec_helper'

require 'acts-as-dag'

describe "ActsAsDagWithParanoia::ModelAdditions" do

  with_model :User do
    table do |t|
      t.string :name
    end
    model do
      has_dag_links link_class_name: "DagLink"
    end
  end

#  with_model :Group do
#    table do |t|
#      t.string :name
#      t.timestamps
#    end
#    model do
#    end
#  end
#
  with_model :DagLink do
    table do |t|
      t.integer :ancestor_id
      t.string  :ancestor_type
      t.integer :descendant_id
      t.string  :descendant_type
      t.boolean :direct
      t.integer :count
      t.datetime :deleted_at
      t.timestamps
    end
    model do
    end
  end

#  with_model :User do
#    model do
#      has_dag_links link_class_name: "DagLink", ancestor_class_names: %w(Group)
#    end
#  end
#
#  with_model :Group do
#    model do
#      has_dag_links link_class_name: "DagLink", ancestor_class_names: %w(Group), descendant_class_names: %w(Group User)
#    end
#  end
#
#  with_model :DagLink do
#    model do
#      acts_as_dag_link polymorphic: true
#    end
#  end
#
#
  def reset_database
    User.delete_all
#    Group.delete_all
#    DagLink.unscoped.delete_all
  end

  def create_basic_entries
    @user = User.create( name: "John Doe" )
#    @parent_group = Group.create( name: "Parent Group" )
#    @sub_group = Group.create( name: "Sub Group of the Parent Group" )
#    @other_group = Group.create( name: "Yet Another Group" )
  end

  before( :each ) do
    reset_database
    create_basic_entries
  end

  it "should work to create the basic database entries" do
  end
#
#  it "should work to connect the groups" do
#    @parent_group.child_groups << @sub_group
#    @parent_group.children.include?( @sub_group ).should be_true
#  end
#
#  it "should work to connect a user to a group" do
#    @sub_group.child_users << @user
#    @sub_group.children.include?( @user ).should be_true
#  end
#  
#  it "should implicitly connect also the parent group to the user" do    
#    @parent_group.child_groups << @sub_group
#    @sub_group.child_users << @user
#    @parent_group.descendants.include?( @user ).should be_true
#  end
#
#  it "should work to delete a connection" do
#    @sub_group.child_users << @user
#    @sub_group.children.include?( @user ).should be_true
#    link = @user.links_as_child.first
#    link.destroyable?.should be_true
#    link.destroy
#    @user.links_as_child.count.should eq( 0 )
#  end
#
#  it "should work to retrieve deleted connections" do
#    @sub_group.child_users << @user
#    link = @user.links_as_child.first
#    link.destroy
#
#    # This asks for the number of undeleted links.
#    @user.links_as_child.count.should eq( 0 )
#
#    # This asks for the number of all, even the deleted, links. 
#    @user.links_as_child.unscoped.count.should eq( 1 )
#  end
#
#  it "should still work to create a new link after deleting another" do
#    # This is to make sure that the deleting process does not compromise the 
#    # link database.
#    
#    @sub_group.child_users << @user
#    link = @user.links_as_child.first
#    link.destroy
#
#    @parent_group.child_groups << @sub_group
#    @parent_group.children.include?( @sub_group ).should be_true
#  end
#
#  it "should still work to recreate a link after deleting it" do
#    @sub_group.child_users << @user
#    link = @user.links_as_child.first
#    link.destroy
#
#    @sub_group.child_users << @user
#    @sub_group.children.include?( @user ).should be_true
#  end
#
#  it "should be possible to delete and recreate a link twice" do
#    @sub_group.child_users << @user
#
#    2.times do
#      link = @user.links_as_child.first
#      link.destroy
#      @sub_group.child_users << @user
#    end
#
#    @sub_group.children.include?( @user ).should be_true
#  end


end
