# frozen_string_literal: true

module Phlex
  class JSX
    module ReactComponents
      extend Elements

      FrontendRegistry::COMPONENTS.each do |component_name, webpack_definition|
        register_react_component(component_name, webpack_definition)
      end

      # Suspense is a component available by default in RSC
      register_suspense

      # For React components, we allow any "slots" and render them as props
      # This allows passing JSX to a prop, for example to a Suspense component's fallback:
      # > suspense do |c|
      # >   c.fallback { strong { "Loading..." } }
      # > end
      def method_missing(m, *args, &block)
        return super unless block_given?

        @_context.add_react_slot(self, m, &block)
      end
    end
  end
end
