module AresMUSH
  module Visions
    class RmVisionsCmd
      include CommandHandler
      
      # Command format: visions/rm <name>=<vision id>

      attr_accessor :target_name, :vision_id

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.vision_id = args.arg2
      end

      def required_args
        [self.target_name, self.vision_id]
      end

      def check_can_set
         return nil if enactor.is_admin?
         return "%xr%% You cannot remove visions.%xn"
      end    

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          #  Call find_attribute in helper.rb to find if there is such a vision on char.
          attr = Visions.find_vision(model, self.vision_id)
          
          if (attr)
            attr.delete
            client.emit_success "#{self.target_name}'s Vision #{self.vision_id} removed."
            # Login.emit_if_logged_in(model, "%xg%% Vision: #{self.vision_id} was removed.%xn")
            # Login.notify(model, :visions, "Removed vision: #{self.vision_id}. Check your visions.", nil)
          else 
            client.emit_failure "#{self.target_name}'s Vision #{self.vision_id} not found."
          end
        end
      end

    end
  end
end
