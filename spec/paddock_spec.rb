require_relative '../lib/robotic_sheep_dog/paddock'

RSpec.describe RoboticSheepDog::Paddock do
  describe 'the public interface' do
    subject{ described_class.new }
    it { is_expected.to respond_to :valid_coordinates? }
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
