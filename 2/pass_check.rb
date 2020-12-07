class Password
  include Comparable

  PASS_REGEX = /^(?<pos1>[\d]+)-(?<pos2>[\d]+)\s+(?<char>[\w]):\s(?<password>[\w]+)$/

  attr_reader :pos1, :pos2, :char, :password

  def initialize(line)
    if matches = line.match(PASS_REGEX)
      @pos1 = matches[:pos1].to_i
      @pos2 = matches[:pos2].to_i
      @char = matches[:char]
      @password = matches[:password]
    else
      return false
    end
  end

  def old_valid?
    return @password.count(@char).between?(@pos1, @pos2)
  end

  def valid?
    return ((@password[@pos1-1] <=> @char) + (@password[@pos2-1] <=> @char)).abs == 1
  end
end

passwords = File.readlines('input.txt', chomp: true)
passwords.map! { |p| Password.new(p) }

p passwords.select { |p| p.old_valid? }.count
p passwords.select { |p| p.valid? }.count
