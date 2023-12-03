# frozen_string_literal: true

module Phlex
  class JSX
    class Context < Phlex::Context
      def initialize
        super
        @target = []
        @react_slots_target = nil
      end

      def yield_content(kaller, react_slots_target: nil, &block)
        wrap_with_react_slots_target(react_slots_target) do
          content_target = []
          content_string = nil
          capturing_into(content_target) { content_string = block.call(kaller) } if block_given?
          content_target << content_string if content_string.is_a?(String)
          content_target
        end
      end

      # TODO: How to clean up the caller syntax? Move to the JSX class?
      def add_react_slot(kaller, slot_name, &)
        raise(Phlex::NameError.new("Called `##{slot_name}` but this element does not support slots")) if @react_slots_target.nil?

        @react_slots_target[slot_name] = yield_content(kaller, &)
      end

      private

      def wrap_with_react_slots_target(react_slots_target)
        previous_react_slots_target = @react_slots_target
        @react_slots_target = react_slots_target
        yield
      ensure
        @react_slots_target = previous_react_slots_target
      end
    end
  end
end
