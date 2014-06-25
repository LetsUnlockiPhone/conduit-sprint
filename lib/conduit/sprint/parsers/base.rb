require 'nokogiri'

module Conduit::Driver::Sprint
  module Parser
    class Base < Conduit::Core::Parser
      attr_accessor :xml

      def initialize(xml)
        self.xml = xml
      end

      def doc
        @doc ||= Nokogiri::XML(xml)
      end
    end
  end
end
