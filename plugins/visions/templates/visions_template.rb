module AresMUSH
  module Visions
    class VisionsTemplate < ErbTemplateRenderer
      
      attr_accessor :char, :paginator
      
      def initialize(char, paginator)
        @char = char
        @paginator = paginator
        super File.dirname(__FILE__) + "/visions.erb"
      end
 
    end
  end
end