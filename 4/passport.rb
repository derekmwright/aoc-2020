class Passport
  include Comparable

  # Class Methods

  def self.attributes
    %i(byr iyr eyr hgt hcl ecl pid cid)
  end

  def self.validations
    {
      byr: { type: 'year', args: { min: 1920, max: 2002 }},
      iyr: { type: 'year', args: { min: 2010, max: 2020 }},
      eyr: { type: 'year', args: { min: 2020, max: 2030 }},
      hgt: { type: 'height', args: { units: %w(cm in), cm: { min: 150, max: 193 }, in: { min: 59, max: 76 }}},
      hcl: { type: 'color' },
      ecl: { type: 'values', args: { values: %w(amb blu brn gry grn hzl oth) }},
      pid: { type: 'numeric' },
      cid: { type: 'always' }
    }
  end

  attr_accessor *attributes

  def self.bulk_import(data)
    # <3 https://rubydoc.info/stdlib/core/Enumerable:slice_when
    data.slice_when {|cur, nxt| /\A\s*\z/ =~ cur && /\S/ =~ nxt }.map do |block|
      Passport.import(
        block.map { |b| b.gsub("\n", '') }.reject { |item| item.empty? }.join(' ')
      )
    end
  end

  def self.import(line)
    Passport.new(
      line.split(' ').map { |item| item.split(':', 2) }
      .inject({}) { |hash, values| hash[values[0].to_sym] = values[1]; hash }
    )
  end

  # Instance Methods

  def initialize(data)
    data.each {|key, value| self.send(("#{key}="), value)}
  end

  def keys
    self.instance_variables.map { |k| k.to_s.gsub('@', '').to_sym }
  end

  # Validations
  def validate(name, data)
    rule = Passport.validations[name]
    self.send("validate_#{rule[:type]}", name, rule[:args] ||= nil)
  end

  def validate_always(name, args)
    true
  end

  def validate_year(name, args)
    self.send(name).to_i.between?(args[:min], args[:max])
  end

  def validate_height(name, args)
    data = self.send(name)
    units = args[:units].join('|')
    if matched = data.match(/^(?<amount>[\d]{2,3})(?<unit>#{units})$/)
      min = args[matched[:unit].to_sym][:min]
      max = args[matched[:unit].to_sym][:max]
      return matched[:amount].to_i.between?(min, max)
    end
    false
  end

  def validate_color(name, args)
    self.send(name).match?(/^#[0-9a-f]{6}$/)
  end

  def validate_values(name, args)
    args[:values].include? self.send(name)
  end

  def validate_numeric(name, args)
    self.send(name).match?(/^[\d]{9}$/)
  end

  def valid?
    required = Passport.attributes - [:cid]
    unless required.all? { |a| self.keys.include? a }
      return false
    end
    self.keys.all? do |key|
      self.validate(key, self.send(key))
    end
  end
end

passports = File.readlines('input.txt')
passports = Passport.bulk_import(passports)
p passports.select { |p| p.valid? }.count
