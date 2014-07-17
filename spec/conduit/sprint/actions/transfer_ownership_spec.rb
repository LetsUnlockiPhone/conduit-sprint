require 'spec_helper'

describe TransferOwnership do
  let(:transfer_ownership) do
    TransferOwnership.new credentials.merge(nid: '12345678901')
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/transfer_ownership/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/transfer_ownership/signed_soap.xml')
  end

  let(:failure_response) do
    File.read('./spec/fixtures/responses/transfer_ownership/soap_fault.xml')
  end

  let(:successful_response) do
    File.read('./spec/fixtures/responses/transfer_ownership/success.xml')
  end

  describe 'soap_xml' do
    subject { transfer_ownership.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { transfer_ownership.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'a successful transfer_ownership response is returned' do
    let(:serializable_hash) do
      {
        phone_ownership_code: 'PLBL',
        manufacturer_name: 'SAMSUNG',
        model_name: 'SAMSUNG M330 1X SLIDER',
        model_number: 'SPHM330ZWS'
      }
    end

    before(:example) do
      savon.expects(:manage_device_phone_ownership).
        with(signed_soap: signed_soap).returns(successful_response)
    end

    subject                 { transfer_ownership.perform }
    it                      { should be_an_instance_of TransferOwnership::Parser }
    its(:xml)               { should eq successful_response }
    its(:response_status)   { should eq 'success'}
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end

  context 'a failed transfer_ownership response is returned' do
    let(:response_errors) do
      [
        { code: '10',         message: 'INVALID_ESN_MEID: esnDec is mandatory' },
        { code: 'Server.704', message: 'Application processing error' }
      ]
    end

    before(:example) do
      savon.expects(:manage_device_phone_ownership).
        with(signed_soap: signed_soap).returns(failure_response)
    end

    subject                 { transfer_ownership.perform }
    it                      { should be_an_instance_of TransferOwnership::Parser }
    its(:xml)               { should eq failure_response }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end
end