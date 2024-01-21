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
        def register_react_component(component_name, webpack_definition)
          define_method(component_name) do |**attributes, &block|
            reference = @_buffer.write_react_component(component_name, webpack_definition)
            _render_to_react_stream_format(reference, attributes:, use_slots: true, &block)
          end
        end

        def register_suspense
          define_method(:suspense) do |&block|
            reference = @_buffer.write_suspense
            _render_to_react_stream_format(reference, use_slots: true, &block)
          end
        end

        def register_html_element(method_name, tag: nil)
          tag ||= method_name.name.tr("_", "-")

          define_method(method_name) do |**attributes, &block|
            _render_to_react_stream_format(tag, attributes:, &block)
          end
        end
      end
    end
  end
end
