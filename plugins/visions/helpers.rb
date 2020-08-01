module AresMUSH
  module Visions

    def self.find_vision(model, vision_id)
      # name_downcase = vision_name.downcase
      # Using the 'visions' collection from visions_model.rb
      model.visions.select { |a| a.id == vision_id }.first
    end
  end

end