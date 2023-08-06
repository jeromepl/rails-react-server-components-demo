# frozen_string_literal: true

class TestView < ApplicationView
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

  class << self
    def test_old
      buffer = StringIO.new
      jsx = JSXContext.new(buffer)
      Components::App.render(jsx)
      buffer.string
    end

    def test_new
      TestView.call
    end
  end
end
