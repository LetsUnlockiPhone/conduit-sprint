require 'spec_helper'

describe ValidatePort do
  let(:validate_port) { ValidatePort.new(credentials.merge(mdn: '5555555555')) }

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
      ValidatePort.new(credentials.merge(mdn: '5555555555', mock_status: :error))
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
        :old_service_provider                   => "Neutral Tandem",
        :status                                 => "2"
      }
    end

    subject                 { validate_port.perform }
    it                      { should be_an_instance_of ValidatePort::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eql serializable_hash }
  end
end
