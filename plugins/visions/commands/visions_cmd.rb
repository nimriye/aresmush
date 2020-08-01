module AresMUSH
  module Visions
    class VisionsCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end
      
      def check_can_view
         return nil if self.name == enactor_name
         return nil if enactor.is_admin?
         return "You're not allowed to view other peoples' visions."
      end    
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          visions = model.visions.to_a.sort_by { |v| v.date }.reverse
          paginator = Paginator.paginate(visions, cmd.page, 5)

          if (paginator.out_of_bounds?)
            client.emit_failure paginator.out_of_bounds_msg
          else
            template = VisionsTemplate.new(model, paginator)
            client.emit template.render
          end
        end

#        if (cmd.args)
#          nil
#        else
#          Login.mark_notices_read(enactor, :visions, nil)
#        end

      end
    end
  end
end