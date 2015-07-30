require 'spec_helper'

describe Conduit::Sprint::SerialNumberTypeDetector do
  let(:meid_dectector) do
    Conduit::Sprint::SerialNumberTypeDetector.new(meid)
  end

  describe '#dec? 11 digit' do
    let(:meid) { '12345678901' }

    context 'when a dec meid is given' do
      it 'should be true' do
        expect(meid_dectector.dec?).to eql true
      end

      it 'should be false' do
        expect(meid_dectector.hex?).to eql false
      end
    end
  end

  describe '#dec? 18 digit' do
    let(:meid) { '123456789012345678' }

    context 'when a dec meid is given' do
      it 'should be true' do
        expect(meid_dectector.dec?).to eql true
      end

      it 'should be false' do
        expect(meid_dectector.hex?).to eql false
      end
    end
  end

  describe '#hex? 8 digit' do
    let(:meid) { '12345678' }

    context 'when a dec meid is given' do
      it 'should be true' do
        expect(meid_dectector.hex?).to eql true
      end

      it 'should be false' do
        expect(meid_dectector.dec?).to eql false
      end
    end
  end

  describe '#hex? 14 digit' do
    let(:meid) { '12345678901234' }

    context 'when a dec meid is given' do
      it 'should be true' do
        expect(meid_dectector.hex?).to eql true
      end

      it 'should be false' do
        expect(meid_dectector.dec?).to eql false
      end
    end
  end

  describe 'not sure of either hex or dec' do
    let(:meid) { '1234567890123456789' }

    context 'when a dec meid is given' do
      it 'should be true' do
        expect(meid_dectector.hex?).to eql false
      end

      it 'should be false' do
        expect(meid_dectector.dec?).to eql false
      end
    end
  end
end
