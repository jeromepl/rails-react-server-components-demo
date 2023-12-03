# frozen_string_literal: true

class NoteComponent < ApplicationComponent
  include Phlex::JSX::AsyncRender

  attr_reader :selected_id, :is_editing

  def initialize(selected_id:, is_editing:)
    @selected_id = selected_id
    @is_editing = is_editing
  end

  def template
    return render_no_selected_id if selected_id.blank?
    return note_editor(noteId: note.id, initialTitle: note.title, initialBody: note.body) if is_editing

    div class: "note" do
      div class: "note-header" do
        h1 class: "note-title" do
          note.title
        end
        div class: "note-menu", role: "menubar" do
          small class: "note-updated-at", role: "status" do
            "Last updated on #{note.updated_at}"
          end
          edit_button noteId: note.id do
            "Edit"
          end
        end
      end
      note_preview body: note.body
    end
  end

  private

  def render_no_selected_id
    return note_editor(noteId: nil, initialTitle: "Untitled", initialBody: "") if is_editing

    div class: "note--empty-state" do
      span class: "note-text--empty-state" do
        "Click a note on the left to view something! 🥺"
      end
    end
  end

  def note
    @note ||= begin
      sleep 1 # Simulate a slow DB
      Note.find(selected_id)
    end
  end
end
