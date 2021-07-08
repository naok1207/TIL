# require 'byebug'
require 'benchmark'

N = 1000
numbers = 10000.times.map{ rand }

# N = gets.to_i
# numbers = gets.split.map(&:to_i)

Benchmark.bm 10 do |r|
  r.report "map!" do
numbers_half_count = N / 2 + N % 2
count = 0

numbers_half_count.times do
    if numbers[1] != numbers[-1]
      x = numbers.shift
      y = numbers.pop
      numbers.map!{|num| num == x ? y : num}
        count += 1
    else
      numbers.shift
      numbers.pop
    end
end
  end
end
# puts count
