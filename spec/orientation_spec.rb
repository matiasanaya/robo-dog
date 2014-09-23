require_relative '../lib/robo_dog/pose/orientation'

RSpec.describe RoboDog::Pose::Orientation do
  describe 'the public interface' do
    it { expect(described_class).to respond_to :constantize, :stringify }
  end

  describe '.constantize' do
    shared_examples 'a constantizer' do |string, expect_constant|
      subject { described_class.constantize(string) }

      it 'returns the correct constant' do
        is_expected.to eql expect_constant
      end
    end

    it_behaves_like 'a constantizer', 'N', described_class::NORTH
    it_behaves_like 'a constantizer', 'E', described_class::EAST
    it_behaves_like 'a constantizer', 'S', described_class::SOUTH
    it_behaves_like 'a constantizer', 'W', described_class::WEST
  end

  describe '.stringify' do
    shared_examples 'a stringifier' do |constant, expected_string|
      subject { described_class.stringify(constant) }

      it 'returns the correct constant' do
        is_expected.to eql expected_string
      end
    end

    it_behaves_like 'a stringifier', described_class::NORTH, 'N'
    it_behaves_like 'a stringifier', described_class::EAST, 'E'
    it_behaves_like 'a stringifier', described_class::SOUTH, 'S'
    it_behaves_like 'a stringifier', described_class::WEST, 'W'
  end
end
