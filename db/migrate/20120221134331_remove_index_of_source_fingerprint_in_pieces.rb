class RemoveIndexOfSourceFingerprintInPieces < ActiveRecord::Migration
  def change
    remove_index :pieces, :file_fingerprint
  end
end
