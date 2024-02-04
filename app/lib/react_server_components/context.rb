# frozen_string_literal: true

module ReactServerComponents
  class Context
    attr_reader :target

    def initialize
      @target = []
    end

    def capturing_into(new_target)
      original_target = @target
      @target = new_target
      content_string = yield
      @target << content_string if content_string.is_a?(String)
      @target
    ensure
      @target = original_target
    end
  end
end
