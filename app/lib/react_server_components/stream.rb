# frozen_string_literal: true

require "async"

module ReactServerComponents
  class Stream
    TOP_LEVEL_INDEX_KEY = :__rsc_stream_top_level_index
    private_constant :TOP_LEVEL_INDEX_KEY

    attr_reader :output_stream

    def initialize(output_stream)
      @output_stream = output_stream
      @index = 1 # Keep 0 for the top level element
    end

    # Given this stream is used to render "root" elements to the output_stream directly,
    # this method should only be called once, with only the top level element
    def <<(context_target)
      raise RootElementError, "Expected to render a single root element but found #{context_target.size} elements at the root" if context_target.size != 1

      index = Thread.current[TOP_LEVEL_INDEX_KEY] || 0
      output_stream.write("#{index}:#{context_target.last.to_json}\n") # Use the last element as top level element
      ""
    end
    alias_method :write, :<<

    # When using a new react component, we need to send through the output_stream the webpack definition
    # of this component, which contains the name, file path and chunk id of this component
    def write_react_component(tag, webpack_definition)
      @write_react_component ||= Concurrent::Map.new
      @write_react_component[tag] ||= begin
        index = next_index
        output_stream.write("#{index}:I#{webpack_definition.to_json}\n")
        "$L#{index}"
      end
    end

    def write_suspense
      @write_suspense ||= begin
        index = next_index
        output_stream.write("#{index}:\"$Sreact.suspense\"\n")
        "$#{index}"
      end
    end

    # Start a new async process to render an async component (the block) and send through
    # the output_stream a placeholder index that React will replace on the front-end once it receives
    # the fully rendered data for this index.
    def async(&block)
      index = next_index
      Async do
        Thread.current[TOP_LEVEL_INDEX_KEY] = index
        block.call
      end
      "$L#{index}" # Placeholder used by React for the async component
    end

    private

    def next_index
      next_i = @index
      @index += 1
      next_i
    end
  end
end
