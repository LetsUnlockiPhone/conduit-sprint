require 'spec_helper'
include Conduit::Driver::Sprint

describe Restore do
  let(:restore) do
    Restore.new(
      mdn: '5555555555',
      application_id: '2013020701',
      application_user_id: 'MOBILENET',
      cert: File.read('./spec/fixtures/security/cert.pem'),
      key: File.read('./spec/fixtures/security/key.pem')
    )
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/restore/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/restore/signed_soap.xml')
  end

  let(:success) do
    File.read('./spec/fixtures/responses/restore/success.xml')
  end

  describe 'soap_xml' do
    before  do
      Time.stub_chain(:now, :utc).and_return(Time.utc(2014,6,24,13,19,16))
      SecureRandom.stub(base64: "9999999999")
    end
    
    subject { restore.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    before  do
      Time.stub_chain(:now, :utc).and_return(Time.utc(2014,6,24,13,19,16))
      SecureRandom.stub(base64: "9999999999")
    end

    subject { restore.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'a successful restore response is returned' do
    let(:response) do
      {
        :confirm_msg=>"successful", 
        :@xmlns=>"http://integration.sprint.com/interfaces/WholesaleSubscriptionModify/v1/ModifySubscriptionEnvelope.xsd", 
        :'@xmlns:tns'=>"http://integration.sprint.com/integration/interfaces/WholesaleSubscriptionModifyBt/v1"
      }
    end

    before(:example) do
      savon.expects(:restore_subscription).
        with(signed_soap: signed_soap).returns(success)
    end

    subject { restore.perform }
    it      { should eq response }
  end
end