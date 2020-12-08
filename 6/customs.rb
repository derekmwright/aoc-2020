def parse(data)
  data.slice_when { |cur, nxt| /\A\s*\z/ =~ cur && /\S/ =~ nxt }.to_a.map do |group|
    group.map { |g| g.gsub("\n", '').scan(/\w/)}.reject { |g| g.empty? }
  end
end

surveys = parse(File.readlines('input.txt'))
p surveys.map { |s| s.reduce([], :concat).uniq.length }.reduce(:+)

all_yes = []
surveys.each { |group|
  all_yes << group.reduce([], :concat).select { |a| group.join('').count(a) == group.count }.uniq.count
}
p all_yes.reduce(:+)
