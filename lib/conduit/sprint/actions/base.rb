require 'savon'
require 'signer'

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

      def xsd(xsd = nil)
        @xsd = xsd unless xsd.nil?
        @xsd
      end
    end

    def credentials
      credential_keys = Conduit::Driver::Sprint.credentials
      @options.select { |key| credential_keys.include?(key) }
    end

    def view_context
      super.tap do |view_context|
        view_context.xsd = self.class.xsd
      end
    end

    def perform
      if mock_mode?
        mocker = request_mocker.new(self, @options)
        mocker.with_mocking { perform_request }
      else
        perform_request
      end
    end

    def perform_request
      client    = Savon.client(wsdl: wsdl, raise_errors: false)
      response  = client.call(self.class.operation, xml: signed_soap_xml)
      parser.new(response.xml)
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

    def action_name
      ActiveSupport::Inflector.demodulize(self.class)
    end

    def parser
      "Conduit::Driver::Sprint::#{action_name}::Parser".constantize
    end

    def request_mocker
      "Conduit::Sprint::RequestMocker::#{action_name}".constantize
    end

    def mock_mode?
      @options[:mode] == :mock
    end
  end
end
