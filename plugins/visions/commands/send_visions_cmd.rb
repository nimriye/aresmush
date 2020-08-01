module AresMUSH
  module Visions
    class SendVisionsCmd
      include CommandHandler
      
      # Command format: visions/send <name>=<vision name>/<vision desc>

      attr_accessor :target_name, :vision_name, :description

      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.target_name = titlecase_arg(args.arg1)
          self.vision_name = args.arg2
          self.description = args.arg3
        end
      end

      def required_args
        [self.target_name, self.vision_name, self.description]
      end

      def check_can_set
         return nil if enactor.is_admin?
         return "You cannot send visions."
      end    

      def handle
        # Get current date
        date = Time.now.strftime("%Y-%m-%d")

        divider = "+==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+"

        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          v = Vision.create(name: self.vision_name, date: date, desc: self.description, character: model)
          client.emit_success "Vision ##{v.id} (#{self.vision_name}) sent to #{model.name}."
          Login.emit_if_logged_in(model, "%xg%% You received a vision: #{self.vision_name}!%xn%R#{divider}%R#{self.description}%R#{divider}")
          Login.notify(model, :visions, "New vision ##{v.id}: #{self.vision_name}!", v.id)
        end
      end

    end
  end
end