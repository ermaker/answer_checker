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
    generate_result_with_delay
  end

  def generate_result_with_delay
    self.result = File.open(source.path)
    save!
  end
  handle_asynchronously :generate_result_with_delay

  private
  def url_of_result
    "/system/#{source_fingerprint}.result"
  end
end
