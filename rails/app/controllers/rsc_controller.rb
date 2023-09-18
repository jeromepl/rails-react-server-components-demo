# frozen_string_literal: true

class RscController < ApplicationController
  include ActionController::Live

  def show
    response.headers["X-Location"] = props.to_json

    stream AppView.new(selected_id: props["selectedId"], is_editing: props["isEditing"], search_text: props["searchText"])
  end

  private

  def props
    @props ||= JSON.parse(params[:location])
  end

  def stream(...)
    response.headers["X-Accel-Buffering"] = "no"

    render(...)
  ensure
    response.stream.close
  end
end
