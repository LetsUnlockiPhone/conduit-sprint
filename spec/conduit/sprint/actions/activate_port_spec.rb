require 'spec_helper'

describe ActivatePort do
  let(:port_attributes) do
    credentials.merge(nid: '12345678901', first_name: 'test', last_name: 'tester', mdn: '5555555555',
                  service_codes: ['TESTNVM', 'TESTPMVM', 'TESTINTCL'], authorized_by: 'customer',
                  city: 'city', state: 'state', zip: '99999', address1: '123 Test St', csa: 'MIAWPB561',
                  carrier_account: '999999', plan_code: 'TESTPLAN', ssn: '')
  end

  let(:activate_port) do
    ActivatePort.new port_attributes
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/activate_port/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/activate_port/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { activate_port.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { activate_port.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'when no street type is given' do
    let(:port_attributes) do
      credentials.merge(nid: '12345678901', mdn: '5555555555', first_name: 'test', last_name: 'tester',
                    service_codes: ['TESTNVM', 'TESTPMVM', 'TESTINTCL'],
                    city: 'city', state: 'state', zip: '99999', address1: '123 Test', csa: 'MIAWPB561',
                    carrier_account: '999999', plan_code: 'TESTPLAN')
    end

    let(:unsigned_soap) do
      File.read('./spec/fixtures/requests/activate_port/unsigned_no_street_type_soap.xml')
    end

    subject { activate_port.soap_xml }
    it      { should eq unsigned_soap }
  end

  context 'when no authorized by is given' do
    let(:port_attributes) do
      credentials.merge(nid: '12345678901', mdn: '5555555555', first_name: 'test', last_name: 'tester',
                    service_codes: ['TESTNVM', 'TESTPMVM', 'TESTINTCL'],
                    city: 'city', state: 'state', zip: '99999', address1: '123 Test St', csa: 'MIAWPB561',
                    carrier_account: '999999', plan_code: 'TESTPLAN')
    end

    let(:unsigned_soap) do
      File.read('./spec/fixtures/requests/activate_port/unsigned_no_authorized_by_soap.xml')
    end

    subject { activate_port.soap_xml }
    it      { should eq unsigned_soap }
  end

  context 'when no first name and last name given' do
    let(:port_attributes) do
      credentials.merge(nid: '12345678901', mdn: '5555555555',
                    service_codes: ['TESTNVM', 'TESTPMVM', 'TESTINTCL'],
                    city: 'city', state: 'state', zip: '99999', address1: '123 Test St', csa: 'MIAWPB561',
                    carrier_account: '999999', plan_code: 'TESTPLAN')
    end

    let(:unsigned_soap) do
      File.read('./spec/fixtures/requests/activate_port/unsigned_no_first_last_name_soap.xml')
    end

    subject { activate_port.soap_xml }
    it      { should eq unsigned_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      ActivatePort.new \
        port_attributes.merge(mock_status: :error)
    end
  end

  context 'a successful activate port response is returned' do
    let(:serializable_hash) do
      {
        :mdn            => "5555555555",
        :msid           => "000006785706092",
        :effective_date => "2014-10-17",
        :csa            => "MIAWPB561",
        :esn_dec        => "12345678901",
        :esn_type       => "E",
        :iccid          => nil,
        :imsi           => nil,
        :msl            => "311063",
        :plan_code      =>"TESTPLAN",
        :port_result    =>
        {
          :mdn                                    => "5555555555",
          :ppv_status                             => "2",
          :ppv_status_text                        => "PTN is eligible for Porting In",
          :port_in_status                         => "0000",
          :port_in_status_text                    => "SUCCESS (0000)",
          :port_number                            => "44461996",
          :old_service_provider                   => "AT&T WIRELESS",
          :csa                                    => "MIAWPB561",
          :desired_due_date_time                  => "2014-10-17T11:41:02",
          :number_portability_direction_indicator => "A"
        },
        :service_records =>
        [
          {
            :service_code=>"TESTSERVICE",
            :effective_date=>"2014-10-17"
          },
          {
            :service_code=>"TESTSERVICE2",
            :effective_date=>"2014-10-17"
          }
        ]
      }
    end

    subject                 { activate_port.perform }
    it                      { should be_an_instance_of ActivatePort::Parser }
    its(:response_status)   { should eq 'acknowledged' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end

  context 'an activate port with out csa should fetch a csa' do
    let(:validate_port) do
      File.read('./spec/fixtures/requests/activate_port/unsigned_validate_port_soap.xml')
    end

    subject do
      port_attributes.delete(:csa)
      ActivatePort.new port_attributes
    end

    its(:soap_xml) { should eq validate_port }
  end

  context 'an activate port with transfer ownership' do
    let(:transfer_ownership_attributes) do
      credentials.merge(nid: '12345678901')
    end

    let(:activate_port) do
      ActivatePort.new port_attributes.merge(claim_ownership: true)
    end

    it 'should request to transfer ownership' do
      response            = Struct.new(:response_status).new('success')
      transfer_ownership  = Struct.new(:perform).new(response)

      expect(TransferOwnership).to receive(:new).
        with(transfer_ownership_attributes).
        and_return(transfer_ownership)

      expect(transfer_ownership).to receive(:perform).
        and_return(response)

      activate_port.perform
    end

    it 'should raise exeception if transfer ownership fails' do
      response            = Struct.new(:response_status).new('failure')
      transfer_ownership  = Struct.new(:perform).new(response)

      expect(TransferOwnership).to receive(:new).
        with(transfer_ownership_attributes).
        and_return(transfer_ownership)

      expect(transfer_ownership).to receive(:perform).
        and_return(response)

      expect { activate_port.perform }.to raise_error
    end
  end

  context 'a failed activate port response is returned' do
    before do
      port_attributes.merge!(mock_status: :failure)
    end

    let(:response_errors) do
      [
        { code: "Client.701", message: "No data found on RATED_FEATURE table for SOC:" },
        { code: "Client.701", message: "Data not found" }
      ]
    end

    subject                 { activate_port.perform }
    it                      { should be_an_instance_of ActivatePort::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end
end
