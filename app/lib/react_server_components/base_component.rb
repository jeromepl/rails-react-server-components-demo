# frozen_string_literal: true

require "async"
require "phlex"

module ReactServerComponents
  class BaseComponent
    include ElementsRegistry

    def template
      yield(self)
    end

    def call(buffer, context: Context.new, view_context: nil, parent: nil, &block)
      @_buffer = buffer
			@_context = context
			@_view_context = view_context
			@_parent = parent

      content_string = template(&block)
      # Allow rendering a simple string as long as it's last line of the block:
      @_context.target << content_string if content_string.is_a?(String)

      @_buffer << @_context.target unless @_parent
    end

    def render(renderable, &block)
      case renderable
      when AsyncRender
        reference = @_buffer.async do
          # Not passing `parent:` indicates that this component should be written to the stream as a separate entry
          renderable.call(@_buffer, context: Context.new, view_context: @_view_context, &block)
        end
        @_context.target << reference # Put the placeholder of the async component
        nil
      else
        renderable.call(@_buffer, context: @_context, view_context: @_view_context, parent: self, &block)
      end
    end

    def yield_content(&block)
      @_context.capturing_into([], &block)
    end

    # Method called by Rails when calling `render MyComponent.new` from a controller
    def render_in(view_context, &block)
      Sync do # Wrap in a Sync block to let all Async components finish rendering before closing the stream
        call(Stream.new(view_context.response.stream), view_context: view_context, &block)
      end
    end

    # Also called by Rails when calling `render MyComponent.new`, to set the response format automatically
    def format
      :text
    end

    private

    Phlex::HTML::VoidElements.registered_elements.each_pair do |method_name, tag|
      register_html_element(method_name, tag:)
    end
    Phlex::HTML::StandardElements.registered_elements.each_pair do |method_name, tag|
      register_html_element(method_name, tag:)
    end
    FrontendRegistry::COMPONENTS.each do |component_name, webpack_definition|
      register_react_component(component_name, webpack_definition:)
    end
    # Suspense is a component available by default in RSC:
    register_suspense
  end
end
