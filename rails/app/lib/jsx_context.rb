# frozen_string_literal: true

class JsxContext
  attr_accessor :global_index

  attr_reader :stream, :top_level, :stack

  def initialize(stream)
    @stream = stream
    @global_index = 1 # Keep 0 for the top-level component
    @top_level = true
    @stack = [[]]
  end

  def render(component)
    output = component.render(self)
    stream.write("0:#{output.to_json}\n") if top_level
    output
  end

  def async(component)
    index = next_index
    Async do
      # FIXME: Thread safe stack
      output = component.render(self)
      stream.write("#{index}:#{output.json}\n")
    end
    "$L#{index}"
  end

  def method_missing(method_name, *_args, **props, &)
    reference = begin
      if FrontendRegistry::Components.key?(method_name.to_sym)
        frontend_component(method_name.to_s, FrontendRegistry::Components[method_name.to_sym])
      else # html component
        method_name.to_s
      end
    end

    output = component(reference, **props, &)
    stream.write("0:#{output.to_json}\n") if top_level
    stack.last << output
  end

  def respond_to_missing?(_method_name, _include_private = false)
    true
  end

  private

  def next_index
    value = global_index
    @global_index = global_index + 1
    value
  end

  def frontend_component(tag, webpack_definition)
    @frontend_component ||= {}
    @frontend_component[tag] ||= begin
      index = next_index
      stream.write("#{index}:I#{webpack_definition.to_json.gsub("\\", "")}\n")
      "$L#{index}"
    end
  end

  def suspense
    @suspense ||= begin
      index = next_index
      stream.write("#{index}:\"$Sreact.suspense\"\n")
      "$#{index}"
    end
  end

  def component(reference, **props, &)
    # clean_props(**props) # FIXME: Using jsx as props is not working as expected... results in an infinite loop

    children = eval_children(&) if block_given?
    props = {
      **{ children: }.compact_blank,
      **props
    }

    key = props.delete(:key)
    ["$", reference, key, props]
  end

  # Remove elements from the array at the top of the stack when they are used as props
  # FIXME: This doesn't work if a component is used exactly the same way 2 times
  def clean_props(**props)
    props.each_value do |prop_value|
      stack.last.delete(prop_value)
    end
  end

  def eval_children(&)
    original_top_level = top_level
    @top_level = false
    stack.push([])
    block_output = yield
    children = stack.pop
    @top_level = original_top_level
    children.empty? ? block_output : children
  end
end
