$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Visions

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "visions"
        case cmd.switch
        when "send"
          return SendVisionsCmd
        when "rm"
          return RmVisionsCmd
        when "view"
          return ViewVisionsCmd
        when "update"
          return UpdateVisionsCmd
        when "addcat"
          return AddCategoryCmd
        when "rmcat"
          return RmCategoryCmd
        when "sendcat"
          return SendVisionsToCatCmd
        else
          return VisionsCmd
        end
      end
      nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      # Web request is handled in the Profile plugin, since Visions appear on char profiles.
      nil
    end

  end
end
