require_relative '../lib/robotic_sheep_dog/simulation'

RSpec.describe RoboticSheepDog::Simulation do
  describe 'the public interface' do
    subject{ described_class.new }
    it { is_expected.to respond_to :run, :report, :valid_coordinates? }
  end

  let(:simulation) { described_class.new(robots: robots) }

  describe '#run' do
    let(:robots) { [double, double] }
    it 'executes each robot' do
      robots.each do |robot|
        allow(robot).to receive(:add_coordinator)
        expect(robot).to receive(:execute).with(:all)
      end

      simulation.run
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
      it 'returns nil' do
        expect(simulation.valid_coordinates?(nil)).to be_falsy
      end
    end

    context 'with coordinates object' do

      context 'with invalid paddock coordinates' do
        let (:paddock) do
          dbl = double
          allow(dbl).to receive(:valid_coordinates?).and_return(false)
          dbl
        end

        it 'returns falsy' do
          expect(simulation.valid_coordinates?('some coordinates')).to be_falsy
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
          it 'returns falsy' do
            allow(robot).to receive(:coordinates).and_return('same coordinates')

            expect(simulation.valid_coordinates?('same coordinates')).to be_falsy
          end
        end
      end
    end
  end
end
