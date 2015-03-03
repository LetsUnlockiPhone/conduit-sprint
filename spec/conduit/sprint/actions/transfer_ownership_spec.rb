require 'spec_helper'

describe TransferOwnership do
  let(:transfer_ownership_creds) { credentials.merge(nid: '12345678901')  }

  let(:transfer_ownership) do
    TransferOwnership.new transfer_ownership_creds
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/transfer_ownership/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/transfer_ownership/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { transfer_ownership.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { transfer_ownership.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      TransferOwnership.new(transfer_ownership_creds.merge(mock_status: :error))
    end
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

    subject                 { transfer_ownership.perform }
    it                      { should be_an_instance_of TransferOwnership::Parser }
    its(:response_status)   { should eq 'success'}
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end

  context 'a successful SPCS transfer_ownership response is returned' do
    let(:transfer_ownership_creds) { credentials.merge(nid: '12345678901', ownership_code: 'SPCS')  }

    let(:serializable_hash) do
      {
        phone_ownership_code: 'SPCS',
        manufacturer_name: 'SAMSUNG',
        model_name: 'SAMSUNG M330 1X SLIDER',
        model_number: 'SPHM330ZWS'
      }
    end

    subject                 { transfer_ownership.perform }
    it                      { should be_an_instance_of TransferOwnership::Parser }
    its(:response_status)   { should eq 'success'}
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end

  context 'a failed/fault transfer_ownership response is returned' do
    let(:transfer_ownership) do
      TransferOwnership.new transfer_ownership_creds.merge(mock_status: :failure)
    end

    let(:response_errors) do
      [
        { code: '10',         message: 'INVALID_ESN_MEID: esnDec is mandatory' },
        { code: 'Server.704', message: 'Application processing error' }
      ]
    end
    
    subject                 { transfer_ownership.perform }
    it                      { should be_an_instance_of TransferOwnership::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end

  context 'a transfer_ownership with incorrect ownership_code' do
    let(:transfer_ownership_creds) { credentials.merge(nid: '12345678901', ownership_code: '123')  }

    it 'should raise exeception if transfer ownership fails' do
      expect { transfer_ownership.perform }.to raise_error
    end
  end
end