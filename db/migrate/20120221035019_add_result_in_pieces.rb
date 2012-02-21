class AddResultInPieces < ActiveRecord::Migration
  def change
    add_column :pieces, :result_file_name, :string
  end
end
