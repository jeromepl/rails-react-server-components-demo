# frozen_string_literal: true

module Components
  class NoteList < Component
    attr_reader :searchText

    def initialize(engine, eval_stack, searchText:)
      @searchText = searchText

      super(engine, eval_stack)
    end

    def render
      if notes.any?
        ul className: "notes-list" do
          notes.map do |note|
            li key: note.id do
              sidebar_note note: note
            end
          end
        end
      else
        div className: "notes-empty" do
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
