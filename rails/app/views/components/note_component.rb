# frozen_string_literal: true

class NoteComponent < ApplicationComponent
  attr_reader :selected_id, :is_editing

  def initialize(selected_id:, is_editing:)
    @selected_id = selected_id
    @is_editing = is_editing
  end

  def template
    return render_no_selected_id if selected_id.blank?
    return note_editor(noteId: note.id, initialTitle: note.title, initialBody: note.body) if is_editing

    # sleep 2

    div className: "note" do
      div className: "note-header" do
        h1 className: "note-title" do
          note.title
        end
        div className: "note-menu", role: "menubar" do
          small className: "note-updated-at", role: "status" do
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

    div className: "note--empty-state" do
      span className: "note-text--empty-state" do
        "Click a note on the left to view something! 🥺"
      end
    end
  end

  def note
    @note ||= Note.find(selected_id)
  end
end
