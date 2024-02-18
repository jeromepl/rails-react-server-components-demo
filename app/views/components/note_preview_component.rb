# frozen_string_literal: true

class NotePreviewComponent < ApplicationComponent
  attr_reader :body

  def initialize(body:)
    @body = body
  end

  def template
    div class: "note-preview" do
      render TextWithMarkdownComponent.new(text: body)
    end
  end
end
