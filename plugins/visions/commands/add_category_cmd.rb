module AresMUSH
  module Visions
    class AddCategoryCmd
      include CommandHandler
      
      # Command format: visions/addcat <name>=<vision category>

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
            categories = ["#{self.vision_category}"]
          else
            categories = model.vision_cat
            categories.push("#{self.vision_category}")
          end
          model.update(vision_cat: categories)
          client.emit_success "Vision category #{self.vision_category} added on #{self.target_name}."
          client.emit_success "#{self.target_name}'s categories are now #{model.vision_cat}."
        end
      end

    end
  end
end