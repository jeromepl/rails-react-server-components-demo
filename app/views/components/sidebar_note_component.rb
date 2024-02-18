# frozen_string_literal: true

class SidebarNoteComponent < ApplicationComponent
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::DateHelper

  attr_reader :note

  def initialize(note:)
    @note = note
  end

  def template
    sidebar_note_content id: note.id, title: note.title do |c|
      c.expandedChildren do
        p class: "sidebar-note-excerpt" do
          summary.presence || i { "(No content)" }
        end
      end

      header class: "sidebar-note-header" do
        strong { note.title }
        small { formatted_date }
      end
    end
  end

  private

  def summary
    truncate(strip_tags(rendered_body), length: 80, separator: /\s+/)
  end

  def formatted_date
    "#{time_ago_in_words(note.updated_at)} ago"
  end

  def rendered_body
    self.class.markdown.render(note.body)
  end

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true))
  end
end
