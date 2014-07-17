require 'spec_helper'

describe Activate do
  let(:activate) do
    Activate.new \
      credentials.merge(nid: '12345678901', plan_code: 'TESTPLAN', csa: 'HOUHST281')
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/activate/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/activate/signed_soap.xml')
  end

  let(:soap_fault) do
    File.read('./spec/fixtures/responses/activate/soap_fault.xml')
  end

  let(:success) do
    File.read('./spec/fixtures/responses/activate/success.xml')
  end

  describe 'soap_xml' do
    subject { activate.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { activate.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'a successful activate response is returned' do
    let(:serializable_hash) do 
      {
        mdn: '5555555555',
        msid: '000001234567890',
        nai: '5555555555@MVNO123.SPRINTPCS.COM',
        csa: 'HOUHST281',
        esn_dec: '12345678901',
        msl: '123456'
      }
    end

    before(:example) do
      savon.expects(:wholesale_activate_subscription_v4).
        with(signed_soap: signed_soap).returns(success)
    end

    subject                 { activate.perform }
    it                      { should be_an_instance_of Activate::Parser }
    its(:xml)               { should eq success }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end
end
