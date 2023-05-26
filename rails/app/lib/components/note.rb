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
  end
end
