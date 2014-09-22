require_relative '../lib/robotic_sheep_dog/robot'

RSpec.describe RoboticSheepDog::Robot do
  describe 'the public interface' do
    subject{ described_class.new }
    it { is_expected.to respond_to :execute, :report, :coordinates, :move, :right, :left }
  end

  let(:robot) do
    described_class.new(
      pose: pose,
      commands: commands,
      coordinator: coordinator
    )
  end

  let(:pose) { double }
  let(:commands) { [] }
  let(:coordinator) { double }

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
      allow(dbl).to receive(:adjacent).and_return('adjacent pose')
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
