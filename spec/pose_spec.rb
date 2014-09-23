require_relative '../lib/robotic_sheep_dog/pose'

RSpec.describe RoboticSheepDog::Pose do
  describe 'the public interface' do
    it { expect(described_class).to respond_to :build }
    subject{ described_class.new }
    it { is_expected.to respond_to :report, :coordinates, :adjacent, :rotate! }
  end

  describe '.build' do
    context 'with invalid data' do
      let(:data) { '1' }
      it 'screams at you' do
        expect { described_class.build(data) }.to raise_exception described_class::DataError
      end
    end
    context 'with valid data' do
      let(:data) { '4 3 N'}
      it 'returns a instance of self' do
        expect(described_class.build(data)).to be_instance_of described_class
      end
      it 'builds with correct x coordinate' do
        expect(described_class.build(data).instance_variable_get(:@x)).to eql 4
      end
      it 'builds with correct y coordinate' do
        expect(described_class.build(data).instance_variable_get(:@y)).to eql 3
      end
      it 'builds with correct orientation' do
        expect(described_class.build(data).instance_variable_get(:@orientation)).to eql described_class::Orientation::NORTH
      end
    end
  end

  let(:pose) do
    described_class.new(x: 0, y: 0, orientation: :north)
  end

  describe '#report' do
    subject { pose.report }
    it 'returns a hash' do
      is_expected.to be_instance_of Hash
    end

    it 'includes x, y and orientation' do
      is_expected.to include x: 0, y: 0, orientation: :north
    end
  end

  describe '#coordinates' do
    subject { pose.coordinates }

    it 'returns a hash' do
      is_expected.to be_instance_of Hash
    end

    it 'includes x and y coordinates' do
      is_expected.to include x: 0, y: 0
    end
  end

  describe '#adjacent' do
    let(:pose) { described_class.new(x: 2, y: 2, orientation: orientation) }

    subject { pose.adjacent.report }

    context 'when facing north' do
      let(:orientation) { described_class::Orientation::NORTH }
      it 'returns the correct coordinates' do
        is_expected.to include x: 2, y: 3, orientation: orientation
      end
    end

    context 'when facing east' do
      let(:orientation) { described_class::Orientation::EAST }
      it 'returns the correct coordinates' do
        is_expected.to include x: 3, y: 2, orientation: orientation
      end
    end

    context 'when facing south' do
      let(:orientation) { described_class::Orientation::SOUTH }
      it 'returns the correct coordinates' do
        is_expected.to include x: 2, y: 1, orientation: orientation
      end
    end

    context 'when facing west' do
      let(:orientation) { described_class::Orientation::WEST }
      it 'returns the correct coordinates' do
        is_expected.to include x: 1, y: 2, orientation: orientation
      end
    end
  end

  describe '#rotate!' do
    let(:pose) { described_class.new(x: 2, y: 2, orientation: init_orientation) }

    shared_examples 'a rotatable pose' do |direction, correct_orientation|
      it 'returns the correct orientation' do
        expect(pose.rotate!(direction).report).to include x: 2, y: 2, orientation: correct_orientation
      end
    end

    context 'when facing north' do
      let(:init_orientation) { described_class::Orientation::NORTH }
      it_behaves_like 'a rotatable pose',
                      :clockwise,
                      described_class::Orientation::EAST

      it_behaves_like 'a rotatable pose',
                      :counter,
                      described_class::Orientation::WEST
    end

    context 'when facing east' do
      let(:init_orientation) { described_class::Orientation::EAST }
      it_behaves_like 'a rotatable pose',
                      :clockwise,
                      described_class::Orientation::SOUTH

      it_behaves_like 'a rotatable pose',
                      :counter,
                      described_class::Orientation::NORTH
    end

    context 'when facing south' do
      let(:init_orientation) { described_class::Orientation::SOUTH }
      it_behaves_like 'a rotatable pose',
                      :clockwise,
                      described_class::Orientation::WEST

      it_behaves_like 'a rotatable pose',
                      :counter,
                      described_class::Orientation::EAST
    end

    context 'when facing west' do
      let(:init_orientation) { described_class::Orientation::WEST }
      it_behaves_like 'a rotatable pose',
                      :clockwise,
                      described_class::Orientation::NORTH

      it_behaves_like 'a rotatable pose',
                      :counter,
                      described_class::Orientation::SOUTH
    end
  end
end
