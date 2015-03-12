require 'spec_helper'

describe Restore do
  let(:creds)   { credentials.merge(mdn: '5555555555') }
  let(:restore) { Restore.new creds }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/restore/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/restore/signed_soap.xml')
  end

  describe 'soap_xml' do    
    subject { restore.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { restore.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      Restore.new(credentials.merge(mdn: '5555555555', mock_status: :error))
    end
  end

  context 'a successful restore response is returned' do
    subject                 { restore.perform }
    it                      { should be_an_instance_of Restore::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should be_empty }
  end

  context 'a failed restore response is returned' do
    before do
      creds.merge!(mock_status: :failure)
    end

    let(:response_errors) do
      [
        {:code=>"210820012", :message=>"The subscriber does not belong to the 2222333344 Major Account/MVNO"},
        {:code=>"Server.704", :message=>"Application processing error"}
      ]
    end
    
    subject                 { restore.perform }
    it                      { should be_an_instance_of Restore::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end   
end