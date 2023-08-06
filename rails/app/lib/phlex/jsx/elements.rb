# frozen_string_literal: true

module Phlex
  class JSX
    module Elements
      # @api private
      def registered_elements
        @registered_elements ||= Concurrent::Map.new
      end

      def register_react_component(method_name, webpack_definition, tag: method_name)
        class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          # frozen_string_literal: true

          def #{method_name}(**attributes, &block)
            target = @_context.target

            rendered_slots = {}
            children = yield_content(react_slots_target: rendered_slots, &block) if block_given?

            props = {
              **attributes, # TODO: __attributes__(**attributes),
              **rendered_slots,
              **{ children: }.compact_blank,
            }
            key = props.delete(:key)

            reference = @_buffer.write_react_component("#{tag}", #{webpack_definition})
            target << ["$", reference, key, props]

            nil
          end

          alias_method :_#{method_name}, :#{method_name}
        RUBY

        class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          # frozen_string_literal: true

          # For React components, we allow any "slots" as render them as props
          # This allows passing JSX to a prop, for example to a Suspense component's fallback:
          # > suspense do |c|
          # >   c.fallback { strong { "Loading..." } }
          # > end
          def method_missing(m, *args, &block)
            return super unless block_given?

            @_context.add_react_slot(self, m, &block)
          end
        RUBY

        registered_elements[method_name] = tag

        method_name
      end

      # Register a custom element. This macro defines an element method for the current class and descendents only. There is no global element registry.
      # @param method_name [Symbol]
      # @param tag [String] the name of the tag, otherwise this will be the method name with underscores replaced with dashes.
      # @return [Symbol] the name of the method created
      # @note The methods defined by this macro depend on other methods from {SGML} so they should always be mixed into an {HTML} or {SVG} component.
      # @example Register the custom element `<trix-editor>`
      # 	register_element :trix_editor
      def register_element(method_name, tag: nil)
        tag ||= method_name.name.tr("_", "-")

        class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          # frozen_string_literal: true

          def #{method_name}(**attributes, &block)
            target = @_context.target

            reference = "#{tag}"
            children = yield_content(&block) if block_given?

            props = {
              **attributes, # TODO: __attributes__(**attributes),
              **{ children: }.compact_blank,
            }
            key = props.delete(:key)

            target << ["$", reference, key, props]

            nil
          end

          alias_method :_#{method_name}, :#{method_name}
        RUBY

        registered_elements[method_name] = tag

        method_name
      end
      alias_method :register_void_element, :register_element
    end
  end
end
