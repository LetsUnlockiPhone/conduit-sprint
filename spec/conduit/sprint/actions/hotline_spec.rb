require 'spec_helper'

describe Hotline do
  let(:creds)   { credentials.merge(mdn: '5555555555') }
  let(:hotline) { Hotline.new creds }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/hotline/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/hotline/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { hotline.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { hotline.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      Hotline.new(credentials.merge(mdn: '5555555555', mock_status: :error))
    end
  end

  context 'a successful hotline response is returned' do
    subject                 { hotline.perform }
    it                      { should be_an_instance_of Hotline::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should be_empty }
  end

  context 'a failed hotline response is returned' do
    before do
      creds.merge!(mock_status: :failure)
    end

    let(:response_errors) do
      [
        Conduit::Error.new(:code=>"210820012", :message=>"The subscriber does not belong to the 2222333344 Major Account/MVNO"),
        Conduit::Error.new(:code=>"Server.704", :message=>"Application processing error")
      ]
    end

    subject                 { hotline.perform }
    it                      { should be_an_instance_of Hotline::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end
end
