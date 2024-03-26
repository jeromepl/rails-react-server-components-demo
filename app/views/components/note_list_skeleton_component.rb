# frozen_string_literal: true

class NoteListSkeletonComponent < ApplicationComponent
  def template
    div do
      ul class: "notes-list skeleton-container" do
        3.times do
          li class: "v-stack" do
            div class: "sidebar-note-list-item skeleton", style: { height: "5em" }
          end
        end
      end
    end
  end
end
