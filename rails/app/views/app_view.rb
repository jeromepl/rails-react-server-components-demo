# frozen_string_literal: true

class AppView < ApplicationView
  attr_reader :selected_id, :is_editing, :search_text

  def initialize(selected_id: nil, is_editing: false, search_text: "")
    @selected_id = selected_id
    @is_editing = is_editing
    @search_text = search_text
  end

  def template
    div className: "main" do
      section className: "col sidebar" do
        section className: "sidebard-header" do
          img className: "logo", src: "logo.svg", width: "22px", height: "20px", alt: "", role: "presentation"
          strong { "React Notes" }
        end
        section className: "sidebar-menu", role: "menubar" do
          search_field
          edit_button noteId: nil do
            "New"
          end
        end
        nav do
          render NoteListComponent.new(search_text:)
          # suspense do |c|
          #   c.fallback { "Loading..." } # fallback: note_list_skeleton

          #   render NoteList.new(search_text:)
          # end
        end
      end
      section key: selected_id, className: "col note-viewer" do
        render NoteComponent.new(selected_id:, is_editing:)
        # suspense fallback: note_skeleton(is_editing:) do
        #   render Note.new(selected_id:, is_editing:)
        # end
      end
    end
  end
end
