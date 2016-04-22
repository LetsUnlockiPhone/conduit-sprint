require 'nokogiri'

module Conduit::Driver::Sprint
  module Parser
    class Base < Conduit::Core::Parser
      attr_accessor :xml

      def self.attribute(attr_name, &block)
        block ||= lambda do
          content_for "//#{ActiveSupport::Inflector.camelize(attr_name, false)}"
        end
        super(attr_name, &block)
      end

      def initialize(xml)
        self.xml = xml
      end

      def root
        @root ||= Nokogiri::XML(xml).tap do |doc|
          doc.remove_namespaces!
        end
      end

      def containing_node_content(path, content, doc = root)
        node = doc.at("#{path}:contains(\"#{content}\")")
        node.nil? ? nil : node.parent
      end

      def content_for(path, doc = root)
        node = doc.at_xpath(path)
        node.content if node
      end

      def in_progress?
        false
      end

      def response_status
        if response_errors.any?
          'failure'
        elsif in_progress?
          'acknowledged'
        else
          'success'
        end
      end

      def response_errors
        if response_content?
          if fault.nil?
            []
          elsif provider_errors.any?
            prune_generic_errors(normalized_provider_errors)
          else
            [normalized_fault]
          end
        else
          [Conduit::Error.new(message: 'Unexpected response from server.')]
        end
      end

      def response_content?
        root.at_xpath('//Body')
      end

      def body
        root.at_xpath('//Body').to_s
      end

      def fault
        @fault ||= root.at_xpath('//Fault')
      end

      def provider_errors
        @provider_errors ||= fault.xpath('//providerError') if fault
      end

      def normalized_provider_errors
        provider_errors.map do |provider_error|
          Conduit::Error.new(message: content_for('providerErrorText', provider_error),
            code: content_for('providerErrorCode', provider_error))
        end
      end

      def normalized_fault
        Conduit::Error.new(message: content_for('faultstring', fault),
          code: content_for('faultcode', fault))
      end

      def prune_generic_errors(errors)
        return errors if errors.length == 1
        errors.reject { |error| error.code == "Server.704" }
      end
    end
  end
end
