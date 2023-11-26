# frozen_string_literal: true

class NoteListComponent < ApplicationComponent
  include Phlex::JSX::AsyncRender

  attr_reader :search_text

  def initialize(search_text:)
    @search_text = search_text
  end

  def template
    if notes.any?
      ul class: "notes-list" do
        notes.map do |note|
          li key: note.id do
            sidebar_note note:
          end
        end
      end
    else
      div class: "notes-empty" do
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
    @notes ||= begin
      sleep 2
      Note.where("title ILIKE ?", "%#{search_text}%").order(updated_at: :desc)
    end
  end
end
