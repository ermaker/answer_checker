
def definition
  <<-EOS
answer_checker_run = function(num_of_attr,num_of_domain,num_of_case)
{
  domain = paste('data/domain', num_of_attr, '_' , num_of_domain, sep='')
  train = paste('data/train', num_of_attr, '_', num_of_domain, '_', num_of_case, sep='')
  eval = paste('data/eval', num_of_attr, '_', num_of_domain, sep='')
  result = lab1(domain, train, eval)
  cat('=begin\\n')
  cat('* domain file *\\n')
  cat(readLines(domain), sep='\\n')
  cat('* train file *\\n')
  cat(readLines(train), sep='\\n')
  cat('* eval file *\\n')
  cat(readLines(eval), sep='\\n')
  cat('* result *\\n')
  print(result)
  cat('=end\\n')
}
  EOS
end

def functions
  Dir['data/train*_*_*'].map do |fn|
    if m = fn.match(%r{\Adata/train(\d+)_(\d+)_(\d+)\z})
      [m[1].to_i, m[2].to_i, m[3].to_i]
    end
  end.compact.sort.map do |num_of_attr,num_of_domain,num_of_case|
    "answer_checker_run(#{num_of_attr}, #{num_of_domain}, #{num_of_case})"
  end.join("\n")
end

puts definition
puts functions
