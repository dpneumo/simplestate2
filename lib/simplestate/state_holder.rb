class StateHolder < SimpleDelegator
  attr_reader :initial_state, :state_history

  def initialize(initial_state:, state_history: StateHistory.new, opts: {})
    @initial_state = initial_state
    @state_history = state_history
    @state_list = StateList.new

    super(NullState.new(holder: self))
  end

  def start
    state_history << current_state.symbol
    transition_to(initial_state)
  end

  def transition_to(state)
    leave_old_state
    enter_new_state(state)
  end

  # Convenience methods
  def current_state
    __getobj__
  end

  def history
    state_history.list
  end

  def hx_size_limit
    state_history.hx_size_limit
  end

  private
    attr_reader :state_list
    def leave_old_state
      current_state.__send__(:exit)
    end

    def enter_new_state(state)
      self.current_state = state
      state_history << current_state.symbol
      current_state.__send__(:enter)
    end

    def current_state=(state)
      state_obj = state_list[state]
      __setobj__(state_obj)
    end

    def add_state(state_instance)
      state_list.add state_instance
    end
end
