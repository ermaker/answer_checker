class Piece < ActiveRecord::Base
  belongs_to :problem
  has_attached_file :source,
    :url => '/system/R/:fingerprint.R'
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
    output = Dir.mktmpdir do |tmpdir|
      Open3.popen3("cd #{Rails.root}/db/lab1; R --slave --vanilla") do |i,o,e,t|
        i.puts File.read(source.path)
        i.puts File.read("#{Rails.root}/db/lab1/run.R")
        i.close
        o.read
      end
    end
    output = output.scan(/=begin\n(.*?)=end/m).join
    self.result = StringIO.new(output)
    save!
  end
  handle_asynchronously :generate_result_with_delay

  private
  def url_of_result
    "/system/result/#{source_fingerprint}.result"
  end
end
