# frozen_string_literal: true

require "json"
require "net/http"

response = Net::HTTP.get(URI("http://notes-app:4000/react-client-manifest.json"))
client_manifest = JSON.parse(response)
# client_manifest = JSON.load_file("../build/react-client-manifest.json")

MANIFEST_ENTRIES = client_manifest.each_value.filter_map do |entry|
  next unless entry["name"] == ""

  component_name = /\/([a-zA-Z]+)\./.match(entry["id"])[1].underscore
  [component_name.to_sym, entry]
end

module FrontendComponentRegistry
  MANIFEST_ENTRIES.each do |tag, entry|
    define_method(tag) do |**props, &children|
      reference = engine.add_frontend_component(tag, entry)
      Component.eval(eval_stack, reference, **props, &children)
    end
  end

  def suspense(**props, &children)
    reference = engine.add_suspense_component
    Component.eval(eval_stack, reference, **props, &children)
  end
end
