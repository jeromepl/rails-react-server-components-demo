class Dsl < Registry
  attr_accessor :index, :output

  def initialize
    @index = 0
    @output = []
  end

  def serialize!
    render

    output.map do |output_item|
      parse_output_item(output_item)
    end.join("\n")
  end

  def method_missing(method_name, *_args, **_kwargs, &block)
    is_first_component = @index.zero?
    @index += 1 if is_first_component

    # Get component from registry
    component = Registry::COMPONENTS[method_name.to_sym]
    reference = register_component_in_output(component) unless component_exists_in_output?(component)

    children = block_given? ? [block.call] : []

    result = {
      type: 'tree',
      index: 0,
      reference:,
      props: {
        children:
      }.compact_blank
    }
    output << result if is_first_component
    result
  end

  def parse_output_item(output_item)
    if output_item[:type] == 'tree'
      "#{output_item[:index]}:#{parse_output_tree_item(output_item)}"
    elsif output_item[:type] == 'component'
      "#{output_item[:index]}:I#{output_item.to_json.gsub("\\", "")}"
    end
  end

  def parse_output_tree_item(output_tree_item)
    props = { **output_tree_item[:props] }
    props[:children] = [output_tree_item[:props][:children].map { |item |parse_output_tree_item(item) }] if output_tree_item[:props].key?(:children)
    "[\"$\",\"#{output_tree_item[:reference]}\",\"null\",#{props.to_json.gsub("\\", "")}]"
  rescue StandardError => e
    debugger
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

  def component_exists_in_output?(component)
    return true if component.blank?

    output.any? do |registered_component|
      return true if registered_component["id"] == component["id"]
    end
  end
end
