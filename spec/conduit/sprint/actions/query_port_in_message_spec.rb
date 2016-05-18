require 'spec_helper'
require 'pry'
describe QueryPortInMessage do
  let(:query_port_in_message) { QueryPortInMessage.new credentials }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/query_port_in_message/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/query_port_in_message/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { query_port_in_message.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { query_port_in_message.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      QueryPortInMessage.new(credentials.merge(mock_status: :error))
    end
  end

  context 'a successful query_port_in_message response is returned' do
    let(:serializable_hash) do
      {
      :messages =>
        [
          {
            :access_number => "9999999999",
            :port_due_date  => "2016-05-17",
            :port_status   => "PINP"
          }
        ]
      }
    end

    subject                 { query_port_in_message.perform }
    it                      { should be_an_instance_of QueryPortInMessage::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end

  context 'a failed query_port_in_message response is returned' do
    let(:query_port_in_message) { QueryPortInMessage.new credentials.merge!(mock_status: :failure) }
    let(:response_errors) do
      [
        Conduit::Error.new(code: "978000160",
          message: "No data found.")
      ]
    end

    subject                 { query_port_in_message.perform }
    it                      { should be_an_instance_of QueryPortInMessage::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end
end
