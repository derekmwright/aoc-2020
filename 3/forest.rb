def check(data, x, y, start_x=0, start_y=0, result='')
  loc_x = start_x + x
  loc_y = start_y + y
  if loc_y < data.length
    result << data[loc_y][loc_x % data[loc_y].length]
    check(data, x, y, loc_x, loc_y, result)
  end
  result
end

forest = File.readlines('input.txt', chomp: true)

# Part 1
p check(forest, 3, 1).count('#')

# Part 2
slopes = [
  [1,1],
  [3,1],
  [5,1],
  [7,1],
  [1,2]
]

p slopes.map { |s| check(forest, s[0], s[1]).count('#') }.inject(:*)
