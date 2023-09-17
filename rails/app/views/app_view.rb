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
          search_field do |c|
            c.fallback do
              strong { "Loading ..." }
            end

            "with another return value"
          end
          edit_button noteId: nil do
            "New"
          end
        end
      end
    end
  end
end
