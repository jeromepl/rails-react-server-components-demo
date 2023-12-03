# frozen_string_literal: true

module Phlex
  class JSX
    module Elements
      def self.included(base)
        base.extend ClassMethods
      end

      def _render_to_react_stream_format(reference, attributes: {}, use_slots: false, &block)
        rendered_slots = {}
        children = yield_content(react_slots_target: use_slots ? rendered_slots : nil, &block) if block_given?

        props = {
          **attributes,
          **rendered_slots,
          **{ children: }.compact_blank,
        }
        key = props.delete(:key)

        @_context.target << ["$", reference, key, props]

        nil
      end

      module ClassMethods
        # @api private
        def registered_elements
          @registered_elements ||= Concurrent::Map.new
        end

        def register_react_component(component_name, webpack_definition)
          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def #{component_name}(**attributes, &block)
              reference = @_buffer.write_react_component("#{component_name}", #{webpack_definition})
              _render_to_react_stream_format(reference, attributes:, use_slots: true, &block)
            end
          RUBY

          registered_elements[component_name] = component_name
        end

        def register_suspense
          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def suspense(**attributes, &block)
              reference = @_buffer.write_suspense
              _render_to_react_stream_format(reference, attributes:, use_slots: true, &block)
            end
          RUBY

          registered_elements["suspense"] = "suspense"
        end

        # Register a custom element. This macro defines an element method for the current class and descendents only. There is no global element registry.
        # @param method_name [Symbol]
        # @param tag [String] the name of the tag, otherwise this will be the method name with underscores replaced with dashes.
        # @return [Symbol] the name of the method created
        # @note The methods defined by this macro depend on other methods from {SGML} so they should always be mixed into an {HTML} or {SVG} component.
        # @example Register the custom element `<trix-editor>`
        # 	register_html_element :trix_editor
        def register_html_element(method_name, tag: nil)
          tag ||= method_name.name.tr("_", "-")

          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def #{method_name}(**attributes, &block)
              _render_to_react_stream_format("#{tag}", attributes:, &block)
            end
          RUBY

          registered_elements[method_name] = tag
          method_name
        end
        alias_method :register_void_element, :register_html_element
      end
    end
  end
end
