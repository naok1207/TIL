p '何本勝負か選択してください（press 1 or 3 or 5）'
numbers = gets
p numbers
if numbers == 1
  p '１本勝負が選択されました'
elsif numbers == 3
  p '３本勝負が選択されました'
elsif numbers == 5
  p '５本勝負が選択されました'
end

(1..numbers).each do |i|
  p "#{i}本目"
  p "じゃんけん...(press g or c or p)"
  input = gets
  cpu = ['グー', 'チョキ', 'パー']
  p "cpu... #{cpu.sample}"
  if input == "g"
    p 'あなた... グー'
  elsif input == 'c'
    p 'あなた... チョキ'
  elsif input == 'p'
    p 'あなた... パー'
  end
end
