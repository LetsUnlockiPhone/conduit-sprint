require 'spec_helper'

describe CheckCoverage do
  let(:check_coverage_zip) do
    CheckCoverage.new(credentials.merge(zip: '33415', zip4: '5555'))
  end

  let(:check_coverage_city_state) do
    CheckCoverage.new(credentials.merge(city: 'Palm Beach', state: 'FL', zip: ''))
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
        :zip                           => '33415',
        :zip4                          => '5555',
        :city                          => nil,
        :state                         => nil,
        :longitude                     => '-80.1342',
        :latitude                      => '26.653',
        :confidence                    => 'Z3',
        :csa                           => 'MIAWPB561',
        :cdma_ind                      => 'true',
        :wi_max_ind                    => 'true',
        :lte_ind                       => 'true',
        :evdo_ind                      => 'true',
        :iden_ind                      => 'false',
        :hpptt_ind                     => 'true',
        :airave_consumer_ind           => 'true',
        :airave_enterprise_ind         => 'true',
        :hybrid_ind                    => 'false',
        :coverage_quality_cdma         => 'Best Coverage',
        :coverage_quality_iden         => 'No Coverage',
        :coverage_quality_lte          => 'in building',
        :coverage_quality_wi_max       => 'on street',
        :roam_digital_ind              => 'true',
        :upcoming_coverage_cdma_ind    => 'false',
        :upcoming_coverage_iden_ind    => 'false',
        :npa                           => '561',
        :nxx                           => '357',
        :affiliate_name                => 'Sprint PCS'
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
        :zip                           => nil,
        :zip4                          => nil,
        :city                          => 'Palm Beach',
        :state                         => 'FL',
        :longitude                     => '-80.1342',
        :latitude                      => '26.653',
        :confidence                    => 'Z3',
        :csa                           => 'MIAWPB561',
        :cdma_ind                      => 'true',
        :wi_max_ind                    => 'true',
        :lte_ind                       => 'true',
        :evdo_ind                      => 'true',
        :iden_ind                      => 'false',
        :hpptt_ind                     => 'true',
        :airave_consumer_ind           => 'true',
        :airave_enterprise_ind         => 'true',
        :hybrid_ind                    => 'false',
        :coverage_quality_cdma         => 'Best Coverage',
        :coverage_quality_iden         => 'No Coverage',
        :coverage_quality_lte          => 'in building',
        :coverage_quality_wi_max       => 'on street',
        :roam_digital_ind              => 'true',
        :upcoming_coverage_cdma_ind    => 'false',
        :upcoming_coverage_iden_ind    => 'false',
        :npa                           => '561',
        :nxx                           => '357',
        :affiliate_name                => 'Sprint PCS'
      }
    end

    subject                 { check_coverage_city_state.perform }
    it                      { should be_an_instance_of CheckCoverage::Parser }
    its(:response_status)   { should eq 'success'}
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end

  context 'a failed check_coverage response is returned' do
    let(:check_coverage_zip) do
      CheckCoverage.new(credentials.merge(zip: '33415', zip4: '5555', mock_status: :failure))
    end

    let(:response_errors) do
      [
        Conduit::Error.new(:code=>"210820012",
          :message=>"The subscriber does not belong to the 2222333344 Major Account/MVNO"),
        Conduit::Error.new(:code=>"Server.704", :message=>"Application processing error")
      ]
    end

    subject                 { check_coverage_zip.perform }
    it                      { should be_an_instance_of CheckCoverage::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end
end
