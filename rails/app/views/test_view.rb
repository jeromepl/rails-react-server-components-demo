# frozen_string_literal: true

class TestView < ApplicationView
  def template
		h1 { "👋 Hello World!" }
	end
end
