class RscController < ApplicationController
  def create
    note = Note.create!(title: params[:title], body: params[:body])
    render_app(selectedId: note.id, isEditing: false, searchText: props["searchText"])
  end

  private

  def props
    @props ||= JSON.parse(params[:location])
  end
end
