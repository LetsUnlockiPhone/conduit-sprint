require 'spec_helper'

describe ValidatePort do
  let(:creds) do
    credentials.merge!(mdn: '5555555555')
  end

  let(:validate_port) { ValidatePort.new(creds) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/validate_port/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/validate_port/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { validate_port.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { validate_port.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      ValidatePort.new(creds.merge!(mock_status: :error))
    end
  end

  context 'a successful validate port response is returned' do
    let(:serializable_hash) do
      {
        :csa                                    => "DALIRV214",
        :desired_due_date                       => "2014-12-19T07:30:01",
        :mdn                                    => "5555555555",
        :message                                => "PTN is eligible for Porting In",
        :number_portability_direction_indicator => "C",
        :number_portability_direction_indicator_description => "Wireline to Wireless",
        :old_service_provider                   => "Neutral Tandem",
        :port_id                                => "9999",
        :port_in_status                         => "test",
        :port_in_status_text                    => "test",
        :status                                 => "2"
      }
    end

    subject                 { validate_port.perform }
    it                      { should be_an_instance_of ValidatePort::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eql serializable_hash }
  end

  context 'a failed validate port response is returned' do
    before do
      creds.merge!(mock_status: :failure)
    end

    let(:response_errors) do
      [
        { code: "210820012", message: "http://144.230.220.92:10002/services/WholesaleWnpService/v1: cvc-simple-type 1: element mdn value '11111111' is not a valid instance of type MobileDirectoryNumberString" },
        { code: "Client.705", message: "Input validation error" }
      ]
    end

    subject                 { validate_port.perform }
    it                      { should be_an_instance_of ValidatePort::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end
end
