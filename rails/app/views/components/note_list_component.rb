# frozen_string_literal: true

class NoteListComponent < ApplicationComponent
  attr_reader :search_text

  def initialize(search_text:)
    @search_text = search_text
  end

  def template
    if notes.any?
      ul className: "notes-list" do
        notes.map do |note|
          li key: note.id do
            sidebar_note note:
          end
        end
      end
    else
      div className: "notes-empty" do
        if search_text.present?
          "Couldn't find any notes titled '#{search_text}'"
        else
          "No notes created yet!"
        end
      end
    end
  end

  private

  def notes
    Note.where("title ILIKE ?", "%#{search_text}%").order(:id)
  end
end
