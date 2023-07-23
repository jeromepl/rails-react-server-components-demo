# frozen_string_literal: true

class Component
  def render(_jsx)
    raise NoMethodError, "#render method must be defined in Components"
  end

  class << self
    def render(jsx, ...)
      new(...).render(jsx)
    end

    # FIXME:
    def async_render(engine, eval_stack, ...)
      reference = engine.add_async_component(eval_stack, self, ...)
      eval_stack.last << reference
      reference
    end
  end
end
