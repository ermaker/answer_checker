class Piece < ActiveRecord::Base
  belongs_to :problem
  has_attached_file :file
end
