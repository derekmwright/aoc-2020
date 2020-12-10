$stdout.sync = true

class Boot
  attr_reader :instructions
  attr_accessor :accumulator, :state

  def initialize(file)
    @commands = File.readlines('input.txt', chomp: true).map do |line|
      parse(line)
    end
    @accumulator = 0 # Main accumulator count
    @state = :init
  end

  def run(commands = @commands)
    @accumulator = 0 # Main accumulator count
    @state = :running
    @executed = []
    indexes = []
    location = 0

    while @state == :running do
      location = read(commands, indexes, location)
      indexes << location
    end
    self
  end

  def repair(name, replace)
    @commands.each_with_index do |cmd, index|
      if cmd[:cmd] == name
        copy = @commands.clone
        copy[index] = { cmd: replace, amt: copy[index][:amt] }
        run(copy)
      end
      return self if self.state == :completed
    end
    return self
  end

  def read(commands, visited, location)
    command = commands[location]

    if command[:cmd] == :acc
      @accumulator += command[:amt]
    end

    location += command[:cmd] == :jmp ? command[:amt] : 1

    if visited.include? location
      @state = :failed
    end

    if location >= commands.count
      @state = :completed
    end

    @executed << command
    location
  end

  def parse(line)
    {
      cmd: line[0..2].to_sym,
      amt: line[4..].to_i
    }
  end
end

p Boot.new('input.txt').run.accumulator

boot = Boot.new('input').repair(:jmp, :nop)
p boot.accumulator if boot.state == :completed
boot = Boot.new('input').repair(:nop, :jmp)
p boot.accumulator if boot.state == :completed
