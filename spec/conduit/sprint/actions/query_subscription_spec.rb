require 'spec_helper'
include Conduit::Driver::Sprint

describe QuerySubscription do
  let(:query_subscription) do
    QuerySubscription.new(
      mdn: '5555555555',
      application_id: '2013020701',
      application_user_id: 'MOBILENET',
      cert: File.read('./spec/fixtures/security/cert.pem'),
      key: File.read('./spec/fixtures/security/key.pem')
    )
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
    before  { Time.stub_chain(:now, :utc).and_return(Time.utc(2014,6,24,13,19,16)) }
    subject { query_subscription.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    before  { Time.stub_chain(:now, :utc).and_return(Time.utc(2014,6,24,13,19,16)) }
    subject { query_subscription.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'a SOAP fault is returned' do
    let(:response) do
      [
        { code: '210820012', message: 'The subscriber does not belong to the 2013020701 Major Account/MVNO' },
        { code: 'Server.704', message: 'Application processing error' }
      ]
    end

    before(:example) do
      savon.expects(:wholesale_query_subscription_v4).
        with(signed_soap: signed_soap).returns(soap_fault)
    end

    subject { query_subscription.perform }
    it      { should eq response }
  end

  context 'a successful query subscription response is returned' do
    let(:response) do
      {
        :reseller_partner_id => '2013020701',
        :device_detail_list => {
          :device_detail_info => {
            :device_serial_number => '256691457605767761',
            :serial_type          => 'E',
            :esn_meid_hex         => '99000210580251',
            :lte_imsi             => '310120011729158',
            :lte_icc_id           => '89011200000117291582',
            :effective_date       => Date.new(2013,11,29),
            :effective_time       => Time.new(2014,6,26,14,58,44),
            :expiration_time      => Time.new(2014,6,26,14,58,48)
          }
        },
        :are_more_devices => false,
        :mdn_list => {
          :mdn_record => {
            :mdn                => '5555555555',
            :effective_date     => Date.new(2014,5,1),
            :effective_time     => Time.new(2014,6,26,14,10,19),
            :msid               => '000002812511206',
            :switch_status_code => 'A'
          }
        },
        :are_more_mdns      => false,
        :activation_date    => Date.new(2013,11,29),
        :reserve_mdn_id     => nil,
        :reserve_date_time  => DateTime.new(2013,11,29,14,58,44,'+0'),
        :csa => 'HOUHST281',
        :current_nai_list => {
          :nai_record => {
            :effective_date       => Date.new(2014,5,1),
            :network_status_code  => 'A',
            :nai                  => '5555555555@MVNO208.SPRINTPCS.COM'
          }
        },
        :are_more_price_plans => false,
        :price_plan_list => {
          :price_plan_record => {
            :service_code         => 'MONPLAN1',
            :service_description  => 'MRC CASUAL USAGE NO ROAM',
            :effective_date       => Date.new(2013,11,29)
          }
        },
        :subscription_effective_date  => Date.new(2013,11,29),
        :subscription_id              => '33484084008',
        :subscription_type_code       => 'T',
        :are_more_services            => false,
        :detailed_service_list => {
          :service_record => [
            {
              :service_code         => 'MONINTCL',
              :service_description  => 'INTERNATIONAL DIALING',
              :effective_date       => Date.new(2013,11,29),
            },
            {
              :service_code         => 'MONWMISOC',
              :service_description  => 'MOBILE INTEGRATION SOC',
              :effective_date       => Date.new(2013,11,29),
            },
            {
              :service_code         => 'MONPMVM',
              :service_description  => 'PICTURE/VIDEO MESSAGING',
              :effective_date       => Date.new(2013,11,29),
            }
          ]
        },
        :'@xmlns:whol'  => 'http://integration.sprint.com/interfaces/wholesaleQuerySubscriptionBt/v4/wholesaleQuerySubscriptionBtV4.xsd',
        :'@xmlns:whol1' => 'http://integration.sprint.com/interfaces/wholesaleQuerySubscription/v4/wholesaleQuerySubscriptionV4.xsd'
      }
    end

    before(:example) do
      savon.expects(:wholesale_query_subscription_v4).
        with(signed_soap: signed_soap).returns(success)
    end

    subject { query_subscription.perform }
    it      { should eq response }
  end
end