# Designed to match the public interface of decendents of StateHolder
class DummyStateHolder
  attr_reader :initial_state, :state_history

  def initialize(initial_state: 'DummyState', state_history: StateHistory.new, opts: {})
    @initial_state = initial_state
    @state_history = []
    @current_state = 'DummyState'
  end

  def start
  end

  def transition_to(new_state_name)
    @current_state = new_state_name
  end

  def current_state
    @current_state
  end

  def history
    []
  end

  def hx_size_limit
    1
  end

  private
    def add_state(state_instance)
    end
end
