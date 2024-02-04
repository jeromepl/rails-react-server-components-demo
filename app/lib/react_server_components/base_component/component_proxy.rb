# frozen_string_literal: true

module ReactServerComponents
  class BaseComponent
    # This class is used to capture "rendered slots", i.e. components that should be
    # rendered then passed as props to the front-end React component.
    # For example, we have to allow any "slots" and render them as props
    # This allows passing components to a prop, for example to a Suspense component's fallback:
    # > suspense do |c|
    # >   c.fallback { strong { "Loading..." } } # `fallback` is a rendered slot
    # > end
    class ComponentProxy < BaseComponent
      attr_reader :allow_slots
      
      def initialize(allow_slots: false)
        @allow_slots = allow_slots
      end

      def method_missing(m, *args, &block)
        return unless allow_slots
        return super unless block_given?

        _rendered_slots[m] = yield_content(&block)
      end

      def respond_to_missing(method_name, include_private = false)
        allow_slots || super
      end

      def _rendered_slots
        @rendered_slots ||= {}
      end
    end
  end
end
