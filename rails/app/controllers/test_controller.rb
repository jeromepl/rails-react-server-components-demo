class TestController < ApplicationController
  layout -> { ApplicationLayout }

  def index
    render TestView.new
  end
end
