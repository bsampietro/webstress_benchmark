#!/usr/bin/ruby

require 'net/http'
require 'uri'

#ARGV[0].to_i.times do |i|
#  ini = Time.now
#  Net::HTTP.get URI.parse(ARGV[1])
#  fin = Time.now
#  puts "#{i + 1} request: #{fin - ini}"
#end

def prom(array)
  sum = 0
  array.each{|num| sum += num}
  sum / array.length
end



if ARGV.length != 2
  puts "wrong number of arguments"
  exit  
elsif ARGV[0] !~ /\A\d+\Z/
  puts "first argument should be a number"
  exit
else
  concurrent = ARGV[0].to_i
  uri = URI.parse(ARGV[1])
end
  

thrs = []
request_times = []

puts "starting concurrent..."

total_concurrent_ini = Time.now

concurrent.times do |i|
  thrs << Thread.new do
    ini = Time.now
    Net::HTTP.get uri
    fin = Time.now
    request_time = fin - ini
    puts "#{i + 1} request: #{request_time.to_f}"
    request_times << request_time.to_f
  end  
end
thrs.each {|thr| thr.join}

total_concurrent_fin = Time.now

total_time = total_concurrent_fin - total_concurrent_ini

average_request_time = prom(request_times)

puts ""

puts "Total time: #{total_time} to make #{concurrent} concurrent requests"

puts "Average request time: #{average_request_time}"

puts "Average requests/second: #{concurrent/total_time.to_f}"

puts "Average seconds/request: #{total_time.to_f/concurrent}"

puts ""

