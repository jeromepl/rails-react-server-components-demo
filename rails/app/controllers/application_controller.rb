class ApplicationController < ActionController::API
  include ActionController::Live

  def render_app(**props)
    response.headers["X-Accel-Buffering"] = "no"
    response.headers["X-Location"] = props.to_json

    lines = []
    engine = Engine.new
    component = Components::App.new(**props)
    component.engine = engine
    main_tree = component.render
    (engine.output + [main_tree]).each do |output_item|
      line = "#{engine.parse_output_item(output_item)}\n"
      lines << line
      response.stream.write line
    end

    Sync do
      while engine.async_components.any?
        components = engine.async_components
        engine.async_components = []

        components.each do |async_component|
          Async do
            engine.component_stack.push([])
            main_tree = async_component[:component].render
            engine.component_stack.pop
            main_tree[:index] = async_component[:index]
            (engine.output + [main_tree]).each do |output_item|
              line = "#{engine.parse_output_item(output_item)}\n"
              next if lines.include?(line)

              lines << line
              response.stream.write line
            end
          end
        end
      end
    end
  ensure
    response.stream.close
  end
end
