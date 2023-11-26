# frozen_string_literal: true

# Include this module into a {JSX} component to make it render asynchronously.
# A placeholder will be sent to React until the rendering is done
module Phlex
  class JSX
    module AsyncRender
      # This module doesn't do anything. Phlex::JSX#call checks for its inclusion in the ancestry instead.
    end
  end
end
