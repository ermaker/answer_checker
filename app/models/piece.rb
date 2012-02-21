class Piece < ActiveRecord::Base
  belongs_to :problem
  has_attached_file :source,
    :url => '/system/:fingerprint.R'
  has_attached_file :result,
    :url => :url_of_result
  validates :problem, :presence => true
  validates :source_file_name, :uniqueness => true
  validates_attachment_presence :source

  after_create :generate_result

  protected

  def generate_result
    result.assign(source.uploaded_file)
    save
  end

  private
  def url_of_result
    "/system/#{source_fingerprint}.result"
  end
end
