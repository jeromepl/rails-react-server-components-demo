module Components
  class Note < Dsl
    attr_reader :selectedId, :isEditing

    def initialize(selectedId:, isEditing:)
      @selectedId = selectedId
      @isEditing = isEditing

      super()
    end

    def render
      return render_no_selected_id if selectedId.blank?
      return note_editor(noteId: note.id, initialTitle: note.title, initialBody: note.body) if isEditing

      div(className: "note") do
        [
          div(className: "note-header") do
            [
              h1(className: "note-title") { note.title },
              div(className: "note-menu", role: "menubar") do
                [
                  small(className: "note-updated-at", role: "status") do
                    "Last updated on #{note.updated_at}"
                  end,
                  edit_button(noteId: note.id) { "Edit" }
                ]
              end
            ]
          end,
          note_preview(body: note.body)
        ]
      end
    end

    private

    def render_no_selected_id
      return note_editor(noteId: nil, initialTitle: "Untitled", initialBody: "") if isEditing

      div(className: "note--empty-state") do
        span(className: "note-text--empty-state") do
          "Click a note on the left to view something! 🥺"
        end
      end
    end

    def note
      @note ||= ::Note.find(selectedId)
    end
  end
end
