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
        expect { described_class.parse(str_io) }.to raise_exception RoboticSheepDog::Parser::DataError
      end
    end

    context 'with invalid input data' do

      it_behaves_like 'a complaining parser',
                        'invalid data'

      context 'with missing paddock data' do
        it_behaves_like 'a complaining parser',
                        <<-END.gsub(/^\s+\|/, '')
                          |1 2 N
                          |LMLMLMLMM
                        END
      end
      context 'with invalid paddock data' do
        it_behaves_like 'a complaining parser',
                        <<-END.gsub(/^\s+\|/, '')
                          |5
                          |1 2 N
                          |LMLMLMLMM
                        END
      end

      context 'with missing robot data' do
        it_behaves_like 'a complaining parser',
                        <<-END.gsub(/^\s+\|/, '')
                          |5 5
                          |1 3 S
                        END
      end
    end

    context 'with valid input data' do
      let(:valid_input) do
        s = <<-END.gsub(/^\s+\|/, '')
          |5 5
          |1 2 N
          |LMLMLMLMM
          |3 3 E
          |MMRMMRMRRM
        END
        StringIO.new(s)
      end

      subject { described_class.parse(valid_input) }

      it 'returns a hash' do
        is_expected.to be_instance_of Hash
      end

      it 'includes paddock data' do
        is_expected.to include :paddock
      end

      it 'includes robots data' do
        is_expected.to include :robots
      end

      it 'parses paddock data' do
        is_expected.to include paddock: '5 5'
      end

      it 'parser robot data' do
        robots = {
          robots: [
            {
              pose: '1 2 N',
              commands: 'LMLMLMLMM'
            },
            {
              pose: '3 3 E',
              commands: 'MMRMMRMRRM'
            }
          ]
        }

        is_expected.to include robots
      end
    end
  end
end
