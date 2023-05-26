class Dsl < Registry
  attr_accessor :index, :output

  def initialize
    @index = 0
    @output = []
  end

  def serialize!
    render

    output.map do |output_item|
      parse_output_item(output_item) + "\n"
    end
  end

  def method_missing(method_name, *_args, **props, &block)
    is_first_component = @index.zero?
    @index += 1 if is_first_component

    # Get component from registry
    component = Registry::COMPONENTS[method_name.to_sym]
    reference = if component
      component_reference(component)
    else
      method_name
    end

    children = block_given? ? Array.wrap(block.call) : []

    result = {
      type: 'tree',
      index: 0,
      reference:,
      props: {
        children:,
        **props,
      }.compact_blank
    }
    output << result if is_first_component
    result
  end

  def parse_output_item(output_item)
    if output_item[:type] == 'tree'
      "#{output_item[:index]}:#{parse_output_tree_item(output_item).to_json}"
    elsif output_item[:type] == 'component'
      "#{output_item[:index]}:I#{output_item.to_json.gsub("\\", "")}"
    end
  end

  def parse_output_tree_item(output_tree_item)
    props = { **output_tree_item[:props] }
    props[:children] = output_tree_item[:props][:children].map { |item| item.is_a?(Hash) ? parse_output_tree_item(item) : item } if output_tree_item[:props].key?(:children)
    ["$","#{output_tree_item[:reference]}","null",props]
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

    found_index = output.find do |registered_component|
      registered_component["id"] == component["id"]
    end&.fetch(:index)
    
    return register_component_in_output(component) unless found_index

    "L#{found_index}"
  end
end
