class RenameFileColumnInPieces < ActiveRecord::Migration
  def change
    rename_column :pieces, :file_file_name, :source_file_name
    rename_column :pieces, :file_fingerprint, :source_fingerprint
  end
end
