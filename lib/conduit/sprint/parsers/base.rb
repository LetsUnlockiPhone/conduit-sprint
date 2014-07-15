require 'nokogiri'

module Conduit::Driver::Sprint
  module Parser
    class Base < Conduit::Core::Parser
      attr_accessor :xml

      def initialize(xml)
        self.xml = xml
      end

      def root
        @root ||= Nokogiri::XML(xml).tap do |doc|
          doc.remove_namespaces!
        end
      end

      def content_for(path, doc = root)
        node = doc.at_xpath(path)
        node.content if node
      end

      def response_status
        response_errors.any? ? 'failure' : 'success'
      end

      def response_errors
        if fault.nil?
          []
        elsif provider_errors.any?
          normalized_provider_errors
        else
          [normalized_fault]
        end
      end

      def fault
        @fault ||= root.at_xpath('//Fault')
      end

      def provider_errors
        @provider_errors ||= fault.xpath('//providerError') if fault
      end

      def normalized_provider_errors
        provider_errors.map do |provider_error|
          {}.tap do |error|
            error[:code]    = content_for('providerErrorCode', provider_error)
            error[:message] = content_for('providerErrorText', provider_error)
          end
        end
      end

      def normalized_fault
        {}.tap do |error|
          error[:code]    = content_for('faultcode', fault)
          error[:message] = content_for('faultstring', fault)
        end
      end
    end
  end
end
