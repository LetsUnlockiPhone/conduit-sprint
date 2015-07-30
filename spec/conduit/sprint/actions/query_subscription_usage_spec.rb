require 'spec_helper'

describe QuerySubscriptionUsage do
  let(:query_subscription_usage) do
    QuerySubscriptionUsage.new(credentials.merge(mdn: '5555555555'))
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/query_subscription_usage/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/query_subscription_usage/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { query_subscription_usage.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { query_subscription_usage.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      QuerySubscriptionUsage.new(credentials.merge(mdn: '5555555555', mock_status: :error))
    end
  end

  context 'a SOAP failure is returned' do
    let(:query_subscription_usage) do
      QuerySubscriptionUsage.new(credentials.merge(mdn: '5555555555', mock_status: :failure))
    end

    let(:response_errors) do
      [{ code: "100000297", message: "978000152 - The equipment does not exist" }]
    end

    subject                 { query_subscription_usage.perform }
    it                      { should be_an_instance_of QuerySubscriptionUsage::Parser }
    its(:response_status)   { should eq 'failure' }
    its(:response_errors)   { should eq response_errors }
  end

  context 'a successful query subscription response is returned' do
    let(:serializable_hash) do
      {
        mdn: "6192794793",
        from_date: "2015-08-02",
        to_date: "2015-08-02",
        usage_type: "U",
        total_calls: "8",
        total_airtime_usage: "0",
        are_more_call_details: "false",
        call_detail_list: [{
          airtime_minutes:"0", activity_unit: "K", call_date: "2015-08-02", call_time: "08:48:53",
          calling_number: "", called_destination: "", called_number: "", home_call: "",
          nai: "310120042360069", rpdr_service_code: "", sid: "", usage_quantity: "0.34",
          usage_source_ind: "P", content_type_name: "", content_detailed_description: ""
        },
        {
          airtime_minutes: "0", activity_unit: "K", call_date: "2015-08-02", call_time: "14:07:47",
          calling_number: "", called_destination: "", called_number: "", home_call: "",
          nai: "310120042360069", rpdr_service_code: "", sid: "", usage_quantity: "0.27",
          usage_source_ind: "P", content_type_name: "", content_detailed_description: ""
        },
        {
          airtime_minutes: "0", activity_unit: "K", call_date: "2015-08-02", call_time: "15:09:37",
          calling_number: "", called_destination: "", called_number: "", home_call: "",
          nai: "310120042360069", rpdr_service_code: "", sid: "", usage_quantity: "0.12",
          usage_source_ind: "P", content_type_name: "", content_detailed_description: ""
        },
        {
          airtime_minutes: "0", activity_unit: "K", call_date: "2015-08-02", call_time: "17:42:00",
          calling_number: "", called_destination: "", called_number: "", home_call: "",
          nai: "310120042360069", rpdr_service_code: "", sid: "", usage_quantity: "508.71",
          usage_source_ind: "P", content_type_name: "", content_detailed_description: ""
        },
        {
          airtime_minutes: "0", activity_unit: "K", call_date: "2015-08-02", call_time: "18:20:02",
          calling_number: "", called_destination: "", called_number: "", home_call: "",
          nai: "310120042360069", rpdr_service_code: "", sid: "", usage_quantity: "6520.74",
          usage_source_ind: "P", content_type_name: "", content_detailed_description: ""
        },
        {
          airtime_minutes: "0", activity_unit: "K", call_date: "2015-08-02", call_time: "18:59:41",
          calling_number: "", called_destination: "", called_number: "", home_call: "",
          nai: "310120042360069", rpdr_service_code: "WISP", sid: "", usage_quantity: "18.61",
          usage_source_ind: "P", content_type_name: "", content_detailed_description: ""
        },
        {
          airtime_minutes: "0", activity_unit: "K", call_date: "2015-08-02", call_time: "20:12:39",
          calling_number: "", called_destination: "", called_number: "", home_call: "",
          nai: "310120042360069", rpdr_service_code: "", sid: "", usage_quantity: "1.31",
          usage_source_ind: "P", content_type_name: "", content_detailed_description: ""
        },
        {
          airtime_minutes: "0", activity_unit: "K", call_date: "2015-08-02", call_time: "22:09:49",
          calling_number: "", called_destination: "", called_number: "", home_call: "",
          nai: "310120042360069", rpdr_service_code: "", sid: "", usage_quantity: "256.31",
          usage_source_ind: "P", content_type_name: "", content_detailed_description: ""
        }]
      }
    end

    subject                 { query_subscription_usage.perform }
    it                      { should be_an_instance_of QuerySubscriptionUsage::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end
end
