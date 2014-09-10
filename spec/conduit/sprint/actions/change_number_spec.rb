require 'spec_helper'

describe ChangeNumber do
  let(:change_number) { ChangeNumber.new(credentials.merge(mdn: '5555555555')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/change_number/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/change_number/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { change_number.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { change_number.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      ChangeNumber.new \
        credentials.merge(credentials.merge(mdn: '5555555555', mock_status: :error))
    end
  end

  context 'a successful change number response is returned' do
    subject                 { change_number.perform }
    it                      { should be_an_instance_of ChangeNumber::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should_not eq be_empty }
  end
end
