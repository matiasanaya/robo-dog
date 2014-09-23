robo-dog
=========

Fredwina the Farmer's robotic sheep dog simulator.

## Installation

via RubyGems:

    $ gem install robodog


## Usage

Pipe in a file with simulation parameters:

    $ robodog < path/to/file

An example file:

    5 5
    1 2 N
    LMLMLMLMM
    3 3 E
    MMRMMRMRRM

To which the application prints:

    1 3 N
    5 1 E

More example files can be found at `data/`

## Dependencies

    ruby version ~> 2.1.0p0

To check your version run:

    $ ruby -v

To learn how to install ruby visit [ruby-lang.org/en/installation/](https://www.ruby-lang.org/en/installation/)

## Troubleshooting

### Development environment

 * OSX 10.8.5, ruby 2.1.2p95

Development dependencies:

    rspec ~> 3.1

To install them along the gem:

    $ gem install --dev robodog

### Compatible environments

* Ubuntu 12.04 x32, ruby 2.1.0p0

### Incompatible environments

* ruby < 2.1.0

### Tests

To run the specs:

    $ rspec

To run just the integration tests:

    $ rspec spec/features

## Overview

The application is designed to read simulation parameters from `$stdin` and print the output to `$stdout`.

### Input Format

The application expects input containing a description of the paddock on which the robotic sheep dogs are to move, and a description of each robotic sheep dogs. The description of each robotic sheep dog has two parts in itself. It must contain a starting position and a sequence of commands to execute.

#### Paddock

The paddock description must contain two integers separated by a space, as follows:

    <x_size> <y_size>

These two integers represent the dimensions of a square paddock.

Example:

    5 5

Only one paddock description is allowed per input.

#### Robot

The robot part of the input is expected to have a starting position, and a sequence of commands it will execute. There is no limit as to the amount of robots accepted.

##### Position

This piece of the input is expected to contain two space-separated integers, plus a space-separated cardinal orientation represented by the strings `N`, `E`, `S` and `W`. The general structure is as follows:

    <x_coordinate> <y_coordinate> <cardinal_orientation>

* The spaces are validated by the application and thus required.
* The `<cardinal_orientation>` is case sensitive.

Example:

    1 2 N

##### Commands

The commands represent a sequence of instructions that the robot will follow in order. The valid commands are `M`, `R` and `L`:

    M # stands for Move and will make the robot advance one position in the direction its facing

    R # stands for Right and will make the robot rotate its orientation 90 degrees clockwise

    L # stands for Left and will make the robot rotate its orientation 90 degrees counter-clockwise

* The commands should be concatenated into a single string
* The commands are case sensitive
* Non-valid commands will make the application fail.

Example:

    LMRLMRLMRLR

### Output Format

The simulation's final state will be printed as a results of the application running. The state is represented by the end position of each of the robots. A line is printed per robot and this line follows the same format as the input position line `<x_coordinate> <y_coordinate> <cardinal_orientation>`.

Example:

    1 3 N
    5 1 E

### Constraints

Sheepdogs are not permitted to bump into each other or run each other over. The program fails at runtime if this happens. Specifically the program will fail if:

* Two robots are placed on the same starting position.
* A robot moves into another robot's position.
* A robot tries to move beyond the paddock's limit.

In case the simulation fails, the following message will be printed:

    Invalid coordinates. This means two robots collided or a robot hit the border of the paddock. (RuntimeError)

## Design

The application flows in the following way:

#### 1 Launch

    $ robodog < data/valid_example_input_a.txt

##### 1.1 bin/robodog

The `robodog` in the command is a ruby executable in your load path. This executable contains the following lines:

```ruby
require 'robo_dog'
RoboDog::Application.build.run
```

The first line requires the file `./lib/robo_dog.rb` which loads the library. The second line creates and instance of the application and runs it.

##### 1.2 lib/robo_dog/application.rb

The `#run` method starts by delegating the input parsing to the `parser` object. The `input` by default is `$stdin`.

```ruby
def run(mode = nil)
  simulation_attrs = parser.parse(input)
  simulation = simulation_class.new(simulation_attrs)

  simulation.run(mode)
  puts format(simulation.report)
end
```

The parser line is:

```ruby
simulation_attrs = parser.parse(input)
```

##### 1.2.1 lib/robo_dog/parser.rb

```ruby
def parse(input)
  paddock = @paddock_parser.call(input)
  robots = []
  loop do
    robot_attrs = @robot_extractor.call(input)
    break unless robot_attrs
    robots << @robot_factory.build(robot_attrs)
  end
  {
    paddock: paddock,
    robots: robots
  }
end
```

The parser knows how to extract the paddock and robot attributes for the simulation. It actually delegates the building of these objects to the `Paddock` and `Robot` class themselves, but extracts the string from the input stream. The first delegation occurs at:

```ruby
robots << @robot_factory.build(robot_attrs)
```

The `@robot_factory` object is actually the `Robot` class which knows how to build a instance of itself from the `robot_attrs`.

After all the parsing is done, this function returns a hash with the correct objects in `:paddock` and `:robots` (an Array of robots)

##### 1.2.2 lib/robo_dog/simulation.rb

Next in application.rb is:

```ruby
simulation.run(mode)
```

The `#run` message to `Simulation` is responsible for coordinating the robots on the paddock. It has two run modes: `:sequential` and `:turns`.

```ruby
def run(mode = :sequential)
  mode ||= :sequential
  warm_up
  case mode
  when :sequential
    robots.each { |r| r.execute(:all) }
  when :turns
    run_in_turns
  end
end
```

* In `:sequential` mode each robot will execute all of its commands at once.
* In `:turns` mode robots will take turns executing one command at a time.

This method messages each `Robot` to `#execute`. This guide will not cover how `#execute` is implemented. Just bear in mind that robots can move and rotate, while these movements need to be coordinated to avoid robots running over each other.

##### 1.2 lib/robo_dog/application.rb

Once the simulation has run, all that remains is to print the output. This output is formated by the `Application` class and then printed to `$stdout`.

```ruby
puts format(simulation.report)
```

#### 2 Exit

After the output is printed, the application exits.

## Discussion

My main design decisions / concerns in no specific order are the following.

#### Placing

There is no specification as to the order of the placing of the robots on the paddock. This application assumes that all robots are placed first, failing if they are placed on the same coordinates, and then the commands are executed according to the selected run mode.

#### Run Mode

The application has `:sequential` and `:turns` (beta, no command-line support) mode. Should the robots run the commands in turns or all at once?

This is a relevant question to ask since for the same input file, one run mode might fail while the other one might be successful. There are a couple of examples of these circumstance in `spec/features/robo_dog_spec.rb`

This issue addresses specifically the case when you order a robot to chase another one. If run sequentially, the first robot will run over the second one. If run in turns, the intended outcome will happen.

#### Failing

While the original spec specifies that the application should fail if robots run over each other, it does not specify how or when. In this implementation the application will fail when robots run the following line:

```ruby
self.pose = adj_pose if coordinators.all? { |c| c.valid_coordinates?(adj_pose.coordinates) }
```

since `#valid_coordinates?` is:

```ruby
def valid_coordinates?(coordinates)
  coordinates &&
  paddock.valid_coordinates?(coordinates) &&
  robots.all? { |r| r.coordinates != coordinates } ||
  fail_appropriately
end
```

My concern about this decision is that `#valid_coordinates?` failing is not clear enough, this method should return either `true` or `false`. The alternative here is to simply advance the pose, and let know the observer (aka the `Simulation`) of what happened, and the application should fail there.

In the end the existing approach seemed more sensible because it stops the application in a pre-fail state which can be inspected, and is more flexible in case a decision is made in the future by which robots should just ignore commands that would send them into a invalid coordinate.

## Contributing

View [CONTRIBUTING.md](https://github.com/matiasanaya/robo-dog/blob/master/CONTRIBUTING.md)
