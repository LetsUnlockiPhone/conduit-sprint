require 'spec_helper'
include Conduit::Driver::Sprint

describe QueryCSA do
  let(:zip)   { '33415'}
  let(:zip4)  { '5555'}

  let(:query_csa) do
    QueryCSA.new(
      city: 'Palm Beach',
      state: 'FL',
      zip: zip,
      zip4: zip4,
      application_id: '2013020701',
      application_user_id: 'MOBILENET',
      cert: File.read('./spec/fixtures/security/cert.pem'),
      key: File.read('./spec/fixtures/security/key.pem')
    )
  end

  let(:unsigned_zipcode_soap) do
    File.read('./spec/fixtures/requests/query_csa/unsigned_soap.xml')
  end

  let(:signed_zipcode_soap) do
    File.read('./spec/fixtures/requests/query_csa/signed_zipcode_soap.xml')
  end

  let(:signed_city_state_soap) do
    File.read('./spec/fixtures/requests/query_csa/signed_city_state_soap.xml')
  end

  let(:successful_zipcode_response) do
    File.read('./spec/fixtures/responses/query_csa/successful_zipcode_response.xml')
  end

  let(:successful_city_state_response) do
    File.read('./spec/fixtures/responses/query_csa/successful_city_state_response.xml')
  end

  describe 'soap_xml' do
    before  do
      Time.stub_chain(:now, :utc).and_return(Time.utc(2014,6,24,13,19,16))
      SecureRandom.stub(base64: "9999999999")
    end
    
    subject { query_csa.soap_xml }
    it      { should eq unsigned_zipcode_soap }
  end

  describe 'signed_soap_xml' do
    before  do
      Time.stub_chain(:now, :utc).and_return(Time.utc(2014,6,24,13,19,16))
      SecureRandom.stub(base64: "9999999999")
    end
    
    subject { query_csa.signed_soap_xml }
    it      { should eq signed_zipcode_soap }
  end

  context 'a successful zip code query csa response is returned' do
    let(:response) do 
      {
        :zip =>
        {
          :usps_postal_cd           => "33415",
          :usps_postal_cd_extension => "5555"
        }, 
        :longitude              => '-80.1257',
        :latitude               => '26.66',
        :confidence             => 'Z1',
        :csa                    => 'MIAWPB561',
        :is3g                   => true,
        :evdo                   => true,
        :iden                   => false,
        :hybrid                 => false,
        :coverage_quality_cdma  => 'Best Coverage',
        :coverage_quality_iden  => 'No Coverage',
        :roam_digital           => true,
        :upcoming_coverage_cdma => false,
        :upcoming_coverage_iden => false,
        :npa                    => '561',
        :nxx                    => '242',
        :affiliate_name         => 'Sprint PCS',
        :'@xmlns:ns0'           => 'http://integration.sprint.com/interfaces/QueryCsa/v1/QueryCsaEnvelope.xsd'
      }
    end

    before(:example) do
      savon.expects(:query_csa).
        with(signed_soap: signed_zipcode_soap).returns(successful_zipcode_response)
    end

    subject { query_csa.perform }
    it      { should eq response }
  end

  context 'a successful city state query csa response is returned' do
    let(:response) do 
      {
        :city                   => 'Palm Beach',
        :state                  => 'FL',
        :longitude              => '-80.036669',
        :latitude               => '26.705279',
        :confidence             => 'G3',
        :csa                    => 'MIAWPB561',
        :is3g                   => true,
        :evdo                   => true,
        :iden                   => false,
        :hybrid                 => false,
        :coverage_quality_cdma  => 'Good Coverage',
        :coverage_quality_iden  => 'No Coverage',
        :roam_digital           => true,
        :upcoming_coverage_cdma => false,
        :upcoming_coverage_iden => false,
        :npa                    => '561',
        :nxx                    => '206',
        :affiliate_name         => 'Sprint PCS',
        :'@xmlns:ns0'           => 'http://integration.sprint.com/interfaces/QueryCsa/v1/QueryCsaEnvelope.xsd'
      }
    end

    let(:zip)   { nil }
    let(:zip4)  { nil }

    before(:example) do
      savon.expects(:query_csa).
        with(signed_soap: signed_city_state_soap).returns(successful_city_state_response)
    end

    subject { query_csa.perform }
    it      { should eq response }
  end 
end