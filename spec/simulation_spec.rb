require_relative '../lib/robo_dog/simulation'

RSpec.describe RoboDog::Simulation do
  describe 'the public interface' do
    subject{ described_class.new }
    it { is_expected.to respond_to :run, :report, :valid_coordinates? }
  end

  let(:simulation) { described_class.new(robots: robots) }

  describe '#run' do
    let(:robots) do
      _robots = [double, double]
      _robots.each_with_index do |robot, i|
        allow(robot).to receive(:add_coordinator)
        allow(robot).to receive(:coordinates).and_return(i)
        allow(robot).to receive(:execute).with(:all)
      end
      _robots
    end

    context 'with valid coordiantes for robots' do
      it 'commands robots to add self as coordinator' do
        robots.each_with_index do |robot, i|
          expect(robot).to receive(:add_coordinator)
        end

        simulation.run
      end

      it 'executes each robot' do
        robots.each_with_index do |robot, i|
          expect(robot).to receive(:execute).with(:all)
        end

        simulation.run
      end
    end

    context 'with robots placed on top of each other' do
      let(:robots) do
      _robots = [double, double]
      _robots.each do |robot|
        allow(robot).to receive(:coordinates).and_return(1)
      end
      _robots
    end
      it 'fails' do
        expect { simulation.run }.to raise_exception RuntimeError
      end
    end
  end

  describe '#report' do
    let(:robot_double) do
      dbl = double
      allow(dbl).to receive(:add_coordinator)
      allow(dbl).to receive(:report).and_return('robot report')
      dbl
    end

    let(:robots) { [robot_double] }

    subject { simulation.report }

    it 'returns a hash' do
      is_expected.to be_instance_of Hash
    end

    it "includes robot's reports" do
      is_expected.to include robots: ['robot report']
    end
  end

  describe '#valid_coordinates?' do

    let(:simulation) { described_class.new(robots: [robot], paddock: paddock) }

    let(:paddock) { double }
    let(:robot) do
      dbl = double
      allow(dbl).to receive(:add_coordinator)
      dbl
    end

    context 'without coordinates object' do
      it 'fails' do
        expect { simulation.valid_coordinates?(nil) }.to raise_exception RuntimeError
      end
    end

    context 'with coordinates object' do

      context 'with invalid paddock coordinates' do
        let (:paddock) do
          dbl = double
          allow(dbl).to receive(:valid_coordinates?).and_return(false)
          dbl
        end

        it 'fails' do
          expect { simulation.valid_coordinates?('some coordinates') }.to raise_exception RuntimeError
        end
      end

      context 'with valid paddock coordinate' do
        let (:paddock) do
          dbl = double
          allow(dbl).to receive(:valid_coordinates?).and_return(true)
          dbl
        end

        context 'with no other robot in coordinates' do
          it 'returns truthy' do
            allow(robot).to receive(:coordinates).and_return('some coordinate')

            expect(simulation.valid_coordinates?('other coordinates')).to be_truthy
          end
        end

        context 'with other robot in coordinates' do
          it 'fails' do
            allow(robot).to receive(:coordinates).and_return('same coordinates')

            expect { simulation.valid_coordinates?('same coordinates') }.to raise_exception RuntimeError
          end
        end
      end
    end
  end
end
