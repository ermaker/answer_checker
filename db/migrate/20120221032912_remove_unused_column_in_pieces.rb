class RemoveUnusedColumnInPieces < ActiveRecord::Migration
  def change
    remove_column :pieces, :file_content_type
    remove_column :pieces, :file_file_size
    remove_column :pieces, :file_updated_at
  end
end
