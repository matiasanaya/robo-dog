require_relative '../../lib/robotic_sheep_dog/application'
require 'stringio'

RSpec.describe RoboticSheepDog::Application do

  let(:app) { lambda { |input_stream| RoboticSheepDog::Application.build(input_stream).run } }

  context 'when input is provided' do
    it 'prints the correct output' do
      input = <<-END.gsub(/^\s+\|/, '')
        |5 5
        |1 2 N
        |LMLMLMLMM
        |3 3 E
        |MMRMMRMRRM
      END

      correct_output = <<-END.gsub(/^\s+\|/, '')
        |1 3 N
        |5 1 E
      END

      expect { app.call(StringIO.new(input)) }.to output(correct_output).to_stdout
    end
  end
end
