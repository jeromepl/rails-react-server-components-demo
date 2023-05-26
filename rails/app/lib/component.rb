class Component
  attr_accessor :engine, :index, :output, :root_component

  def initialize
    @engine = nil
    @root_component = true
  end

  def method_missing(method_name, *_args, **props, &block)
    if @root_component
      component_index = engine.index
      engine.index = engine.index + 1
      @root_component = false
    else
      component_index = nil
    end

    # Get component from registry
    component = Registry::COMPONENTS[method_name.to_sym]
    reference = if component
      component_reference(component)
    elsif method_name == :suspense
      component_reference(:suspense)
    else
      method_name
    end

    engine.component_stack.push([])
    block_return = block.call if block_given?
    children = engine.component_stack.pop

    # TODO: Hacky, but works for this demo
    # since we never have the cases where:
    #  1) there is a string used but not as return value
    #  2) or; there is an AsyncComponent used but not as return value
    children << block_return if block_return.is_a?(String) || block_return.is_a?(AsyncComponent)

    # Remove elements from the array at the top of the stack
    # when they are used as props (detect them through kwargs here?)
    props.each_value do |prop_value|
      engine.component_stack.last&.delete(prop_value)
    end

    children = children.map do |child|
      if child.is_a?(AsyncComponent)
        child.root_component = false
        child.engine = engine

        engine.async_components << {
          index: engine.index,
          component: child
        }
        engine.index = engine.index + 1
        "$L#{engine.index - 1}"
      elsif child.is_a?(Component)
        child.root_component = false
        child.engine = engine

        child.render
      else
        child
      end
    end

    result = {
      type: 'tree',
      index: component_index,
      reference:,
      props: {
        **{ children: }.compact_blank,
        **props
      }
    }

    engine.component_stack.last&.push(result)

    result
  end

  def register_suspense_in_output
    engine.output << {
      type: 'suspense',
      index: engine.index,
    }
    engine.index = engine.index + 1
    "$#{engine.index - 1}"
  end

  def register_component_in_output(component)
    engine.output << {
      type: 'component',
      index: engine.index,
      **component
    }
    engine.index = engine.index + 1
    "$L#{engine.index - 1}"
  end

  # {"router"=>{"id"=>"./src/framework/router.js", "chunks"=>["main"], "name"=>""},
  # "edit_button"=>{"id"=>"./src/EditButton.js", "chunks"=>["client0"], "name"=>""},
  # "note_editor"=>{"id"=>"./src/NoteEditor.js", "chunks"=>["vendors-node_modules_sanitize-html_index_js-node_modules_marked_lib_marked_esm_js", "client1"], "name"=>""},
  # "search_field"=>{"id"=>"./src/SearchField.js", "chunks"=>["client2"], "name"=>""},
  # "sidebar_note_content"=>{"id"=>"./src/SidebarNoteContent.js", "chunks"=>["client3"], "name"=>""}}

  def component_reference(component)
    # return true if component.blank?
    if component == :suspense
      found_index = engine.output.find do |registered_component|
        registered_component[:type] == 'suspense'
      end&.fetch(:index)

      return "$#{found_index}" if found_index

      return register_suspense_in_output
    end

    found_index = engine.output.find do |registered_component|
      registered_component['id'] == component['id']
    end&.fetch(:index)

    return register_component_in_output(component) unless found_index

    "$L#{found_index}"
  end
end
