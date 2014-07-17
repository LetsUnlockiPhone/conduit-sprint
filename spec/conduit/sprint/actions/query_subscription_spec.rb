require 'spec_helper'

describe QuerySubscription do
  let(:query_subscription) do
    QuerySubscription.new(credentials.merge(mdn: '5555555555'))
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/query_subscription/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/query_subscription/signed_soap.xml')
  end

  let(:soap_fault) do
    File.read('./spec/fixtures/responses/query_subscription/soap_fault.xml')
  end

  let(:success) do
    File.read('./spec/fixtures/responses/query_subscription/success.xml')
  end

  describe 'soap_xml' do
    subject { query_subscription.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { query_subscription.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'a SOAP fault is returned' do
    let(:response_errors) do
      [
        { code: '210820012', message: 'The subscriber does not belong to the 2222333344 Major Account/MVNO' },
        { code: 'Server.704', message: 'Application processing error' }
      ]
    end

    before(:example) do
      savon.expects(:wholesale_query_subscription_v4).
        with(signed_soap: signed_soap).returns(soap_fault)
    end

    subject                 { query_subscription.perform }
    it                      { should be_an_instance_of QuerySubscription::Parser }
    its(:xml)               { should eq soap_fault }
    its(:response_status)   { should eq 'failure' }    
    its(:response_errors)   { should eq response_errors }
  end

  context 'a successful query subscription response is returned' do
    let(:serializable_hash) do 
      {
        :reseller_partner_id => '2222333344',
        :esn_dec => '256691457605767761',
        :esn_hex => '99000210580251',
        :imsi => '310120011729158',
        :icc_id => '89011200000117291582',
        :activated_at => '2013-11-29',
        :mdn => '5555555555',
        :msid => '000002812511206',
        :status => 'A',
        :csa => 'HOUHST281',
        :plan_code                 => 'MONPLAN1',
        :plan_description          => 'MRC CASUAL USAGE NO ROAM',
        :plan_effective_date       => '2013-11-29',
        :nai_effective_date        => '2014-05-01',
        :nai_network_status_code  => 'A',
        :nai                  => '5555555555@MVNO208.SPRINTPCS.COM',
        :service_records => [
          {
            :service_code         => 'MONINTCL',
            :service_description  => 'INTERNATIONAL DIALING',
            :effective_date       => '2013-11-29',
          },
          {
            :service_code         => 'MONWMISOC',
            :service_description  => 'MOBILE INTEGRATION SOC',
            :effective_date       => '2013-11-29',
          },
          {
            :service_code         => 'MONPMVM',
            :service_description  => 'PICTURE/VIDEO MESSAGING',
            :effective_date       => '2013-11-29',
          }
        ]
      }
    end

    before(:example) do
      savon.expects(:wholesale_query_subscription_v4).
        with(signed_soap: signed_soap).returns(success)
    end

    subject                 { query_subscription.perform }
    it                      { should be_an_instance_of QuerySubscription::Parser }
    its(:xml)               { should eq success }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end
end
