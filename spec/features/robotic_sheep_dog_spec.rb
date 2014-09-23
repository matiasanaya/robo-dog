require_relative '../../lib/robotic_sheep_dog/application'
require 'stringio'

RSpec.describe RoboticSheepDog::Application do

  let(:app) { lambda { |input_stream| RoboticSheepDog::Application.build(input_stream).run(mode) } }
  let(:mode) { :sequential }

  shared_examples 'a correct application' do |input_string, correct_output|
    it 'prints the correct output' do
      expect { app.call(StringIO.new(input_string)) }.to output(correct_output).to_stdout
    end
  end

  shared_examples 'a complaining application' do |input_string, error|
    it 'screams at the user' do
      expect { app.call(StringIO.new(input_string)) }.to raise_exception error
    end
  end

  context 'when valid input is provided' do
    context 'when each robot executes all at once' do
      context 'when robots do not run over each other' do
        it_behaves_like 'a correct application',
                        <<-END.gsub(/^\s+\|/, '') ,
                          |5 5
                          |1 2 N
                          |LMLMLMLMM
                          |3 3 E
                          |MMRMMRMRRM
                        END
                        <<-END.gsub(/^\s+\|/, '')
                          |1 3 N
                          |5 1 E
                        END
      end
      context 'when robots run over each other' do
        it_behaves_like 'a complaining application',
                        <<-END.gsub(/^\s+\|/, '') ,
                          |5 5
                          |0 0 E
                          |M
                          |1 0 N
                          |L
                        END
                        RuntimeError
      end

      context 'when robots run over then end of the paddock' do
        it_behaves_like 'a complaining application',
                        <<-END.gsub(/^\s+\|/, '') ,
                          |5 5
                          |5 5 N
                          |M
                        END
                        RuntimeError

        it_behaves_like 'a complaining application',
                        <<-END.gsub(/^\s+\|/, '') ,
                          |5 5
                          |0 0 N
                          |RMM
                          |1 0 E
                          |MMMM
                        END
                        RuntimeError
      end

      context 'when robots are placed over each other' do
        it_behaves_like 'a complaining application',
                        <<-END.gsub(/^\s+\|/, '') ,
                          |5 5
                          |0 0 E
                          |M
                          |0 0 N
                          |M
                        END
                        RuntimeError
      end
    end
    context 'when robots take turns' do
      let(:mode) { :turns }
      it_behaves_like 'a correct application',
                        <<-END.gsub(/^\s+\|/, '') ,
                          |5 5
                          |0 0 N
                          |RMM
                          |1 0 E
                          |MMMM
                        END
                        <<-END.gsub(/^\s+\|/, '')
                          |2 0 E
                          |5 0 E
                        END
    end
  end
end
