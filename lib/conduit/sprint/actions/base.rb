require 'savon'
require 'signer'

module Conduit::Driver::Sprint
  class Base < Conduit::Core::Action
    class << self
      def inherited(base)
        base.send :required_attributes, *Conduit::Driver::Sprint.credentials
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

    attr_accessor :test_environment

    def initialize(options = {})
      super
      self.test_environment = @options[:test_environment]
      validate_test_environment! unless test_environment.blank?
    end

    def credentials
      credential_keys = Conduit::Driver::Sprint.credentials
      @options.select { |key| credential_keys.include?(key) }
    end

    def view_context
      view_decorator.new(
        OpenStruct.new(attributes_with_values)
      )
    end

    def attributes_with_values
      attributes.inject({}) do |hash, attribute|
        hash.tap do |h|
          h[attribute] = @options[attribute]
        end
      end.tap do |h|
        h[:xsd] = self.class.xsd
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
      client    = Savon.client(wsdl: wsdl, raise_errors: false, ssl_version: :TLSv1)
      response  = client.call(self.class.operation, xml: signed_soap_xml)
      parser.new(response.xml)
    end

    def soap_xml
      @soap_xml ||= view
    end

    def signed_soap_xml
      @signed_soap_xml ||= signer.sign!(security_token: true).to_xml
    end

    def wsdl
      if test_environment
        wsdl_service = self.class.wsdl_service.gsub('QueryCsaService', 'WholesaleQueryCsaService')
        "https://#{gateway}/#{wsdl_service}?wsdl"
      else
        File.expand_path("fixtures/wsdl/#{self.class.wsdl_service}.wsdl", File.dirname(__FILE__))
      end
    end

    private

    def gateway
      test_environment ? test_gateway : production_gateway
    end

    def test_gateway
      "webservicesgatewaytest.sprint.com:444/services/mvno/#{test_environment}"
    end

    def production_gateway
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

    def view_decorator
      "Conduit::Sprint::Decorators::#{action_name}Decorator".constantize
    end

    def mock_mode?
      @options.has_key?(:mock_status) && (!@options[:mock_status].nil? && !@options[:mock_status].empty?)
    end

    def validate_test_environment!
      unless ['rtb1', 'rtb2'].include?(test_environment)
        raise ArgumentError,
          "Unrecognized test environment. Please specify one of the following: ['rtb1', 'rtb2']"
      end
    end
  end
end
