# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/rsc", type: :request do
  describe "GET /rsc" do
    it "renders the AppView" do
      get "/rsc", params: { location: { selectedId: nil, isEditing: false, searchText: "" }.to_json }
      expect(response).to have_http_status(200)
      expected = <<~JSX
        1:I{"id":"./src/SearchField.js","chunks":["client5"],"name":""}
        2:I{"id":"./src/EditButton.js","chunks":["client0"],"name":""}
        3:I{"id":"./src/NoteListSkeleton.js","chunks":["client2"],"name":""}
        4:I{"id":"./src/SidebarNote.js","chunks":["vendors-node_modules_marked_lib_marked_esm_js","vendors-node_modules_date-fns_esm_format_index_js-node_modules_date-fns_esm_isToday_index_js--d39eaa","client6"],"name":""}
        5:"$Sreact.suspense"
        6:I{"id":"./src/NoteSkeleton.js","chunks":["client4"],"name":""}
        0:["$","div",null,{"children":[["$","section",null,{"children":[["$","section",null,{"children":[["$","img",null,{"className":"logo","src":"logo.svg","width":"22px","height":"20px","alt":"","role":"presentation"}],["$","strong",null,{"children":["React Notes"]}]],"className":"sidebard-header"}],["$","section",null,{"children":[["$","$L1",null,{}],["$","$L2",null,{"children":["New"],"noteId":null}]],"className":"sidebar-menu","role":"menubar"}],["$","nav",null,{"children":[["$","$5",null,{"children":[["$","ul",null,{"children":[["$","li",1,{"children":[["$","$L4",null,{"note":{"id":1,"title":"Where did my DB go?","body":"","created_at":"2023-10-09T16:32:39.032Z","updated_at":"2023-10-09T16:32:39.032Z"}}]]}],["$","li",2,{"children":[["$","$L4",null,{"note":{"id":2,"title":"This is a second test","body":"With some content","created_at":"2023-10-09T16:32:49.058Z","updated_at":"2023-10-09T16:32:49.058Z"}}]]}],["$","li",3,{"children":[["$","$L4",null,{"note":{"id":3,"title":"Advent of code","body":"⭐️⭐️⭐️","created_at":"2023-10-09T16:33:02.337Z","updated_at":"2023-10-09T16:33:02.337Z"}}]]}]],"className":"notes-list"}]],"fallback":[["$","$L3",null,{}]]}]]}]],"className":"col sidebar"}],["$","section",null,{"children":[["$","$5",null,{"children":[["$","div",null,{"children":[["$","span",null,{"children":["Click a note on the left to view something! 🥺"],"className":"note-text--empty-state"}]],"className":"note--empty-state"}]],"fallback":[["$","$L6",null,{"is_editing":false}]]}]],"className":"col note-viewer"}]],"className":"main"}]
      JSX
      expect(response.body.split("\n")).to eq expected.split("\n")
    end
  end
end
