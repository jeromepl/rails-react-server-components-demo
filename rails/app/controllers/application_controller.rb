# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionController::Live

  # TODO: Remove this, this is only temporary while the front-end is served on a different port
  skip_before_action :verify_authenticity_token

  def stream(...)
    response.headers["X-Accel-Buffering"] = "no"
    response.headers["X-Location"] = params[:location]

    # Use `#render_to_string` instead of `#render` since:
    #  1. We don't care about the `format` or `content_type` options (they are fixed)
    #  2. The `#render` method does not work with `ActionController::Live` since it
    #     adds headers **after** the response body streaming has started, which is not allowed.
    #     See https://github.com/rails/rails/blob/e88857bbb9d4e1dd64555c34541301870de4a45b/actionpack/lib/abstract_controller/rendering.rb#L33
    render_to_string(...)
  ensure
    response.stream.close
  end
end
