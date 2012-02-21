class AddFileFingerprintToPieces < ActiveRecord::Migration
  def change
    add_column :pieces, :file_fingerprint, :string
    add_index :pieces, :file_fingerprint, :unique => true
  end
end
