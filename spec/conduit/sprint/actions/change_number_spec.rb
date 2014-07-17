require 'spec_helper'

describe ChangeNumber do
  let(:change_number) { ChangeNumber.new(credentials.merge(mdn: '5555555555')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/change_number/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/change_number/signed_soap.xml')
  end

  let(:success) do
    File.read('./spec/fixtures/responses/change_number/success.xml')
  end

  describe 'soap_xml' do
    subject { change_number.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { change_number.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'a successful change number response is returned' do
    let(:serializable_hash) do
      { :new_mdn => "1234567891", :msid => "00000888883888" }
    end

    before(:example) do
      savon.expects(:swap_mdn).
        with(signed_soap: signed_soap).returns(success)
    end

    subject                 { change_number.perform }
    it                      { should be_an_instance_of ChangeNumber::Parser }
    its(:xml)               { should eq success }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end
end
