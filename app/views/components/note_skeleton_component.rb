# frozen_string_literal: true

class NoteSkeletonComponent < ApplicationComponent
  attr_reader :is_editing

  def initialize(is_editing: false)
    @is_editing = is_editing
  end

  def template
    is_editing ? note_editor_skeleton : note_preview_skeleton
  end

  private

  def note_editor_skeleton
    div class: "note-editor skeleton-container", role: "progressbar", "aria-busy" => "true" do
      div class: "note-editor-form" do
        div class: "skeleton v-stack", style: { height: "3rem" }
        div class: "skeleton v-stack", style: { height: "100%" }
      end
      div class: "note-editor-preview" do
        div class: "note-editor-menu" do
          div class: "skeleton skeleton--button", style: { width: "8em", height: "2.5em" }
          div class: "skeleton skeleton--button", style: { width: "8em", height: "2.5em", marginInline: "12px 0" }
        end
        div class: "note-title skeleton", style: { height: "3rem", width: "65%", marginInline: "12px 1em" }
        div class: "note-preview" do
          div class: "skeleton v-stack", style: { height: "1.5em" }
          div class: "skeleton v-stack", style: { height: "1.5em" }
          div class: "skeleton v-stack", style: { height: "1.5em" }
          div class: "skeleton v-stack", style: { height: "1.5em" }
          div class: "skeleton v-stack", style: { height: "1.5em" }
        end
      end
    end
  end

  def note_preview_skeleton
    div class: "note skeleton-container", role: "progressbar", "aria-busy" => "true" do
      div class: "note-header" do
        div class: "note-title skeleton", style: { height: "3rem", width: "65%", marginInline: "12px 1em" }
        div class: "skeleton skeleton--button", style: { width: "8em", height: "2.5em" }
      end
      div class: "note-preview" do
        div class: "skeleton v-stack", style: { height: "1.5em" }
        div class: "skeleton v-stack", style: { height: "1.5em" }
        div class: "skeleton v-stack", style: { height: "1.5em" }
        div class: "skeleton v-stack", style: { height: "1.5em" }
        div class: "skeleton v-stack", style: { height: "1.5em" }
      end
    end
  end
end
