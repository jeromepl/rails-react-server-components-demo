class Engine
  attr_accessor :index, :output, :async_components

  def initialize
    @index = 0
    @output = []
    @async_components = []
  end

  def parse_output_item(output_item)
    if output_item[:type] == 'tree'
      "#{output_item[:index]}:#{parse_output_tree_item(output_item).to_json}"
    elsif output_item[:type] == 'component'
      "#{output_item[:index]}:I#{output_item.to_json.gsub("\\", "")}"
    elsif output_item[:type] == 'suspense'
      "#{output_item[:index]}:\"$Sreact.suspense\""
    end
  end

  def parse_output_tree_item(output_tree_item)
    props = output_tree_item[:props].inject({}) do |h, (k, v)|
      h[k] = v.is_a?(Hash) ? parse_output_tree_item(v) : v
      h
    end
    if output_tree_item[:props].key?(:children)
      props[:children] = output_tree_item[:props][:children].map do |item|
        item.is_a?(Hash) ? parse_output_tree_item(item) : item
      end
    end
    ['$', "#{output_tree_item[:reference]}", 'null', props]
  end
end