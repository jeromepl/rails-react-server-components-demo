# frozen_string_literal: true

module Phlex
  class JSX
    module HtmlElements
      include Elements

      # A list of HTML attributes that have the potential to execute unsafe JavaScript.
      EVENT_ATTRIBUTES = HTML::EVENT_ATTRIBUTES

      # Re-define HTML elements (from Phlex::HTML) to be rendered following the React JSON format:
      HTML::VoidElements.registered_elements.each_pair do |method_name, tag|
        register_html_element(method_name, tag:)
      end
      HTML::StandardElements.registered_elements.each_pair do |method_name, tag|
        register_html_element(method_name, tag:)
      end
    end
  end
end
