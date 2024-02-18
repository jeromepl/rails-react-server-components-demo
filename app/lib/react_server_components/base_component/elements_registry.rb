# frozen_string_literal: true

module ReactServerComponents
  class BaseComponent
    module ElementsRegistry
      def self.included(base)
        base.extend ClassMethods
      end

      def _render_to_react_stream_format(reference, attributes: {}, allow_slots: false, &block)
        if block_given?
          proxy = ComponentProxy.new(allow_slots:)
          children = yield_content { render(proxy, &block) }
        end

        props = {
          **attributes,
          **(proxy&._rendered_slots || {}),
          **{ children: }.compact_blank,
        }
        key = props.delete(:key)&.to_s

        @_context.target << ["$", reference, key, props]

        nil
      end

      module ClassMethods
        def register_react_component(component_name, webpack_definition:)
          define_method(component_name) do |**attributes, &block|
            reference = @_stream.write_react_component(component_name, webpack_definition)
            _render_to_react_stream_format(reference, attributes:, allow_slots: true, &block)
          end
        end

        def register_suspense
          define_method(:suspense) do |&block|
            reference = @_stream.write_suspense
            _render_to_react_stream_format(reference, allow_slots: true, &block)
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
