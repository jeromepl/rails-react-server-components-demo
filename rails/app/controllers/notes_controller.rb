class NotesController < ApplicationController
  def create
    note = Note.create!(title: params[:title], body: params[:body])
    render_app(selectedId: note.id, isEditing: false, searchText: props["searchText"])
  end

  def update
    note = Note.find(params[:id])
    note.update!(title: params[:title], body: params[:body])
    render_app(selectedId: note.id, isEditing: false, searchText: props["searchText"])
  end
  
  def delete
    Note.find(params[:note_id]).destroy!
    render_app(selectedId: nil, isEditing: false, searchText: props["searchText"])
  end

  private

  def props
    @props ||= JSON.parse(params[:location])
  end
end
