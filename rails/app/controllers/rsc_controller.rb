class RscController < ApplicationController
  def show
    render plain: Components::App.new.serialize!
  end
end
