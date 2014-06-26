require 'savon'
require 'signer'
require 'conduit/sprint/parsers/provider_errors'

module Conduit::Driver::Sprint
  class Base < Conduit::Core::Action
    class << self
      def inherited(base)
        base.send :required_attributes, *Conduit::Driver::Sprint.credentials
        base.send :optional_attributes, :gateway
      end

      def wsdl_service(wsdl_service = nil)
        @wsdl_service = wsdl_service unless wsdl_service.nil?
        @wsdl_service
      end

      def operation(operation = nil)
        @operation = operation unless operation.nil?
        @operation
      end
    end

    def perform
      client    = Savon.client(wsdl: wsdl)
      response  = client.call(self.class.operation, xml: signed_soap_xml)
      parse_response(response)
    rescue Savon::SOAPFault => soap_fault
      ProviderErrorParser.parse(soap_fault)
    end

    def soap_xml
      @soap_xml ||= view
    end

    def signed_soap_xml
      @signed_soap_xml ||= signer.sign!(security_token: true).to_xml
    end

    def gateway
      @options[:gateway] || default_gateway
    end

    def wsdl
      "https://#{gateway}/#{self.class.wsdl_service}?wsdl"
    end

    private

    def default_gateway
      'webservicesgateway.sprint.com:444/services/mvno'
    end

    def signer
      Signer.new(soap_xml).tap do |signer|
        signer.cert = OpenSSL::X509::Certificate.new(@options[:cert])
        signer.private_key = OpenSSL::PKey::RSA.new(@options[:key])
      end
    end

    def parse_response(response)
      operation_response_node = "#{self.class.operation}_response".to_sym
      response.hash[:envelope][:body][operation_response_node]
    end
  end
end
