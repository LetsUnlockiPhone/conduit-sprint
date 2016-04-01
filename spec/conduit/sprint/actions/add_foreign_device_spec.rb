require 'spec_helper'

describe AddForeignDevice do
  let(:meid) { '12345678aaa' }
  let(:creds) do
    credentials.merge(
      consumer_id: 'consumer_id',
      meid: meid,
      sku_type: 'BYO',
      brand_code: 'PLD',
      part_number: 'PARTNUMBER'
    )
  end

  let(:add_foreign_device) { AddForeignDevice.new(creds) }

  describe 'add_foreign_device_views' do
    let(:dec_unsigned_soap) do
      File.read('./spec/fixtures/requests/add_foreign_device/unsigned_soap.xml')
    end

    let(:dec_signed_soap) do
      File.read('./spec/fixtures/requests/add_foreign_device/signed_soap.xml')
    end

    describe 'soap_xml' do
      subject { add_foreign_device.soap_xml }
      it      { should eq dec_unsigned_soap }
    end

    describe 'signed_soap_xml' do
      subject { add_foreign_device.signed_soap_xml }
      it      { should eq dec_signed_soap }
    end
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      AddForeignDevice.new(creds.merge(mock_status: :error))
    end
  end

  context 'a successful add_foreign_device response is returned' do
    let(:serializable_hash) do
      {
       :available_reason_code         => "213",
       :available_reason_description  => "SUCCESS_DEVICE_ADDED: Device added/updated successfully to Sprint Inventory.",
       :model_number                  => "IPH616GBFGY1"
      }
    end

    subject                 { add_foreign_device.perform }
    it                      { should be_an_instance_of AddForeignDevice::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end

  context 'a failed add_foreign_device response is returned' do
    before { creds.merge!(mock_status: :failure) }

    let(:response_errors) do
      [
        { code: "264", message: "RESKU_INFO_MISSING: Device re-SKU information not found" },
        { code: "Server.704", message: "Application Processing Error" }
      ]
    end

    subject                 { add_foreign_device.perform }
    it                      { should be_an_instance_of AddForeignDevice::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end
end
