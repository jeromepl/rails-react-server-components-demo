class RscController < ApplicationController
  include ActionController::Live

  # def show
  #   render plain: Component.new.serialize!
  #   # render plain: <<~STRING
  #   #   1:I{"id":"./src/SearchField.js","chunks":["client2"],"name":""}
  #   #   2:I{"id":"./src/EditButton.js","chunks":["client0"],"name":""}
  #   #   3:"$Sreact.suspense"
  #   #   0:["$","div",null,{"className":"main","children":[["$","section",null,{"className":"col sidebar","children":[["$","section",null,{"className":"sidebar-header","children":[["$","img",null,{"className":"logo","src":"logo.svg","width":"22px","height":"20px","alt":"","role":"presentation"}],["$","strong",null,{"children":"React Notes"}]]}],["$","section",null,{"className":"sidebar-menu","role":"menubar","children":[["$","$L1",null,{}],["$","$L2",null,{"noteId":null,"children":"New"}]]}],["$","nav",null,{"children":["$","$3",null,{"fallback":["$","div",null,{"children":["$","ul",null,{"className":"notes-list skeleton-container","children":[["$","li",null,{"className":"v-stack","children":["$","div",null,{"className":"sidebar-note-list-item skeleton","style":{"height":"5em"}}]}],["$","li",null,{"className":"v-stack","children":["$","div",null,{"className":"sidebar-note-list-item skeleton","style":{"height":"5em"}}]}],["$","li",null,{"className":"v-stack","children":["$","div",null,{"className":"sidebar-note-list-item skeleton","style":{"height":"5em"}}]}]]}]}],"children":"$L4"}]}]]}],["$","section","null",{"className":"col note-viewer","children":["$","$3",null,{"fallback":["$","div",null,{"className":"note skeleton-container","role":"progressbar","aria-busy":"true","children":[["$","div",null,{"className":"note-header","children":[["$","div",null,{"className":"note-title skeleton","style":{"height":"3rem","width":"65%","marginInline":"12px 1em"}}],["$","div",null,{"className":"skeleton skeleton--button","style":{"width":"8em","height":"2.5em"}}]]}],["$","div",null,{"className":"note-preview","children":[["$","div",null,{"className":"skeleton v-stack","style":{"height":"1.5em"}}],["$","div",null,{"className":"skeleton v-stack","style":{"height":"1.5em"}}],["$","div",null,{"className":"skeleton v-stack","style":{"height":"1.5em"}}],["$","div",null,{"className":"skeleton v-stack","style":{"height":"1.5em"}}],["$","div",null,{"className":"skeleton v-stack","style":{"height":"1.5em"}}]]}]]}],"children":"$L5"}]}]]}]
  #   #   5:["$","div",null,{"className":"note--empty-state","children":["$","span",null,{"className":"note-text--empty-state","children":"Click a note on the left to view something! 🥺"}]}]
  #   #   6:I{"id":"./src/SidebarNoteContent.js","chunks":["client3"],"name":""}
  #   #   4:["$","ul",null,{"className":"notes-list","children":[["$","li","8",{"children":["$","$L6",null,{"id":8,"title":"Untitled1","expandedChildren":["$","p",null,{"className":"sidebar-note-excerpt","children":["$","i",null,{"children":"(No content)"}]}],"children":["$","header",null,{"className":"sidebar-note-header","children":[["$","strong",null,{"children":"Untitled1"}],["$","small",null,{"children":"1:55 AM"}]]}]}]}],["$","li","7",{"children":["$","$L6",null,{"id":7,"title":"Untitled1","expandedChildren":["$","p",null,{"className":"sidebar-note-excerpt","children":["$","i",null,{"children":"(No content)"}]}],"children":["$","header",null,{"className":"sidebar-note-header","children":[["$","strong",null,{"children":"Untitled1"}],["$","small",null,{"children":"1:54 AM"}]]}]}]}],["$","li","6",{"children":["$","$L6",null,{"id":6,"title":"Is this working2","expandedChildren":["$","p",null,{"className":"sidebar-note-excerpt","children":"Yes it is!"}],"children":["$","header",null,{"className":"sidebar-note-header","children":[["$","strong",null,{"children":"Is this working2"}],["$","small",null,{"children":"1:48 AM"}]]}]}]}],["$","li","5",{"children":["$","$L6",null,{"id":5,"title":"2Test","expandedChildren":["$","p",null,{"className":"sidebar-note-excerpt","children":"This is my great note!"}],"children":["$","header",null,{"className":"sidebar-note-header","children":[["$","strong",null,{"children":"2Test"}],["$","small",null,{"children":"1:34 AM"}]]}]}]}],["$","li","4",{"children":["$","$L6",null,{"id":4,"title":"I wrote this note today","expandedChildren":["$","p",null,{"className":"sidebar-note-excerpt","children":"It was an excellent note."}],"children":["$","header",null,{"className":"sidebar-note-header","children":[["$","strong",null,{"children":"I wrote this note today"}],["$","small",null,{"children":"1:14 AM"}]]}]}]}],["$","li","3",{"children":["$","$L6",null,{"id":3,"title":"Make a thing","expandedChildren":["$","p",null,{"className":"sidebar-note-excerpt","children":"It's very easy to make some words bold and other words italic with Markdown. You can even link to React's..."}],"children":["$","header",null,{"className":"sidebar-note-header","children":[["$","strong",null,{"children":"Make a thing"}],["$","small",null,{"children":"3/1/23"}]]}]}]}],["$","li","2",{"children":["$","$L6",null,{"id":2,"title":"A note with a very long title because sometimes you need more words","expandedChildren":["$","p",null,{"className":"sidebar-note-excerpt","children":"You can write all kinds of amazing notes in this app! These note live on the server in the notes..."}],"children":["$","header",null,{"className":"sidebar-note-header","children":[["$","strong",null,{"children":"A note with a very long title because sometimes you need more words"}],["$","small",null,{"children":"1/29/23"}]]}]}]}],["$","li","1",{"children":["$","$L6",null,{"id":1,"title":"Meeting Notes","expandedChildren":["$","p",null,{"className":"sidebar-note-excerpt","children":"This is an example note. It contains Markdown!"}],"children":["$","header",null,{"className":"sidebar-note-header","children":[["$","strong",null,{"children":"Meeting Notes"}],["$","small",null,{"children":"3/14/23"}]]}]}]}]]}]
  #   # STRING
  # end

  def show
    # response.headers['Content-Type'] = 'text/event-stream'
    # 100.times {
    #   response.stream.write "hello world\n"
    #   sleep 1
    # }
    props = JSON.parse(params[:location])
    Components::App.new.serialize!(selectedId: props["selectedId"], isEditing: props["isEditing"], searchText: props["searchText"]).each do |line|
      response.stream.write line
      # sleep 2
    end
    # sleep 5
  ensure
    response.stream.close
  end
end
