def parse(data)
    (convert(data[0..6], 'F', 'B') * 8) +
    convert(data[7..9], 'L', 'R')
end

def convert(data, off_char, on_char)
  data.scan(/[#{off_char}|#{on_char}]/).map { |c| c == off_char ? 0 : 1 }.join('').to_i(2)
end

seats = File.readlines('input.txt').map { |s| parse(s) }.sort
p seats.last

parted_seats = seats.slice_when {|i, j| i+1 != j }.to_a
p (parted_seats.first.last..parted_seats.last.first).to_a[1]
