# frozen_string_literal: true

module Phlex
  class JSX
    module ReactComponents
      extend Elements

      FrontendRegistry::Components.each do |component_name, webpack_definition|
        register_react_component(component_name, webpack_definition)
      end
    end
  end
end
