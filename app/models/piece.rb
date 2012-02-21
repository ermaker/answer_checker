class Piece < ActiveRecord::Base
  belongs_to :problem
  has_attached_file :file,
    :url => '/system/:hash.R',
    :hash_secret => ''
  validates :problem, :presence => true
  validates_attachment_presence :file
  validates :file_fingerprint, :uniqueness => true
end
