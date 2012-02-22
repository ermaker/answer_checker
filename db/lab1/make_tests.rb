require 'pp'

def make_tests number_of_attribute, number_of_domain 
  attribute = ('A'...number_of_attribute.times.inject('A'){|r,|r=r.succ}).to_a
  domain = [attribute] * number_of_domain
  count = 0
  open("data/domain#{number_of_attribute}_#{number_of_domain}",'w') do |f|
    f << domain.map{|v| 'NAME ' + v.join(' ')}.join("\n")
  end
  candidates = domain.size > 1 ? domain.reduce(:product).map(&:flatten) : domain[0].product
  open("data/eval#{number_of_attribute}_#{number_of_domain}",'w') do |f|
    f<< candidates.map{|v| v.join(' ')}.join("\n")
  end
  candidates = (1..candidates.size).map do |n|
    target_value = n>1? ([%w[true false]]*n).reduce(:product).map(&:flatten) : [['true'], ['false']]
    result = candidates.combination(n).to_a
    
    result.each do |r|
      target_value.each do |tv|
        open("data/train#{number_of_attribute}_#{number_of_domain}_#{count+=1}", 'w') do |f|
          r.each_with_index do |rr,idx|
            f.puts rr.join(' ') + ' ' + tv[idx]
          end
        end
      end
    end
  end.flatten(1)
end

make_tests 2, 2
#make_tests 2, 3
