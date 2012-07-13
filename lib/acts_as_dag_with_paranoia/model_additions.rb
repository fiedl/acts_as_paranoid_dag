
require 'paranoia'

# This is a temporary fix for the paranoia gem: Currently, the gem conflicts with
# presence validations of ActiveRecord. This fix is a temporary solution, until the
# issue is fixed in the paranoia gem. 
module ParanoiaFix
  module ActiveRecordAdditions

    def validates( *attributes )

      # The extension is only needed, if the instance has a :deleted_at attribute.
      if self.new.respond_to?( :deleted_at )
        if ( attributes[ 1 ] )
          if ( attributes[ 1 ][ :uniqueness ] )
            if ( attributes[ 1 ][ :uniqueness ][ :scope ] )
              attributes[ 1 ][ :uniqueness ][ :scope ] += [ :deleted_at ]
            end
          end
        end
      end
      super *attributes

    end

  end
end

ActiveRecord::Base.extend ParanoiaFix::ActiveRecordAdditions

module ActsAsDagWithParanoia
  module ModelAdditions

    # This allows you to make your dag paranoid, meaning that connections are not destroyed, 
    # but instead a 'deleted_at' attribute is set.
    # In your DagLink model replace
    # ```
    # class DagLink < ActiveRecord::Base
    #   acts_as_dag_links options
    # end
    #```
    # by
    # ```
    # class DagLink < ActiveRecord::Base
    #   acts_as_dag_links options, paranoia: true
    # end
    #```
    def acts_as_dag_links( params )

      # Find out whether the dag link should have the paranoia extension.
      paranoia = params[ :paranoia ]
      params.delete( :paranoia )

      # Call the original acts_as_dag_links method from the acts-as-dag gem.
      super params

      # If the dag links should have paranoia, load the corresponding extensions.
      if paranoia
        acts_as_paranoid
        include DagLinkInstanceMethods

        scope :now, where( "#{table_name}.deleted_at IS NULL" )

        def scoped_without_deleted_at
          where_values_hash = self.scoped.where_values_hash
          where_values_hash.delete( :deleted_at )
          unscoped.where( where_values_hash ) # unscoped() removes the default_scope.
        end

        def now_and_in_the_past  # FAILS
          #scoped_without_deleted_at
          where_values_hash = self.scoped.where_values_hash
          where_values_hash.delete( :deleted_at )
          unscoped do # unscoped() removes the default_scope.
            where( where_values_hash ) 
          end
        end

        def in_the_past # FAILS
          scoped_without_deleted_at.where( "#{table_name}.deleted_at < ?", Time.now )
        end

        # THE FAILING scopes somehow continuously include the default_scope on evaluation.
        # Maybe, try redefining the default_scope in the now_and_in_the_past method(), temporarily.

      end
      
    end

    module DagLinkInstanceMethods
      # here the new instance methods for the DagLink model.
    end
  end
end

ActiveRecord::Base.extend ActsAsDagWithParanoia::ModelAdditions
