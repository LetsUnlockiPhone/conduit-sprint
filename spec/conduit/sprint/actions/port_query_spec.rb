require 'spec_helper'

describe PortQuery do
  let(:port_query) { PortQuery.new(credentials.merge(mdn: '5555555555')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/port_query/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/port_query/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { port_query.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { port_query.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      PortQuery.new(credentials.merge(mdn: '5555555555', mock_status: :error))
    end
  end

  context 'a successful port query response is returned' do
    let(:serializable_hash) do 
      {
        :message_type_code          => "PTS",
        :message_type_description   => "Port Status",
        :message_code               => "SOA1010I",
        :action_code                => "ACT",
        :response_type              => "C",
        :delay_code                 => nil,
        :reason_code                => nil,
        :reason_text                => nil
      }
    end    

    subject                 { port_query.perform }
    it                      { should be_an_instance_of PortQuery::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end
end
