[![Gem Version](https://badge.fury.io/rb/simplestate.svg)](https://badge.fury.io/rb/simplestate) [![Build Status](https://travis-ci.org/dpneumo/simplestate.svg?branch=master)](https://travis-ci.org/dpneumo/simplestate)
[![Code Climate](https://codeclimate.com/github/dpneumo/simplestate/badges/gpa.svg)](https://codeclimate.com/github/dpneumo/simplestate)

## Ruby Version requirement: >= 2.1.0

# Simplestate
```ruby
class Button < StateHolder
  attr_reader :name
  def initialize(initial_state: :Off, state_history: StateHistory.new, opts: {})
    @name = opts.fetch :name
    super
  end

  def transition_to(state)
    super(state)
  end

  def prior_state
    history[-2] || :NullState
  end
end

class Off < State
  def press
    transition_to(:On)
  end

  private
    def enter
      buzz
      # turn_light_off
    end

    def exit
    end

    def buzz(sec: 0.5)
      # sound buzzer for sec seconds
    end
end

class On < State
  def press
    transition_to(:Off)
  end

  private
    def enter
      flash(3)
      # turn_button_light_on
    end

    def exit
    end

    def flash(n)
      # n.times { turn_button_light_on_then_off }
    end
end

button = Button.new(initial_state: :Off)
on_state =  On.new(holder: button)
off_state = Off.new(holder: button)

button.start    #=> current_state: Off
button.press    #=> current_state: On
button.press    #=> current_state: Off
```
# Description
Simplestate arose out of a desire for a very low ceremony mechanism to implement a state machine. SimpleDelegator (delegate.rb) is used to implement this. Because SimpleDelegator supports dynamically swapping the object to which methods are delegated, it provides a good base for Simplestate.

The current version (2.0.0) is a rewrite of SimpleState. State logic is provided via instances of the appropriate subclasses of State. A state is referenced via a symbol created by symbolizing the state's name. A list of state instances available for transitions is maintained by the state holder in a hash keyed on the state symbols. This is an incomplete variant of the singleton pattern. It solved some issues I was having with the previous version of SimpleState, but please use some care. For example, there is no logic to actually prevent creation of more than one instance of a given State subclass. Doing this would likely create bugs that will eventually bite you. :-(

The StateHolder class provides the required functionality for a basic state machine: methods to set the initial state and to transition to a new state. To complement this a State class is provided to serve as ancestor to the states of the state holder. A State instance stores a reference to the state holder and a private __#transition\_to__ method which simply calls the state holder’s __#transition\_to__.

StateHolder and State are not expected to be used directly. Rather, they are intended to be the ancestors of the actual state holder and states. A state should provide only methods that are unique to it. Methods that are not specific to a state should be provided by the state holder. The public methods of a child state act as receivers of event messages via delegation from the state holder. Such events may cause effects that are managed by the current state and may also cause transition to a new state. State change logic is expected to be held within the current state. Two private methods, __#enter__ and __#exit__, *must* be provided by each state. These are called by the state holder __#transition_to__ method at the appropriate points in the state life cycle. Neither __#enter__ nor __#exit__ nor any other private method of a state are intended to be called by a user of the state holder. To avoid potentially stepping on the user's code __#enter__ and __#exit__ are called with __\_\_send\_\___.

For convenience StateHolder provides instance methods, __#current_state__, __#history__, and __#hx_size_limit__ to provide easy access to the underlying method, __\_\_getobj\_\___ of SimpleDelegator, and to the read methods of the StateHistory container. The StateHistory container holds a list of the most recent state transitions from the state holder. Because the transition history could grow quite large that history is limited to the last 10 transitions by default. The history size limit may be changed via __#hx_size_limit__ at creation of the state holder. That limit may NOT be changed later

Simplestate does not provide a DSL for specifying the events, states and allowed state transitions. That logic must be specified within each state. Neither does Simplestate provide any mechanism for serialization. There is no "magic" here. It is just a couple of PORO's. As such, it is very easy to see and to reason about what is happening within Simplestate. It should not be too difficult to add serialization support to Simplestate.

As an aside, I have looked into providing the Simplestate functionality via a module. However, I found that the SimpleDelegator class provides delegation via a mechanism that makes a module based Simplestate implementation very difficult to achieve. The complexity of that implementation seemed to be not worth the effort. I think the [StatePattern](https://github.com/dcadenas/state_pattern) gem by Daniel Cadenas, the inspiration for Simplestate, ran into just this problem. I chose to avoid that issue by relying solely on inheritance.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simplestate'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install simplestate

## Usage

#### State Holder
Inherit from StateHolder to create the class of the object that will hold states. You may provide a default initial_state. You *must* call super if you provide an initialize method in your holder class:

```ruby
class Button < StateHolder
  attr_reader :color
  def initialize( initial_state: :Off, opts: {} )
    @color = opts.fetch :color
    super
  end

  # button methods here
end
```

Creation of a StateHolder instance *must* specify the initial state. StateHolder expects to receive the initial state as a symbol based on the state name. The name case is preserved in creating the symbol.:

```ruby
button = Button.new( initial_state: :Off )
```
If you want to set additional attributes at creation of a new button, do so within the opts hash when new is called. Set the attribute from the opts hash in initialize.

```ruby
button = Button.new( initial_state: :Off,
                     opts: {color: 'Red'} )
```

#### States

Inherit from State to create a class to provide specific state behaviors:

```ruby
class Off < State
  def press
    transition_to(:On)
  end

  def name
    'Off'
  end

private
  def enter
  end

  def exit
  end
end
```
The subclassed state must provide *private* __#enter__ and __#exit__ methods. Any other state methods intended to be available via a method call on the state holder must be public. The private methods, __#enter__ and __#exit__, will always be called appropriately during state transitions.

A state has access to methods on the state holder via __#holder__:

```ruby
holder.specialmethod
```

#### Usage Example
The button module (test/dummys/button.rb) provides an example of the usage of Simplestate. Tests of this are provided in button\_test.rb.

A working minimal example app is provided at ```https://github.com/dpneumo/simplestate-demo```

## Alternatives

If a DSL is desired, complex state functionality is required, events may arrive asynchronously from multiple sources, or state machine functionality must be provided via inclusion of a module rather than via inheritance then Simplestate is probably not appropriate. Consider looking at the [Statemachine](https://github.com/pluginaweek/state\_machine), [AASM](https://github.com/aasm/aasm) or [Workflow](https://github.com/geekq/workflow) gems. [The Ruby Toolbox](https://www.ruby-toolbox.com/categories/state\_machines.html) provides links to several other statemachine implementations.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

StateHolderInterfaceTest and StateInterfaceTest are provided to verify that your state holder and state instances respond to the minimum required method calls for each. Simply include these in the tests of your decendents of StateHolder and State and in any dummies of these classes you may use in your tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dpneumo/simplestate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

