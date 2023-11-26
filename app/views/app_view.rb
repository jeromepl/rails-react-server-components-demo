# frozen_string_literal: true

class AppView < ApplicationView
  attr_reader :selected_id, :is_editing, :search_text

  def initialize(selected_id: nil, is_editing: false, search_text: "")
    @selected_id = selected_id
    @is_editing = is_editing
    @search_text = search_text
  end

  def template
    div class: "main" do
      section class: "col sidebar" do
        section class: "sidebar-header" do
          img class: "logo", src: "logo.svg", width: "22px", height: "20px", alt: "", role: "presentation"
          strong { "React Notes" }
        end
        section class: "sidebar-menu", role: "menubar" do
          search_field
          edit_button noteId: nil do
            "New"
          end
        end
        nav do
          suspense do |c|
            c.fallback { note_list_skeleton }

            render NoteListComponent.new(search_text:)
          end
        end
      end
      section key: selected_id, class: "col note-viewer" do
        suspense do |c|
          c.fallback { note_skeleton(is_editing:) }

          render NoteComponent.new(selected_id:, is_editing:)
        end
      end
    end
  end
end
