class RscController < ApplicationController
  def show
    render plain: Component.new.serialize!
  end
end
