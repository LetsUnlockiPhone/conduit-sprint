require 'spec_helper'

describe QueryPortStatus do
  let(:query_port) { QueryPortStatus.new(credentials.merge(mdn: '5555555555')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/query_port_status/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/query_port_status/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { query_port.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { query_port.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      QueryPortStatus.new(credentials.merge(mdn: '5555555555', mock_status: :error))
    end
  end

  context 'a successful port query response is returned' do
    let(:serializable_hash) do
      {
        :description  => nil,
        :message_code => nil,
        :port_id      => "44461996",
        :status       => "COMPlETED",
      }
    end

    subject                 { query_port.perform }
    it                      { should be_an_instance_of QueryPortStatus::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end
end
