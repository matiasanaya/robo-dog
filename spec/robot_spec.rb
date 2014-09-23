require_relative '../lib/robotic_sheep_dog/robot'

RSpec.describe RoboticSheepDog::Robot do
  describe 'the public interface' do
    it { expect(described_class).to respond_to :build }
    subject{ described_class.new }
    it { is_expected.to respond_to :execute, :report, :coordinates, :move, :right, :left, :add_coordinator }
  end

  describe '.build' do
    context 'with invalid data' do
      let(:data) { {commands: 'wrong'} }
      it 'screams at you' do
        expect { described_class.build(data) }.to raise_exception described_class::DataError
      end
    end
    context 'with valid data' do
      let(:data) do
        {
          commands: 'LRMR',
          pose: '0 0 N'
        }
      end
      it 'returns a instance of self' do
        expect(described_class.build(data)).to be_instance_of described_class
      end
      it 'builds with correct commands' do
        expect(described_class.build(data).instance_variable_get(:@commands)).to be == [:left, :right, :move, :right]
      end
      it 'delegates pose building' do
        expect(RoboticSheepDog::Pose).to receive(:build).with(data[:pose])
        described_class.build(data)
      end
    end
  end

  let(:robot) do
    described_class.new(
      pose: pose,
      commands: commands,
      coordinators: [coordinator]
    )
  end

  let(:pose) { double }
  let(:commands) { [] }
  let(:coordinator) { double }

  describe '#add_coordinator' do
    it 'adds a coordinator to the coordinators array' do
      robot.add_coordinator('a added coordinator')
      expect(robot.instance_variable_get(:@coordinators)).to include 'a added coordinator'
    end
  end

  describe '#execute' do
    let(:commands) { [:left, :move, :left, :right] }

    context 'with :all' do
      it 'executes all commands' do
        expect(robot).to receive(:left).ordered
        expect(robot).to receive(:move).ordered
        expect(robot).to receive(:left).ordered
        expect(robot).to receive(:right).ordered

        robot.execute(:all)
      end

      it 'empties the commands' do
        allow(robot).to receive_messages(left: nil, move: nil, right: nil)
        robot.execute(:all)
        expect(robot.instance_variable_get(:@commands)).to be_empty
      end
    end

    context 'with :next' do
      it 'executes the next command' do
        expect(robot).to receive(:left)

        robot.execute(:next)
      end

      it 'removes the first command' do
        allow(robot).to receive(:left)
        robot.execute(:next)
        expect(robot.instance_variable_get(:@commands)).to match_array [:move, :left, :right]
      end
    end
  end

  describe '#report' do
    let(:pose) do
      dbl = double
      allow(dbl).to receive(:report).and_return('some report')
      dbl
    end

    it "returns pose's report" do
      expect(robot.report).to match('some report')
    end
  end

  describe '#coordinates' do
    let(:pose) do
      dbl = double
      allow(dbl).to receive(:coordinates).and_return('some coordinates')
      dbl
    end

    it "returns pose's coordinates" do
      expect(robot.coordinates).to match('some coordinates')
    end
  end

  describe '#move' do
    let(:pose) do
      dbl = double
      adj_pose = 'adjacent pose'
      allow(adj_pose).to receive(:coordinates).and_return('some coordinates')
      allow(dbl).to receive(:adjacent).and_return(adj_pose)
      dbl
    end

    let(:coordinator) do
      dbl = double
      allow(dbl).to receive(:valid_coordinates?).and_return(coordinator_return)
      dbl
    end

    let(:coordinator_return) { [true, false].sample }

    it 'returns nil' do
      expect(robot.move).to be_nil
    end

    context 'with valid adjacent pose' do
      let(:coordinator_return) { true }
      it 'updates its pose' do
        robot.move
        expect(robot.instance_variable_get(:@pose)).to eql('adjacent pose')
      end
    end

    context 'with invalid adjacent pose' do
      let(:coordinator_return) { false }
      it 'does not update its pose' do
        robot.move
        expect(robot.instance_variable_get(:@pose)).to eql(pose)
      end
    end
  end

  describe '#right' do
    it 'rotates its pose' do
      expect(pose).to receive(:rotate!).with(:clockwise)
      robot.right
    end
  end

  describe '#left' do
    it 'rotates its pose' do
      expect(pose).to receive(:rotate!).with(:counter)
      robot.left
    end
  end
end
