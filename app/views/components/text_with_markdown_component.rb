# frozen_string_literal: true

class TextWithMarkdownComponent < ApplicationComponent
  attr_reader :text

  def initialize(text:)
    @text = text
  end

  def template
    div class: "text-with-markdown", dangerouslySetInnerHTML: { __html: rendered_markdown }
  end

  private

  def rendered_markdown
    self.class.markdown.render(text)
  end

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true), autolink: true)
  end
end
