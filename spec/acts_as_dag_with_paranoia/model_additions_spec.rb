
require 'spec_helper'

describe "ActsAsDagWithParanoia::ModelAdditions" do

  with_model :User do
    table do |t|
      t.string :name
      t.timestamps
    end
    model do
      attr_accessible :name
      def set_name_example
        self.name = "Max Mustermann"
      end
    end
  end

  it "should create the correct example name" do

    user = User.create( name: "John Doe" )
    user.set_name_example

    user.name.should eql( "Max Mustermann" )

  end





#  def reset_database
#    User.delete_all
#    Group.delete_all
#    DagLink.unscoped.delete_all
#  end

#  def create_basic_entries
#    @user = User.create( name: "John Doe" )
#    @parent_group = Group.create( name: "Parent Group" )
#    @sub_group = Group.create( name: "Sub Group of the Parent Group" )
#    @other_group = Group.create( name: "Yet Another Group" )
#  end
#
#  before( :each ) do
#    reset_database
#    create_basic_entries
#  end
#
#  it "should work to create the basic database entries" do
#  end
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
