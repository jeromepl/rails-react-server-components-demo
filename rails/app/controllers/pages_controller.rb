# frozen_string_literal: true

class PagesController < ApplicationController
  layout -> { ApplicationLayout }

  def main
    render
  end
end
