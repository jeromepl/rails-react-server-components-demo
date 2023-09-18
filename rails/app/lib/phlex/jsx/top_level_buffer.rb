# frozen_string_literal: true

require "async"

module Phlex
  class JSX
    class TopLevelBuffer
      attr_reader :stream

      def initialize(stream)
        @stream = stream
        @index = 1 # Keep 0 for the top level element
      end

      # Given this is the top level buffer, this method should only be called once, with
      # the top level element
      def <<(context_elements)
        # FIXME: Index 0 is not correct for Async components being rendered. It should use the index from #async method below
        index = context_elements.size > 1 ? 4 : 0 # FIXME: Fix this hardcoded hack
        stream.write("#{index}:#{context_elements.last.to_json}\n")
        ""
      end
      alias_method :write, :<<

      def write_react_component(tag, webpack_definition)
        @write_react_component ||= {}
        @write_react_component[tag] ||= begin
          index = next_index
          stream.write("#{index}:I#{webpack_definition.to_json}\n")
          "$L#{index}"
        end
      end

      def write_suspense
        @write_suspense ||= begin
          index = next_index
          stream.write("#{index}:\"$Sreact.suspense\"\n")
          "$#{index}"
        end
      end

      def async(&block)
        index = next_index
        Async do
          # TODO: This `index` needs to be re-used later when writing the top-level component
          block.call
        end
        "$L#{index}"
      end

      private

      def next_index
        next_i = @index
        @index += 1
        next_i
      end
    end
  end
end
