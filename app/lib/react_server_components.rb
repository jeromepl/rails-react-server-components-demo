# frozen_string_literal: true

module ReactServerComponents
  module Error; end

  class RootElementError < StandardError
    include Error
  end
end
