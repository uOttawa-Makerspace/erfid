require 'json'
require 'faraday'
require 'nfc'

def config
  @config ||= JSON.parse(File.read("config.json"))
end

def read_card
  return "deadbeef"
  tag = @device.select #will block
  return tag.to_s
end

def send_card(card_number)
  response = Faraday.post(
    config["url"],
    { rifd: card_number }
  )
  response.success?
end

def log(message)
  puts "#{Time.now} | #{message}"
end

def setup
  @context = NFC::Context.new
  @reader = @context.open(nil)
end

trap('INT') {
  log("Shutting down")
  exit
}

#setup

loop do
  card = read_card
  log("Read card: #{card}")
  if send_card(card)
    log("Successfully sent #{card}")
  else
    log("ERROR: invalid response code for #{card}")
  end
end
