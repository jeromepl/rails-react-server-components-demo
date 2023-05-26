require 'json'
require 'net/http'

response = Net::HTTP.get(URI("http://notes-app:4000/react-client-manifest.json"))
client_manifest = JSON.parse(response)
# client_manifest = JSON.load_file("../build/react-client-manifest.json")

REGISTRY = client_manifest.each_value.filter_map do |entry|
  next unless entry["name"] == ""

  component_name = /\/([a-zA-Z]+)\./.match(entry["id"])[1].underscore
  [component_name.to_sym, entry]
end.to_h.with_indifferent_access

class Registry
  COMPONENTS = REGISTRY
end