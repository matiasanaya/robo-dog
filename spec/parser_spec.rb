require_relative '../lib/robotic_sheep_dog/parser'
require 'stringio'

RSpec.describe RoboticSheepDog::Parser do
  describe 'the public interface' do
    it { expect(described_class).to respond_to :parse }
  end

  describe '.parse' do
    shared_examples 'a complaining parser' do |input_string|
      it 'screams at you' do
        str_io = StringIO.new(input_string)
        expect { described_class.parse(str_io) }.to raise_exception described_class::DataError
      end
    end

    context 'with invalid input data' do
      context 'with no data' do
        it_behaves_like 'a complaining parser',
                        ''
      end

      context 'with missing robot data' do

        it_behaves_like 'a complaining parser',
                        <<-END.gsub(/^\s+\|/, '')
                          |1 1
                          |only robot_1 coordinates
                        END
      end
    end

    context 'with valid input data' do
      let(:valid_input) do
        s = <<-END.gsub(/^\s+\|/, '')
          |a paddock description
          |robot_1 coordinate
          |robot_1 commands
          |robot_2 coordinates
          |robot_2 commands
        END
        StringIO.new(s)
      end

      subject do
        described_class.instance_variable_set(:@paddock_factory, paddock_factory)
        described_class.instance_variable_set(:@robot_factory, robot_factory)
        described_class.parse(valid_input)
      end

      let(:paddock_factory) do
        dbl = double
        allow(dbl).to receive(:build).and_return('a paddock')
        dbl
      end
      let(:robot_factory) do
        dbl = double
        allow(dbl).to receive(:build).and_return('robot_1','robot_2')
        dbl
      end

      it 'returns a hash' do
        is_expected.to be_instance_of Hash
      end

      it 'includes paddock data' do
        is_expected.to include paddock: 'a paddock'
      end

      it 'includes robots data' do
        is_expected.to include robots: ['robot_1', 'robot_2']
      end
    end
  end
end
