require 'spec_helper'

describe Activate do
  let(:activate) do
    Activate.new \
      credentials.merge(nid: '12345678901', plan_code: 'TESTPLAN', csa: 'MIAWPB561', 
                        service_codes: ['TESTNVM', 'TESTPMVM', 'TESTINTCL'])
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/activate/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/activate/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { activate.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { activate.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      Activate.new \
        credentials.merge(nid: '12345678901', plan_code: 'TESTPLAN', csa: '33415', mock_status: :error)
    end
  end

  context 'a successful activate response is returned' do
    subject                 { activate.perform }
    it                      { should be_an_instance_of Activate::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should_not eq be_empty }
  end

  context 'an activate with just zip should fetch a csa' do
    let(:unsigned_new_csa_soap) do
      File.read('./spec/fixtures/requests/activate/unsigned_new_csa_soap.xml')
    end

    subject do
      Activate.new \
        credentials.merge(nid: '12345678901', plan_code: 'TESTPLAN', zip: '33415')
    end

    its(:soap_xml) { should eq unsigned_new_csa_soap }
  end

  context 'an activate with transfer ownership' do
    let(:transfer_ownership_attributes) do
      credentials.merge(nid: '12345678901')
    end

    let(:activate) do
      Activate.new \
        credentials.merge(nid: '12345678901', plan_code: 'TESTPLAN',
                          csa: 'MIAWPB561', claim_ownership: true)
    end

    it 'should request to transfer ownership' do
      response            = Struct.new(:response_status).new('success')
      transfer_ownership  = Struct.new(:perform).new(response)

      expect(TransferOwnership).to receive(:new).
        with(transfer_ownership_attributes).
        and_return(transfer_ownership)

      expect(transfer_ownership).to receive(:perform).
        and_return(response)

      activate.perform
    end

    it 'should raise exeception if transfer ownership fails' do
      response            = Struct.new(:response_status).new('failure')
      transfer_ownership  = Struct.new(:perform).new(response)

      expect(TransferOwnership).to receive(:new).
        with(transfer_ownership_attributes).
        and_return(transfer_ownership)

      expect(transfer_ownership).to receive(:perform).
        and_return(response)

      expect { activate.perform }.to raise_error
    end
  end
end
