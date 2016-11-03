Given(/^an empty instance of Acropolis$/) do
  # Check DB or Quilt /everything
  puts ""
end

When(/^we ingest the data dump "(.*?)"$/) do |file|
  # POST the file to be ingested
  http = Net::HTTP.new('twine', 8000)
  request = Net::HTTP::Post.new("/ingest")
  request.add_field('Content-Type', 'text/x-nquads')
  request.body = IO.read(file)
  response = http.request(request)
  
  # Print the logs
  a = response.body()
  puts "#{a}"

  # Assert if the response was OK
  expect(response).to be_a(Net::HTTPOK)
end

Then(/^a proxy resource for "(.*?)" is created$/) do |name|
  # Do a URI query to Quilt
  pending # express the regexp above with the code you wish you had
end