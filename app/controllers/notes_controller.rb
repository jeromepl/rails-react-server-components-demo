# frozen_string_literal: true

class NotesController < ApplicationController
  def create
    note = Note.create!(title: params[:title], body: params[:body])
    stream AppView.new(selected_id: note.id, is_editing: false, search_text: props["searchText"])
  end

  def update
    note = Note.find(params[:id])
    note.update!(title: params[:title], body: params[:body])
    stream AppView.new(selected_id: note.id, is_editing: false, search_text: props["searchText"])
  end

  def delete
    Note.find(params[:note_id]).destroy!
    stream AppView.new(selected_id: nil, is_editing: false, search_text: props["searchText"])
  end

  private

  def props
    @props ||= JSON.parse(params[:location])
  end
end
