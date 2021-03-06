
module ActsAsParanoidDag
  module ModelAdditions

    # This allows you to make your dag paranoid, meaning that connections are not destroyed, 
    # but instead a 'deleted_at' attribute is set.
    #
    # In your DagLink model replace
    # 
    #     class DagLink < ActiveRecord::Base
    #       acts_as_dag_links options
    #     end
    #
    # by
    #
    #     class DagLink < ActiveRecord::Base
    #       acts_as_dag_links options, paranoid: true
    #     end
    #
    def acts_as_dag_links( params )

      # Find out whether the dag link should have the paranoid extension.
      paranoid = params[ :paranoid ]
      params.delete( :paranoid )

      # Call the original acts_as_dag_links method from the acts-as-dag gem.
      super params

      # If the dag links should be paranoid, load the corresponding extensions.
      if paranoid
        acts_as_paranoid
        include DagLinkInstanceMethods

        scope :now, where( "#{table_name}.deleted_at IS NULL" )

        def now_and_in_the_past
          without_paranoid_default_scope
        end

        def in_the_past
          without_paranoid_default_scope.only_deleted
        end

        def at_time( time )
          links = without_paranoid_default_scope
            .where( "created_at <= ?", time )
          links = links.where( :deleted_at => nil ) + links.where( "deleted_at >= ?", time )
          links
        end

      end
      
    end

    module DagLinkInstanceMethods
      # here the new instance methods for the DagLink model.
      
      # This is just an alias for the +destroy!+ method.
      #
      def destroy_permanently
        self.destroy!  # This method is defined in the rails3_acts_as_paranoid gem.
      end
    end


#    def has_dag_links( params )
#      
#      paranoid = params[ :paranoid ]
#      params.delete( :paranoid )
#
#      dag_link_class_name = params[ :link_class_name ]
#      dag_link_table_name = dag_link_class_name.constantize.table_name
#
#      super params
#
#      if paranoid
#        
#        scope :now, where( "#{dag_link_table_name}.deleted_at IS NULL" )
#
#      end
#      
#    end

  end
end

ActiveRecord::Base.extend ActsAsParanoidDag::ModelAdditions
