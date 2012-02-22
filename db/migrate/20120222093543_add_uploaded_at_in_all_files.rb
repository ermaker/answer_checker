class AddUploadedAtInAllFiles < ActiveRecord::Migration
  def change
    add_column :pieces, :source_updated_at, :datetime
    add_column :pieces, :result_updated_at, :datetime
  end
end
