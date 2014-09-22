require_relative '../lib/robotic_sheep_dog/pose'

RSpec.describe RoboticSheepDog::Pose do
  describe 'the public interface' do
    subject{ described_class.new }
    it { is_expected.to respond_to :report, :coordinates, :adjacent, :rotate! }
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
      let(:orientation) { RoboticSheepDog::Pose::Orientation::NORTH }
      it 'returns the correct coordinates' do
        is_expected.to include x: 2, y: 3, orientation: orientation
      end
    end

    context 'when facing east' do
      let(:orientation) { RoboticSheepDog::Pose::Orientation::EAST }
      it 'returns the correct coordinates' do
        is_expected.to include x: 3, y: 2, orientation: orientation
      end
    end

    context 'when facing south' do
      let(:orientation) { RoboticSheepDog::Pose::Orientation::SOUTH }
      it 'returns the correct coordinates' do
        is_expected.to include x: 2, y: 1, orientation: orientation
      end
    end

    context 'when facing west' do
      let(:orientation) { RoboticSheepDog::Pose::Orientation::WEST }
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
      let(:init_orientation) { RoboticSheepDog::Pose::Orientation::NORTH }
      it_behaves_like 'a rotatable pose',
                      :clockwise,
                      RoboticSheepDog::Pose::Orientation::EAST

      it_behaves_like 'a rotatable pose',
                      :counter,
                      RoboticSheepDog::Pose::Orientation::WEST
    end

    context 'when facing east' do
      let(:init_orientation) { RoboticSheepDog::Pose::Orientation::EAST }
      it_behaves_like 'a rotatable pose',
                      :clockwise,
                      RoboticSheepDog::Pose::Orientation::SOUTH

      it_behaves_like 'a rotatable pose',
                      :counter,
                      RoboticSheepDog::Pose::Orientation::NORTH
    end

    context 'when facing south' do
      let(:init_orientation) { RoboticSheepDog::Pose::Orientation::SOUTH }
      it_behaves_like 'a rotatable pose',
                      :clockwise,
                      RoboticSheepDog::Pose::Orientation::WEST

      it_behaves_like 'a rotatable pose',
                      :counter,
                      RoboticSheepDog::Pose::Orientation::EAST
    end

    context 'when facing west' do
      let(:init_orientation) { RoboticSheepDog::Pose::Orientation::WEST }
      it_behaves_like 'a rotatable pose',
                      :clockwise,
                      RoboticSheepDog::Pose::Orientation::NORTH

      it_behaves_like 'a rotatable pose',
                      :counter,
                      RoboticSheepDog::Pose::Orientation::SOUTH
    end
  end
end