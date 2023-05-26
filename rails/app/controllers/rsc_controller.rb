class RscController < ApplicationController
  def show
    render_app(selectedId: props["selectedId"], isEditing: props["isEditing"], searchText: props["searchText"])
  end

  private

  def props
    @props ||= JSON.parse(params[:location])
  end
end
