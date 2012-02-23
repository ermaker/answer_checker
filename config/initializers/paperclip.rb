module Paperclip
  module Interpolations
    def problem_id attachment, style_name
      attachment.instance.problem_id
    end
  end
end
