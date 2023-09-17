# frozen_string_literal: true

class RscController < ApplicationController
  def show
    render AppView.new(selected_id: props["selectedId"], is_editing: props["isEditing"], search_text: props["searchText"])
  end

  private

  def props
    @props ||= JSON.parse(params[:location])
  end
end
