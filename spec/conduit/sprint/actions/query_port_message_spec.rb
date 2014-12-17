require 'spec_helper'

describe QueryPortMessage do
  let(:query_port) { QueryPortMessage.new(credentials.merge(mdn: '5555555555')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/query_port_message/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/query_port_message/signed_soap.xml')
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
      QueryPortMessage.new(credentials.merge(mdn: '5555555555', mock_status: :error))
    end
  end

  context 'a successful port query response is returned' do
    let(:serializable_hash) do
      {
      :messages =>
        [
          {
            :message_type_code        => "PTS",
            :message_type_description => "Port Status",
            :message_code             => nil,
            :action_code              => "ACT",
            :response_type            => nil,
            :delay_code               => nil,
            :reason_code              => nil,
            :reason_text              => nil
          },
          {
            :message_type_code        => "DDT",
            :message_type_description => "Due Date and Time",
            :message_code             => "SOA1010I",
            :action_code              => nil,
            :response_type            => nil,
            :delay_code               => nil,
            :reason_code              => nil,
            :reason_text              => nil
          },
          {
            :message_type_code        => "PIR",
            :message_type_description => "PortIn Response",
            :message_code             => nil,
            :action_code              => nil,
            :response_type            => "C",
            :delay_code               => nil,
            :reason_code              => nil,
            :reason_text              => nil
          }
        ]
      }
    end

    subject                 { query_port.perform }
    it                      { should be_an_instance_of QueryPortMessage::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end
end
