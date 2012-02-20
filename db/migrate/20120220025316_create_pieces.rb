class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.references :problem
      t.has_attached_file :file
      t.string :comment

      t.timestamps
    end
  end
end
