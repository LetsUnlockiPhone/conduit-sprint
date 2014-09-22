require 'spec_helper'

describe Change do
  let(:change) do
    Change.new(
      credentials.merge(
        mdn: '5555555555',
        plan_code:'TEST_PLAN',
        services_to_add: ['NEW_CODE'],
        services_to_remove: ['REMOVE_CODE'])
      )
  end 

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/change/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/change/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { change.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { change.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      Change.new(
        credentials.merge(
          mdn: '5555555555',
          plan_code:'TEST_PLAN',
          services_to_add: ['NEW_CODE'],
          services_to_remove: ['REMOVE_CODE'],
          mock_status: :error)
        )
    end
  end

  context 'a successful change response is returned' do
    subject                 { change.perform }
    it                      { should be_an_instance_of Change::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should be_empty }
  end
end
