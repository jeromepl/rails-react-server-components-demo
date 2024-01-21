# frozen_string_literal: true

module ReactServerComponents
  class Context
    class ComponentProxy < SimpleDelegator
      def initialize(component, slots_target:)
        super(component)
        @slots_target = slots_target
      end

      # For React components, we have to allow any "slots" and render them as props
      # This allows passing components to a prop, for example to a Suspense component's fallback:
      # > suspense do |c|
      # >   c.fallback { strong { "Loading..." } }
      # > end
      def method_missing(m, *args, &block)
        return super unless block_given?
  
        @slots_target[m], _ = __getobj__.yield_content(&block)
      end
    end

    attr_reader :target

    def initialize
      @target = []
    end
    
    def yield_content(&block)
      return unless block_given?

      content_target = []
      slots_target = {}
      proxy = ComponentProxy.new(block.binding.receiver, slots_target:)
      content_string = capturing_into(content_target) { block.call(proxy) }
      # If the block returns a string, assume it is meant to be a child of the component and add it to the target:
      content_target << content_string if content_string.is_a?(String)
      [content_target, slots_target]
    end

    private

    def capturing_into(new_target)
      original_target = @target
      @target = new_target
      yield
    ensure
      @target = original_target
    end
  end
end
