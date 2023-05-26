class Component
  attr_accessor :engine, :index, :output, :root_component

  def initialize
    @engine = nil
    @root_component = true
  end

  def method_missing(method_name, *_args, **props, &block)
    if root_component
      component_index = engine.index
      engine.index = engine.index + 1
      root_component = false
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
    children = block_given? ? Array.wrap(block.call) : []
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

    {
      type: 'tree',
      index: component_index,
      reference:,
      props: {
        **{ children: }.compact_blank,
        **props
      }
    }
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
