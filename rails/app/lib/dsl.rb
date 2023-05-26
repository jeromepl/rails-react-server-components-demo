class Dsl < Registry
  attr_accessor :index, :output, :root_component

  def initialize
    @index = 0
    @output = []
    @root_component = true
  end

  def serialize!
    output << render

    output.map do |output_item|
      parse_output_item(output_item) + "\n"
    end
  end

  def method_missing(method_name, *_args, **props, &block)
    if root_component
      component_index = index
      @index += 1
      root_component = false
    else
      component_index = nil
    end

    # Get component from registry
    component = Registry::COMPONENTS[method_name.to_sym]
<<<<<<< HEAD
    reference = if component
                  component_reference(component)
                else
                  method_name
                end
||||||| parent of ce10964 (Add (partial) suspense support)
    reference = if component
      component_reference(component)
    else
      method_name
    end
=======
    reference = if component || method_name == "suspense"
      component_reference(component)
    else
      method_name
    end
>>>>>>> ce10964 (Add (partial) suspense support)

    children = block_given? ? Array.wrap(block.call) : []
    children = children.map do |child|
      if child.is_a?(Dsl)
        child.index = index
        child.output = output
        child.root_component = false

        child_output = child.render

        output = child.output
        @index = child.index

        child_output
      else
        child
      end
    end

    {
      type: 'tree',
      index: component_index,
      reference:,
      props: {
        children:,
        **props
      }.compact_blank
    }
  rescue StandardError => e
    debugger
  end

  def parse_output_item(output_item)
    if output_item[:type] == 'tree'
      "#{output_item[:index]}:#{parse_output_tree_item(output_item).to_json}"
    elsif output_item[:type] == 'component'
<<<<<<< HEAD
      "#{output_item[:index]}:I#{output_item.to_json.gsub('\\', '')}"
||||||| parent of ce10964 (Add (partial) suspense support)
      "#{output_item[:index]}:I#{output_item.to_json.gsub("\\", "")}"
=======
      "#{output_item[:index]}:I#{output_item.to_json.gsub("\\", "")}"
    elsif output_item[:type] == 'suspense'
      "#{output_item[:index]}:\"$Sreact.suspense\""
>>>>>>> ce10964 (Add (partial) suspense support)
    end
  end

  def parse_output_tree_item(output_tree_item)
    props = { **output_tree_item[:props] }
    if output_tree_item[:props].key?(:children)
      props[:children] = output_tree_item[:props][:children].map do |item|
        item.is_a?(Hash) ? parse_output_tree_item(item) : item
      end
    end
    ['$', "#{output_tree_item[:reference]}", 'null', props]
  end

  def register_suspense_in_output
    output << {
      type: 'suspense',
      index:,
    }
    @index += 1
    "$L#{index - 1}"
  end

  def register_component_in_output(component)
    output << {
      type: 'component',
      index:,
      **component
    }
    @index += 1
    "$L#{index - 1}"
  end

  # {"router"=>{"id"=>"./src/framework/router.js", "chunks"=>["main"], "name"=>""},
  # "edit_button"=>{"id"=>"./src/EditButton.js", "chunks"=>["client0"], "name"=>""},
  # "note_editor"=>{"id"=>"./src/NoteEditor.js", "chunks"=>["vendors-node_modules_sanitize-html_index_js-node_modules_marked_lib_marked_esm_js", "client1"], "name"=>""},
  # "search_field"=>{"id"=>"./src/SearchField.js", "chunks"=>["client2"], "name"=>""},
  # "sidebar_note_content"=>{"id"=>"./src/SidebarNoteContent.js", "chunks"=>["client3"], "name"=>""}}

  def component_reference(component)
    # return true if component.blank?
    return register_suspense_in_output if component == "suspense"

    found_index = output.find do |registered_component|
      registered_component['id'] == component['id']
    end&.fetch(:index)

    return register_component_in_output(component) unless found_index

    "L#{found_index}"
  end
end
