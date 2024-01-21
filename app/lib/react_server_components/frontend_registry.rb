# frozen_string_literal: true

require "json"
require "net/http"

module ReactServerComponents
  # Loads 'use client' React components (using default exports) from the webpack-generated `react-client-manifest.json` file
  module FrontendRegistry
    COMPONENTS = begin
      client_manifest = if Rails.env.development?
                          response = Net::HTTP.get(URI("http://localhost:3000/packs/react-client-manifest.json"))
                          JSON.parse(response)
                        else
                          JSON.load_file(Rails.root.join("public/packs/react-client-manifest.json"))
                        end

      client_manifest.each_value.filter_map do |entry|
        next unless entry["name"] == "" # Only use `default` exports

        component_name = /\/([a-zA-Z]+)\./.match(entry["id"])[1].underscore
        [component_name.to_sym, entry]
      end.to_h
    end
  end
end
