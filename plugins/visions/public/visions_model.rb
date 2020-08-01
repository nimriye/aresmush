module AresMUSH

  class Character < Ohm::Model
    collection :visions, "AresMUSH::Vision"
    attribute :vision_cat, :type => DataType::Array, :default => []
  end

  class Vision < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :date
    attribute :desc
    reference :character, "AresMUSH::Character"
    index :name
  end

end