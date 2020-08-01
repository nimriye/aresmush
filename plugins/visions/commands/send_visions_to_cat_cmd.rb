module AresMUSH
  module Visions
    class SendVisionsToCatCmd
      include CommandHandler
      
      # Command format: visions/sendcat <category>=<vision name>/<vision desc>

      attr_accessor :target_category, :vision_name, :description

      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.target_category = downcase_arg(args.arg1)
          self.vision_name = args.arg2
          self.description = args.arg3
        end
      end

      def required_args
        [self.target_category, self.vision_name, self.description]
      end

      def check_can_set
         return nil if enactor.is_admin?
         return "You cannot send visions."
      end    

      def handle
        # Get current date
        date = Time.now.strftime("%Y-%m-%d")

        divider = "+==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+"

        chars = Character.all.select { |c| c.vision_cat&.include? "#{self.target_category}" }
        chars.each do |char|
          if (!char.is_npc? && !char.is_admin? && char.is_approved?)
            v = Vision.create(name: self.vision_name, date: date, desc: self.description, character: char)
            client.emit_success "Vision ##{v.id} (#{self.vision_name}) sent to #{char.name}."
            Login.emit_if_logged_in(char, "%xg%% You received a vision: #{self.vision_name}!%xn%R#{divider}%R#{self.description}%R#{divider}")
            Login.notify(char, :visions, "New vision ##{v.id}: #{self.vision_name}!", v.id)
          else
            next
          end
        end

        #chars = Character.all.select { |c| c.vision_cat =~ /^#{self.target_category}$/i && !c.is_npc? && !c.is_admin? && c.is_approved? }
        #chars.each do |char|
        #  v = Vision.create(name: self.vision_name, date: date, desc: self.description, character: char)
        #  client.emit_success "Vision ##{v.id} (#{self.vision_name}) sent to #{char.name}."
        #  Login.emit_if_logged_in(char, "%xg%% You received a vision: #{self.vision_name}!%xn%R#{divider}%R#{self.description}%R#{divider}")
        #  Login.notify(char, :visions, "New vision: #{self.vision_name}! Check your visions.", v.id)
        #end
          client.emit_success "Vision #{self.vision_name} sent to Category #{self.target_category} (done)."
      end

    end
  end
end