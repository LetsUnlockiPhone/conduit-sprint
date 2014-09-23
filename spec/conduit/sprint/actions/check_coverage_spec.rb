require 'spec_helper'

describe CheckCoverage do
  let(:check_coverage_zip) do
    CheckCoverage.new(credentials.merge(zip: '33415', zip4: '5555'))
  end

  let(:check_coverage_city_state) do
    CheckCoverage.new(credentials.merge(city: 'Palm Beach', state: 'FL'))
  end

  let(:unsigned_zipcode_soap) do
    File.read('./spec/fixtures/requests/check_coverage/unsigned_zipcode_soap.xml')
  end

  let(:signed_zipcode_soap) do
    File.read('./spec/fixtures/requests/check_coverage/signed_zipcode_soap.xml')
  end

  let(:signed_city_state_soap) do
    File.read('./spec/fixtures/requests/check_coverage/signed_city_state_soap.xml')
  end

  describe 'soap_xml_zip' do
    subject { check_coverage_zip.soap_xml }
    it      { should eq unsigned_zipcode_soap }
  end

  describe 'signed_soap_xml_zip' do
    subject { check_coverage_zip.signed_soap_xml }
    it      { should eq signed_zipcode_soap }
  end

  describe 'signed_soap_xml_city_state' do
    subject { check_coverage_city_state.signed_soap_xml }
    it      { should eq signed_city_state_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      CheckCoverage.new(credentials.merge(zip: '33415', zip4: '5555', mock_status: :error))
    end
  end

  context 'a successful zip code query csa response is returned' do
    let(:serializable_hash) do 
      {
        :zip                    => '33415',
        :zip4                   => '5555',
        :city                   => nil,
        :state                  => nil,
        :longitude              => '-80.1257',
        :latitude               => '26.66',
        :confidence             => 'Z1',
        :csa                    => 'MIAWPB561',
        :is3g                   => 'true',
        :evdo                   => 'true',
        :iden                   => 'false',
        :hybrid                 => 'false',
        :coverage_quality_cdma  => 'Best Coverage',
        :coverage_quality_iden  => 'No Coverage',
        :roam_digital           => 'true',
        :npa                    => '561',
        :nxx                    => '242',
        :affiliate_name         => 'Sprint PCS',
      }
    end

    subject                 { check_coverage_zip.perform }
    it                      { should be_an_instance_of CheckCoverage::Parser }
    its(:response_status)   { should eq 'success'}
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end

  context 'a successful city state query csa response is returned' do
    let(:serializable_hash) do 
      {
        :zip                    => nil,
        :zip4                   => nil,
        :city                   => 'Palm Beach',
        :state                  => 'FL',
        :longitude              => '-80.036669',
        :latitude               => '26.705279',
        :confidence             => 'G3',
        :csa                    => 'MIAWPB561',
        :is3g                   => 'true',
        :evdo                   => 'true',
        :iden                   => 'false',
        :hybrid                 => 'false',
        :coverage_quality_cdma  => 'Good Coverage',
        :coverage_quality_iden  => 'No Coverage',
        :roam_digital           => 'true',        
        :npa                    => '561',
        :nxx                    => '206',
        :affiliate_name         => 'Sprint PCS'
      }
    end

    subject                 { check_coverage_city_state.perform }
    it                      { should be_an_instance_of CheckCoverage::Parser }
    its(:response_status)   { should eq 'success'}
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end
end
