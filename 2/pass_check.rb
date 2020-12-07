class Password
  include Comparable

  PASS_REGEX = /^(?<pos1>[\d]+)-(?<pos2>[\d]+)\s+(?<char>[\w]):\s(?<password>[\w]+)$/

  attr_reader :matches

  def initialize(line)
    unless @matches = line.match(PASS_REGEX)
      return false
    end
  end

  def old_valid?
    return @matches[:password]
      .count(@matches[:char])
      .between?(@matches[:pos1].to_i, @matches[:pos2].to_i)
  end

  def valid?
    return (
      (@matches[:password][@matches[:pos1].to_i - 1] <=> @matches[:char]) +
      (@matches[:password][@matches[:pos2].to_i - 1] <=> @matches[:char])
    ).abs == 1
  end
end

passwords = File.readlines('input.txt', chomp: true)
passwords.map! { |p| Password.new(p) }

p passwords.select { |p| p.old_valid? }.count
p passwords.select { |p| p.valid? }.count
