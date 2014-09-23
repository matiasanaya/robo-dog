require_relative '../lib/robotic_sheep_dog/application'

RSpec.describe RoboticSheepDog::Application do
  describe 'the public interface' do
    it { expect(described_class).to respond_to :build }
    subject{ described_class.new }
    it { is_expected.to respond_to :run }
  end

  describe '.build' do
    it 'returns a instance of self' do
      expect(described_class.build).to be_instance_of described_class
    end
    it 'builds with default Parser' do
      expect(described_class.build.instance_variable_get(:@parser)).to eql RoboticSheepDog::Parser
    end
    it 'builds with default Simulation Class' do
      expect(described_class.build.instance_variable_get(:@simulation_class)).to eql RoboticSheepDog::Simulation
    end
    it 'builds with correct input' do
      expect(described_class.build('Hello World').instance_variable_get(:@input)).to eql 'Hello World'
    end
  end
end
