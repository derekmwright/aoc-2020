def findtwo(ary, locate)
  data = ary.clone
  while a = data.shift do
    b = data.select { |n| n + a == locate }
    return [a, b.first] if b.any?
  end
end

def findthree(ary, locate)
  data = ary.clone
  while a = data.shift do
    b = findtwo(ary.clone - [a], locate - a)
    return [a, b].flatten if b
  end
end

report = File.readlines('input.txt', chomp: true).map!(&:to_i)

p findtwo(report, 2020).inject(:*)
p findthree(report, 2020).inject(:*)
