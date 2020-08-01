module AresMUSH
  module Visions
    class ViewVisionsCmd
      include CommandHandler
      
      # Admin command format: visions/view Andromeda=<vision id>
      # Self command format: visions/view <vision id>

      attr_accessor :target_name, :vision_id

      def parse_args
        # If argument contains an '=' sign, do the admin version
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target_name = titlecase_arg(args.arg1)
          self.vision_id = args.arg2
        else
          self.target_name = enactor_name
          self.vision_id = trim_arg(cmd.args)
        end
      end

      def required_args
        [self.target_name, self.vision_id]
      end
      
      def check_can_view
         return nil if self.target_name == enactor_name
         return nil if enactor.is_admin?
         return "You're not allowed to view other peoples' visions."
      end    

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          #  Call find_attribute in helper.rb to find if there is such a vision on char.
          attr = Visions.find_vision(model, self.vision_id)
          
          if (attr)
            template = BorderedDisplayTemplate.new attr.desc, "#{attr.date} - #{attr.name}"
            client.emit template.render
            if (self.target_name == enactor_name)
              Login.mark_notices_read(enactor, :visions, attr.id)
            end
          else
            client.emit_failure "Vision num #{self.vision_id} was not found."
          end
        end
      end

    end
  end
end