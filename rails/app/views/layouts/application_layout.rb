# frozen_string_literal: true

class ApplicationLayout < Phlex::HTML
  include Phlex::Rails::Layout

  def template(&)
    doctype

    html do
      head do
        meta charset: "utf-8"
        meta name: "description", content: "React with Server Components on Rails demo"
        meta name: "viewport", content: "width=device-width, initial-scale=1"
        csp_meta_tag
        csrf_meta_tags
        link rel: "stylesheet", href: "style.css"
        title { "React Notes" }
      end

      body do
        div id: "root" do
          yield
        end
      end
    end
  end
end

# <!DOCTYPE html>
# <html lang="en">
#   <head>
#     <meta charset="utf-8" />
#     <meta name="description" content="React with Server Components demo">
#     <meta name="viewport" content="width=device-width, initial-scale=1" />
#     <link rel="stylesheet" href="style.css" />
#     <title>React Notes</title>
#   </head>
#   <body>
#     <div id="root"></div>
#     <script>
#       // In development, we restart the server on every edit.
#       // For the purposes of this demo, retry fetch automatically.
#       let nativeFetch = window.fetch;
#       window.fetch = async function fetchWithRetry(...args) {
#         for (let i = 0; i < 4; i++) {
#           try {
#             return await nativeFetch(...args);
#           } catch (e) {
#             if (args[1] && args[1].method !== 'GET') {
#               // Don't retry mutations to avoid confusion
#               throw e;
#             }
#             await new Promise(resolve => setTimeout(resolve, 500));
#           }
#         }
#         return nativeFetch(...args);
#       }
#     </script>
#   </body>
# </html>
