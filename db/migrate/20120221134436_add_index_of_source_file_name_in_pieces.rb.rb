class AddIndexOfSourceFileNameInPieces < ActiveRecord::Migration
  def change
    add_index :pieces, :source_file_name, :unique => true
  end
end
