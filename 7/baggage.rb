def rule(data)
  base, nested = data.split('contain')
  {
    base: base.strip.gsub(/\sbag[s]?/, ''),
    contains: nested.include?('no other bags') ? [] : nested.split(',').map { |n| { quantity: n.strip[0].to_i, color: n[2..].gsub(/^\W|\.|(\sbag[s]?)/, '') } }
  }
end

def usable_bags(rules, color)
  colors = []
  rules.each do |rule|
    colors << rule[:base] if rule[:contains].select { |c| c[:color] == color }.any?
  end
  if colors.any?
    colors << colors.map { |c| usable_bags(rules, c) }
  end
  colors.flatten.uniq
end

def required_bags(rules, color, quantity=1)
  current_bag = rules.select { |r| r[:base] == color }.first

  current_bag[:contains].each do |bag|
    quantity += bag[:quantity] * required_bags(rules, bag[:color])
  end

  quantity
end

color = 'shiny gold'

rules = File.readlines('input.txt', chomp: true).map { |line| rule(line) }

p usable_bags(rules, color).count

p required_bags(rules, color) - 1
