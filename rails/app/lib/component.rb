# frozen_string_literal: true

class Component
  include FrontendComponentRegistry

  attr_reader :engine, :eval_stack

  def initialize(engine, eval_stack)
    @engine = engine
    @eval_stack = eval_stack
  end

  def render
    raise NoMethodError, "#render method must be defined in Components"
  end

  def method_missing(method_name, *_args, **kwargs, &)
    # If we get here then we assume this we have an HTML5 component
    self.class.eval(eval_stack, method_name.to_s, **kwargs, &)
  end

  def respond_to_missing?(_method_name, _include_private = false)
    true
  end

  class << self
    def render(engine, eval_stack, ...)
      new(engine, eval_stack, ...).render
    end

    def async_render(engine, eval_stack, ...)
      reference = engine.add_async_component(eval_stack, self, ...)
      eval_stack.last << reference
      reference
    end

    def eval(eval_stack, reference, **props, &children)
      Engine.clean_props(eval_stack, **props) # TODO: Move this method

      children = eval_children(eval_stack, &children) if block_given?
      props = {
        **{ children: }.compact_blank,
        **props
      }

      key = props.delete(:key)
      output = ['$', reference, key, props]
      eval_stack.last << output
      output
    end

    def eval_children(eval_stack, &children)
      eval_stack.push([])
      output = children.call
      children = eval_stack.pop
      children.empty? ? output : children
    end
  end
end
