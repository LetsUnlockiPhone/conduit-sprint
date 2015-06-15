require 'spec_helper'

describe ModifyPort do
  let(:modify_port) do
    ModifyPort.new \
      credentials.merge(mdn: '5555555555', first_name:'new first', last_name: 'new last', address1: '123 W Test St', city: 'city', state: 'state', zip: '99999', carrier_account: '999', ssn: '999999999',
                        carrier_password: 'password', remark: 'remark', zip: 'new zip')
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/modify_port/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/modify_port/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { modify_port.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { modify_port.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      ModifyPort.new(credentials.merge(mdn: '5555555555', remark: 'modify it', mock_status: :error))
    end
  end

  context 'a success modify port response is returned' do
    subject                 { modify_port.perform }
    it                      { should be_an_instance_of ModifyPort::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
  end
end
