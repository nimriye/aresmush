module AresMUSH
  module Visions
    class UpdateVisionsCmd
      include CommandHandler
      
      # Command format: visions/update <name>=<vision id>/<vision desc>

      attr_accessor :target_name, :vision_id, :description

      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.target_name = titlecase_arg(args.arg1)
          self.vision_id = args.arg2
          self.description = args.arg3
        end
      end

      def required_args
        [self.target_name, self.vision_id, self.description]
      end

      def check_can_set
         return nil if enactor.is_admin?
         return "You cannot update visions."
      end    

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          #  Call find_attribute in helper.rb to find if there is such a vision on char.
          attr = Visions.find_vision(model, self.vision_id)
                   
          # If so, then update the vision. 
          if (attr)
            attr.update(desc: self.description)
            client.emit_success "Vision #{attr.id}, #{attr.name}, was updated."
            Login.emit_if_logged_in(model, "%xg%% Vision ##{attr.id} (#{attr.name}) was updated.%xn")
            Login.notify(model, :visions, "Updated Vision ##{attr.id} (#{attr.name}). Check your visions.", attr.id)
          else
            client.emit_failure "Vision ##{self.vision_id} not found."
          end
         
        end
      end

    end
  end
end