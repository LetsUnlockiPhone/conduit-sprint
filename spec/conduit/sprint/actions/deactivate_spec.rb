require 'spec_helper'

describe Deactivate do
  let(:deactivate) do
    Deactivate.new(credentials.merge(mdn: '5555555555'))
  end

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
end