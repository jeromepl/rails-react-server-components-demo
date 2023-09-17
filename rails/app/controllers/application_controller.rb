# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # include ActionController::Live

  # def render_component(component_klass, **props)
  #   response.headers["X-Accel-Buffering"] = "no"
  #   response.headers["X-Location"] = props.to_json # TODO: Move this out

  #   jsx = JsxContext.new(response.stream)
  #   component_klass.render(jsx, **props)

  #   # TODO: Wait for async components to stream:


  #   # engine = Engine.new
  #   # index = engine.next_index
  #   # value = component_klass.new(engine, [[]], **props).render
  #   # output = "#{index}:#{value.to_json}"

  #   # output_batch(engine, output)

  #   # until engine.async_components_queue.empty?
  #   #   async_components = engine.async_components_queue
  #   #   engine.async_components_queue = []

  #   #   Sync do
  #   #     async_components.each do |async_component|
  #   #       Async do
  #   #         async_index = async_component[:index]
  #   #         async_value = async_component[:value].call
  #   #         async_output = "#{async_index}:#{async_value.to_json}"

  #   #         output_batch(engine, async_output)
  #   #       end
  #   #     end
  #   #   end
  #   # end
  # ensure
  #   response.stream.close
  # end

  # private

  # def output_batch(engine, output)
  #   frontend_components = engine.frontend_components_queue
  #   engine.frontend_components_queue = []
  #   frontend_components.each do |frontend_component|
  #     response.stream.write "#{frontend_component}\n"
  #   end
  #   response.stream.write "#{output}\n"
  # end
end
