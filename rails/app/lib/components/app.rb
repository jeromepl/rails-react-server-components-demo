# frozen_string_literal: true

module Components
  class App < Component
    attr_reader :selectedId, :isEditing, :searchText

    def initialize(selectedId:, isEditing:, searchText:)
      @selectedId = selectedId
      @isEditing = isEditing
      @searchText = searchText
    end

    def render(jsx)
      jsx.div className: "main" do
        jsx.section className: "col sidebar" do
          jsx.section className: "sidebar-header" do
            jsx.img className: "logo", src: "logo.svg", width: "22px", height: "20px", alt: "", role: "presentation"
            jsx.strong { "React Notes" }
          end
          jsx.section className: "sidebar-menu", role: "menubar" do
            jsx.search_field
            jsx.edit_button noteId: nil do
              "New"
            end
          end
          jsx.nav do
            # jsx.suspense fallback: note_list_skeleton do
            jsx.suspense fallback: "Loading..." do
              # NoteList.render(jsx, searchText:)
              jsx.render NoteList.new(searchText:)
            end
          end
        end
        jsx.section key: selectedId, className: "col note-viewer" do
          # jsx.suspense fallback: note_skeleton(isEditing: isEditing) do
          jsx.suspense fallback: "Loading..." do
            # Note.render(jsx, selectedId: selectedId, isEditing: isEditing)
            jsx.render Note.new(selectedId: selectedId, isEditing: isEditing)
          end
        end
      end
    end
  end
end
