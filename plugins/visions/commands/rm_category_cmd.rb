module AresMUSH
  module Visions
    class RmCategoryCmd
      include CommandHandler
      
      # Command format: visions/rmcat <name>=<vision category>

      attr_accessor :target_name, :vision_category

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.vision_category = args.arg2
      end

      def required_args
        [self.target_name, self.vision_category]
      end

      def check_can_set
         return nil if enactor.is_admin?
         return "You cannot use this command."
      end    

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          if (model.vision_cat == nil)
            client.emit_failure "This person doesn't have any categories."
          else
            categories = model.vision_cat
            success = categories.delete("#{self.vision_category}")
            if (success == nil)
              client.emit_failure "Vision category #{self.vision_category} not found on #{self.target_name}."
            else 
              model.update(vision_cat: categories)
              client.emit_success "Vision category #{self.vision_category} removed from #{self.target_name}."
              client.emit_success "#{self.target_name}'s categories are now #{model.vision_cat}."
            end
          end 
        end
      end

    end
  end
end