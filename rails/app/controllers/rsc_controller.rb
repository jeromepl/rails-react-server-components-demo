class RscController < ApplicationController
  def show
    render_component(Components::App, selectedId: props["selectedId"], isEditing: props["isEditing"], searchText: props["searchText"])
  end

  private

  def props
    @props ||= JSON.parse(params[:location])
  end
end
