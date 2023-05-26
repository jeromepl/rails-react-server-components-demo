class AddNotes < ActiveRecord::Migration[7.0]
  def change
    create_table(:notes) do |t|
      t.column :title, :text
      t.column :body, :text

      t.timestamps
    end
  end
end
