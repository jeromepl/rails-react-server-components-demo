# frozen_string_literal: true

module Components
  class Note < Component
    attr_reader :selectedId, :isEditing

    def initialize(selectedId:, isEditing:)
      @selectedId = selectedId
      @isEditing = isEditing
    end

    def render(jsx)
      return render_no_selected_id(jsx) if selectedId.blank?
      return jsx.note_editor(noteId: note.id, initialTitle: note.title, initialBody: note.body) if isEditing

      # sleep 2

      jsx.div className: "note" do
        jsx.div className: "note-header" do
          jsx.h1 className: "note-title" do
            note.title
          end
          jsx.div className: "note-menu", role: "menubar" do
            jsx.small className: "note-updated-at", role: "status" do
              "Last updated on #{note.updated_at}"
            end
            jsx.edit_button noteId: note.id do
              "Edit"
            end
          end
        end
        jsx.note_preview body: note.body
      end
    end

    private

    def render_no_selected_id(jsx)
      return jsx.note_editor(noteId: nil, initialTitle: "Untitled", initialBody: "") if isEditing

      jsx.div className: "note--empty-state" do
        jsx.span className: "note-text--empty-state" do
          "Click a note on the left to view something! 🥺"
        end
      end
    end

    def note
      @note ||= ::Note.find(selectedId)
    end
  end
end
