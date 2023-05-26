module Components
  class App < Dsl
    attr_reader :selectedId, :isEditing, :searchText

    def initialize
      @selectedId = nil
      @isEditing = false
      @searchText = ''

      super
    end

    def render
      div className: 'main' do
        [
          section(className: 'col sidebar') do
            [
              section(className: 'sidebar-header') do
                [
                  img(className: 'logo', src: 'logo.svg', width: '22px', height: '20px', alt: '', role: 'presentation'),
                  strong { 'React Notes' }
                ]
              end,
              section(className: 'sidebar-menu', role: 'menubar') do
                [
                  search_field,
                  edit_button(noteId: nil) { 'New' }
                ]
              end,
              nav do
                # Suspense fallback: {NoteListSkeleton /}
                NoteList.new(searchText: searchText)
                # /Suspense
              end
            ]
          end,
          section(key: selectedId, className: 'col note-viewer') do
            # Suspense fallback: {NoteSkeleton isEditing: {isEditing} /}
            note selectedId:, isEditing:
            # /Suspense
          end
        ]
      end
    end
  end
end