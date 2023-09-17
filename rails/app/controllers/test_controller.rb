class TestController < ApplicationController
  # layout -> { ApplicationLayout }

  def index
    render AppView.new
  end
end
