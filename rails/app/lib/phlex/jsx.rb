# frozen_string_literal: true

require "stringio"

module Phlex
  # @abstract Subclass and define {#template} to create an HTML component class.
  class JSX < SGML
    # A list of HTML attributes that have the potential to execute unsafe JavaScript.
    EVENT_ATTRIBUTES = %w[onabort onafterprint onbeforeprint onbeforeunload onblur oncanplay oncanplaythrough onchange onclick oncontextmenu oncopy oncuechange oncut ondblclick ondrag ondragend ondragenter ondragleave ondragover ondragstart ondrop ondurationchange onemptied onended onerror onfocus onhashchange oninput oninvalid onkeydown onkeypress onkeyup onload onloadeddata onloadedmetadata onloadstart onmessage onmousedown onmousemove onmouseout onmouseover onmouseup onmousewheel onoffline ononline onpagehide onpageshow onpaste onpause onplay onplaying onpopstate onprogress onratechange onreset onresize onscroll onsearch onseeked onseeking onselect onstalled onstorage onsubmit onsuspend ontimeupdate ontoggle onunload onvolumechange onwaiting onwheel].to_h { [_1, true] }.freeze

    UNBUFFERED_MUTEX = Mutex.new

    class << self
      # @api private
      def __unbuffered_class__
        UNBUFFERED_MUTEX.synchronize do
          if defined? @unbuffered_class
            @unbuffered_class
          else
            @unbuffered_class = Class.new(Unbuffered)
          end
        end
      end
    end

    extend Elements
    include Helpers

    # Re-define HTML elements to be rendered following the React JSON format:
    HTML::VoidElements.registered_elements.each_pair do |method_name, tag|
      register_element(method_name, tag:)
    end
    HTML::StandardElements.registered_elements.each_pair do |method_name, tag|
      register_element(method_name, tag:)
    end

    include ReactComponents

    # Outputs an `<svg>` tag
    # @return [nil]
    # @see https://developer.mozilla.org/docs/Web/SVG/Element/svg
    def svg(...)
      super do
        render Phlex::SVG.new do |svg|
          yield(svg)
        end
      end
    end

    # @api private
    def unbuffered
      self.class.__unbuffered_class__.new(self)
    end

    def call(buffer = nil, context: nil, view_context: nil, parent: nil, &block)
      super(buffer || TopLevelBuffer.new(StringIO.new), context: context || Context.new, view_context:, parent:, &block)
    end

    def __final_call__(buffer = nil, context: nil, view_context: nil, parent: nil, &block)
      super(buffer || TopLevelBuffer.new(StringIO.new), context: context || Context.new, view_context:, parent:, &block)
    end

    def comment(&)
      nil # Can't do comments in the JSON format returned
    end

    # TODO: For an async render, reuse the buffer but give it a new index?
    # We could do this through the `#render` method and check if the component is an instance of AsyncComponent or something like that?
    # https://github.com/phlex-ruby/phlex/blob/9e5820dc69cb243e31b924f00390deb45be18fb3/lib/phlex/sgml.rb#L215

    def format
      self.class.format
    end

    def self.format
      :text
    end

    def yield_content(...)
      @_context.yield_content(self, ...)
    end
  end
end
