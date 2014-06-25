require 'savon'
require 'signer'

module Conduit::Driver::Sprint
  class Base < Conduit::Core::Action
    def self.inherited(base)
      base.send :required_attributes, *Conduit::Driver::Sprint.credentials
    end

    # TODO:
    # 1. Integrate Savon Model.
    # 2. Write tests.
    #
    def perform
      client = Savon.client(wsdl: wsdl)
      puts signed_soap_xml
      client.call(:wholesale_query_subscription_v4, xml: signed_soap_xml)
    rescue Savon::SOAPFault => soap_fault
      ProviderErrorParser.parse(soap_fault)
    end

    def soap_xml
      @soap_xml ||= view
    end

    def signed_soap_xml
      @signed_soap_xml ||= signer.sign!(security_token: true).to_xml
    end

    private

    def signer
      Signer.new(soap_xml).tap do |signer|
        signer.cert = OpenSSL::X509::Certificate.new(@options[:cert])
        signer.private_key = OpenSSL::PKey::RSA.new(@options[:key])
      end
    end
  end
end
