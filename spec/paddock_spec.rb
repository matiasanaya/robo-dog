require_relative '../lib/robotic_sheep_dog/paddock'

RSpec.describe RoboticSheepDog::Paddock do
  describe 'the public interface' do
    it { expect(described_class).to respond_to :build }

    subject{ described_class.new }
    it { is_expected.to respond_to :valid_coordinates? }
  end

  describe '.build' do
    context 'with invalid data' do
      let(:data) { '1' }
      it 'screams at you' do
        expect { described_class.build(data) }.to raise_exception described_class::DataError
      end
    end
    context 'with valid data' do
      let(:data) { '4 3'}
      it 'returns a paddock instance' do
        expect(described_class.build(data)).to be_instance_of described_class
      end
      it 'builds with correct x size' do
        expect(described_class.build(data).instance_variable_get(:@x_size)).to eql 4
      end
      it 'builds with correct y size' do
        expect(described_class.build(data).instance_variable_get(:@y_size)).to eql 3
      end
    end
  end

  let(:paddock) { described_class.new(5, 5) }

  describe '#valid_coordinates?' do
    context 'with coordinates within paddock' do
      it 'returns truthy' do
        [[0,0],[5,5],[2,4]].each do |coordinates|
          expect(paddock.valid_coordinates?(x: coordinates[0], y: coordinates[1])).to be_truthy
        end
      end
    end
    context 'with coordinates outside of paddock' do
      it 'returns falsy' do
        [[-1,0],[6,5],[7,7]].each do |coordinates|
          expect(paddock.valid_coordinates?(x: coordinates[0], y: coordinates[1])).to be_falsy
        end
      end
    end
  end
end
