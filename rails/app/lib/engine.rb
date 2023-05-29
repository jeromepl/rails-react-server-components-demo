# frozen_string_literal: true

class Engine
  attr_accessor :global_index
  attr_accessor :frontend_components_queue
  attr_accessor :async_components_queue

  def initialize
    @global_index = 0
    @frontend_components_queue = []
    @async_components_queue = []
  end

  def next_index
    value = global_index
    @global_index = global_index + 1
    value
  end

  def add_frontend_component(tag, webpack_definition)
    @frontend_components_cache ||= {}
    @frontend_components_cache[tag] ||= begin
      index = next_index
      value = "#{index}:I#{webpack_definition.to_json.gsub("\\", "")}"
      frontend_components_queue << value
      "$L#{index}"
    end
  end

  def add_suspense_component
    index = next_index
    value = "#{index}:\"$Sreact.suspense\""
    frontend_components_queue << value
    "$#{index}"
  end

  def add_async_component(eval_stack, component_klass, **props, &children)
    self.class.clean_props(eval_stack, **props)

    index = next_index
    # TODO: Can we start the async process right here?
    value = -> { component_klass.render(self, [[]], **props, &children) }
    async_components_queue << {
      index:,
      value:
    }
    "$L#{index}"
  end

  # Remove elements from the array at the top of the stack
  # when they are used as props (detect them through kwargs here?)
  # FIXME: This doesn't work if a component is used exactly the same way 2 times
  def self.clean_props(eval_stack, **props)
    props.each_value do |prop_value|
      eval_stack.last.delete(prop_value)
    end
  end
end
