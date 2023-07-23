# frozen_string_literal: true

module Components
  class NoteList < Component
    attr_reader :searchText

    def initialize(searchText:)
      @searchText = searchText
    end

    def render(jsx)
      if notes.any?
        jsx.ul className: "notes-list" do
          notes.map do |note|
            jsx.li key: note.id do
              jsx.sidebar_note note: note
            end
          end
        end
      else
        jsx.div className: "notes-empty" do
          if searchText.present?
            "Couldn't find any notes titled '#{searchText}'"
          else
            "No notes created yet!"
          end
        end
      end
    end

    private

    def notes
      ::Note.where("title ilike ?", "%#{searchText}%").order(:id)
    end
  end
end
