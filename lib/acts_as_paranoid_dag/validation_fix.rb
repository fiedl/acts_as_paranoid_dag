
# This is a fix for the interaction of the gem `rails3_acts_as_dag` and the ActiveRecord
# presence validation. 
# The gem recommends to use the method `validates_uniqueness_of_without_deleted`,
# but since do not have access to the `acts-as-dag` validation declaration,
# this is not an option here.
# This, this fix adds a corresponding scope to the standard validation method.
module ActsAsParanoidValidationFix
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

ActiveRecord::Base.extend ActsAsParanoidValidationFix::ActiveRecordAdditions

