# frozen_string_literal: true

# Include this module into a component to make it render asynchronously.
# A placeholder will be sent to React until the rendering is done
module ReactServerComponents
  module AsyncRender
    # This module doesn't do anything. BaseComponent#call checks for its inclusion in the ancestry instead.
  end
end
