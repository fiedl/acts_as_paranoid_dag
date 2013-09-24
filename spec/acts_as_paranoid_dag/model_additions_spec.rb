
require 'spec_helper'

describe ActsAsParanoidDag do

  def reset_database
    User.delete_all
    Group.delete_all
    DagLink.delete_all!
  end

  def create_basic_entries
    @user = User.create( name: "John Doe" )
    @group = Group.create( name: "Some Group" )
    @sub_group = Group.create( name: "Sub Group" )
    @other_group = Group.create( name: "Yet Another Group" )
  end

  before( :each ) do
    reset_database
    create_basic_entries
  end

  describe "standard ActsAsDag" do

    it "should allow to create the basic database entries" do
    end

    it "should allow to connect the groups" do
      @group.child_groups << @sub_group
      @group.children.include?( @sub_group ).should be_true
    end

    it "should allow to connect a user to a group" do
      @sub_group.child_users << @user
      @sub_group.children.include?( @user ).should be_true
    end

    it "should implicitly connect also the parent group to the user" do
      @group.child_groups << @sub_group
      @sub_group.child_users << @user
      @group.descendants.include?( @user ).should be_true
    end

    it "should allow to delete a connection" do
      @sub_group.child_users << @user
      @sub_group.children.include?( @user ).should be_true
      link = @user.links_as_child.first
      link.destroyable?.should be_true
      link.destroy
      @user.links_as_child.count.should eq( 0 )
    end

  end

  describe ActsAsParanoidDag::ModelAdditions do

    describe "for DagLink" do

      it "should allow to retrieve deleted connections" do
        @sub_group.child_users << @user
        link = @user.links_as_child.first
        link.destroy

        # This asks for the number of undeleted links.
        @user.links_as_child.count.should eq( 0 )

        # This asks for the number of all, even the deleted, links.
        @user.links_as_child.with_deleted.count.should eq( 1 )
      end

      it "should still allow to create a new link after deleting another" do
        # This is to make sure that the deleting process does not compromise the
        # link database.

        @sub_group.child_users << @user
        link = @user.links_as_child.first
        link.destroy

        @group.child_groups << @sub_group
        @group.children.include?( @sub_group ).should be_true
      end

      it "should still allow to recreate a link after deleting it" do
        @sub_group.child_users << @user
        link = @user.links_as_child.first
        link.destroy

        @sub_group.child_users << @user
        @sub_group.children.include?( @user ).should be_true
      end

      it "should allow to delete and recreate a link twice" do
        @sub_group.child_users << @user
        2.times do
          link = @user.links_as_child.first
          link.destroy
          @sub_group.child_users << @user
        end

        @sub_group.children.include?( @user ).should be_true
      end

    end

    describe "#destroy" do
      before do
        @user.parent_groups << @group
        @link = @user.links_as_child.first
      end
      subject { @link.destroy }
      it "should mark the link as deleted rather than really destroying it" do
        @link.deleted_at.should == nil
        subject
        @link.deleted_at.should_not == nil
        @user.links_as_child.count.should == 0
        @user.links_as_child.now_and_in_the_past.count.should == 1
        @user.parents.count.should == 0
      end
    end

    describe "#destroy!" do #really delete!
      before do
        @user.parent_groups << @group
        @link = @user.links_as_child.first
      end
      subject { @link.destroy! }
      
      describe "for existing links" do
        it "should really remove the dag link" do
          @link.deleted_at.should == nil
          subject
          @user.links_as_child.count.should == 0
          @user.links_as_child.now_and_in_the_past.count.should == 0
          @user.parents.count.should == 0
          DagLink.all.count.should == 0
          DagLink.with_deleted.all.count.should == 0
        end
      end
      describe "for already destroyed links" do
        before { @link.destroy }
        it "should really remove the dag link" do
          @link.deleted_at.should_not == nil
          subject
          @user.links_as_child.count.should == 0
          @user.links_as_child.now_and_in_the_past.count.should == 0
          @user.parents.count.should == 0
          DagLink.all.count.should == 0
          DagLink.with_deleted.all.count.should == 0
        end
      end
    end
    
    describe "#destroy_permanently" do
      before do
        @user.parent_groups << @group
        @link = @user.links_as_child.first
      end
      subject { @link.destroy_permanently }
      
      describe "for existing links" do
        it "should really remove the dag link" do
          @link.deleted_at.should == nil
          subject
          @user.links_as_child.count.should == 0
          @user.links_as_child.now_and_in_the_past.count.should == 0
          @user.parents.count.should == 0
          DagLink.all.count.should == 0
          DagLink.with_deleted.all.count.should == 0
        end
      end
      describe "for already destroyed links" do
        before { @link.destroy }
        it "should really remove the dag link" do
          @link.deleted_at.should_not == nil
          subject
          @user.links_as_child.count.should == 0
          @user.links_as_child.now_and_in_the_past.count.should == 0
          @user.parents.count.should == 0
          DagLink.all.count.should == 0
          DagLink.with_deleted.all.count.should == 0
        end
      end      
    end

  end


  describe "additional access methods" do

    def create_links_for_one_user_and_two_groups_and_destroy_one
      @group.child_users << @user
      @user.links_as_child.first.destroy
      @other_group.child_users << @user
    end

    describe "for DagLinks" do

      it "should provide a method to access past and present links" do
        create_links_for_one_user_and_two_groups_and_destroy_one

        @user.links_as_child.now.count.should == 1
        @user.links_as_child.now_and_in_the_past.count.should == 2
      end

      it "should provide a method to access present links" do
        create_links_for_one_user_and_two_groups_and_destroy_one

        @user.links_as_child.now.count.should == 1
        @user.links_as_child.now.first.ancestor.should == @other_group
      end

      it "should provide a method to access past links" do
        create_links_for_one_user_and_two_groups_and_destroy_one

        @user.links_as_child.in_the_past.count.should == 1
        @user.links_as_child.in_the_past.first.ancestor.should == @group
      end

      it "should have present links as default scope" do
        create_links_for_one_user_and_two_groups_and_destroy_one

        @user.links_as_child.should == @user.links_as_child.now
      end

      it "should provide a method to select links at a certain time" do
        @group.child_users << @user
        sleep 1.5
        @user.links_as_child.now.count.should == 1
        @user.links_as_child.at_time( 30.minutes.ago ).count.should == 0
        @user.links_as_child.at_time( Time.current + 30.minutes ).count.should == 1
        @user.links_as_child.first.destroy
        @user.links_as_child.at_time( Time.current + 30.minutes ).count.should == 0
      end

    end

#    describe "for the Model that has the dag links" do
#      
#      it "should have methods to access relatives now, and in the past" do
#        create_links_for_one_user_and_two_groups_and_destroy_one
#
#        @user.parents.now.count.should == 1
#        @user.parents.in_the_past.count.should == 1
#        @user.parents.now_and_in_the_past.cound.should == 2
#      end
#
#    end

  end

end
