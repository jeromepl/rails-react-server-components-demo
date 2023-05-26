class RscController < ApplicationController
  def show
    render json: { a: 2 }
  end
end
