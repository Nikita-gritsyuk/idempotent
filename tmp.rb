# make 100 parallel http requests to the server
# each request should increment the value by random value from 0 to 100
# responce is a json with the following structure:
# {
#   status: 'ok',
#   total_amount: 123
# }
# script should check that the maximal total_amount received is equal to the sum of all random values



require 'net/http'
require 'json'

requests_count = 100
max_value = 100

threads = []
random_values = requests_count.times.map { rand(max_value) }
sum = random_values.sum

time = Time.now

random_values.each do |value|
    threads << Thread.new do
        uri = URI('http://localhost:3000/amounts/increment')
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = { value: value }.to_json
        Net::HTTP.start(uri.hostname, uri.port) do |http|
            http.request(req)
        end
    end
end

p "done"

max_result = threads.map(&:join).map do |result|
    JSON.parse(result.value.body)['total_amount'].to_i
end.max

puts "Time elapsed #{Time.now - time} seconds"
puts "Max value: #{max_value}"
puts "Sum of random values: #{sum}"
puts "Max result: #{max_result}"
puts "Test passed: #{sum == max_result}"
puts "average time per request(ms) #{(Time.now - time) / requests_count * 1000}"