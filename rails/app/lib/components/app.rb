module Components
  class App < Component
    attr_reader :selectedId, :isEditing, :searchText

    def initialize(selectedId:, isEditing:, searchText:)
      @selectedId = selectedId
      @isEditing = isEditing
      @searchText = searchText

      super()
    end

    def render
      div className: 'main' do
        section className: 'col sidebar' do
          section className: 'sidebar-header' do
            img className: 'logo', src: 'logo.svg', width: '22px', height: '20px', alt: '', role: 'presentation'
            strong { 'React Notes' }
          end
          section className: 'sidebar-menu', role: 'menubar' do
            search_field
            edit_button noteId: nil do
              'New'
            end
          end
          nav do
            suspense fallback: note_list_skeleton do
              NoteList.new(searchText: searchText)
            end
          end
        end
        section key: selectedId, className: 'col note-viewer' do
          suspense fallback: note_skeleton(isEditing: isEditing) do
            Note.new(selectedId: selectedId, isEditing: isEditing)
          end
        end
      end
    end
  end
end