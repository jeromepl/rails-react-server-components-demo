# frozen_string_literal: true

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
        stream.write("0:#{context_elements.first.to_json}\n")
        stream.string # TODO: Remove?
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

      private

      def next_index
        next_i = @index
        @index += 1
        next_i
      end
    end
  end
end
