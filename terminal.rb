print "\e[2J" # \e[2J clears screen

MAX = 100
(1..MAX).each { |i|
  print "\e[H" # \e[H moves cursor to start

  # \e[0K rewrites current line
  puts "\e[0K" + "Counting to #{MAX}"
  puts "\e[0K" + "Current:    #{i}"

  $stdout.flush #empty out buffer
  sleep 0.1
}