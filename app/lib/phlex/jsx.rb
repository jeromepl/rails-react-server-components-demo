# frozen_string_literal: true

require "async"
require "stringio"

module Phlex
  # @abstract Subclass and define {#template} to create an HTML component class.
  class JSX < SGML
    include Elements
    include Helpers

    include HtmlElements
    include ReactComponents

    class RootElementError < StandardError
      include Phlex::Error
    end

    def call(buffer = nil, context: nil, view_context: nil, stream: view_context&.response&.stream || StringIO.new, parent: nil, &block)
      super(buffer || Buffer.new(stream), context: context || Context.new, view_context:, parent:, &block)
    end

    def __final_call__(buffer = nil, context: nil, view_context: nil, stream: view_context&.response&.stream || StringIO.new, parent: nil, &block)
      super(buffer || Buffer.new(stream), context: context || Context.new, view_context:, parent:, &block)
    end

    def yield_content(...)
      @_context.yield_content(...)
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
        super(renderable, &block)
      end
    end

    # Method called by Rails when calling `render MyComponent.new` from a controller
    def render_in(view_context, &block)
      Sync do # Wrap in a Sync block to let all Async components finish rendering before closing the stream
        super(view_context, &block)
      end
    end

    def format
      self.class.format
    end

    def self.format
      :text
    end
  end
end
