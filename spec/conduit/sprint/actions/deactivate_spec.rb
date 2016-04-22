require 'spec_helper'

describe Deactivate do
  let(:creds)      { credentials.merge(mdn: '5555555555') }
  let(:deactivate) { Deactivate.new creds }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/deactivate/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/deactivate/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { deactivate.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { deactivate.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      Deactivate.new(credentials.merge(mdn: '5555555555', mock_status: :error))
    end
  end

  context 'a successful deactivate response is returned' do
    subject                 { deactivate.perform }
    it                      { should be_an_instance_of Deactivate::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should be_empty }
  end

  context 'a failed deactivate response is returned' do
    before do
      creds.merge!(mock_status: :failure)
    end

    let(:response_errors) do
      [
        Conduit::Error.new(code: "210820012",
          message: "The subscriber does not belong to the 2222333344 Major Account/MVNO")
      ]
    end

    subject                 { deactivate.perform }
    it                      { should be_an_instance_of Deactivate::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end
end
