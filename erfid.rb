require 'json'
require 'faraday'
require 'nfc'

## ERROR CODES
NO_TAG = -90
DISCONNECTED = -1

def read_config
  JSON.parse(File.read("config.json"))
end

def get_reader
  reader = NFC::Context.new.open(nil)
  log("Connected to #{reader.name}")
  return reader
rescue RuntimeError => e
  error(e)
end

def read_card(reader)
  tag = reader.poll(10,1)
  if tag == NO_TAG
    return nil
  elsif tag == DISCONNECTED
    error("Card reader error, shutting down")
  else
    return tag.to_s
  end
end

def send_card(card_number, config)
  Faraday.post(
    config["url"],
    { rifd: card_number }
  )
end

def log(message)
  puts "#{Time.now} | #{message}"
end

def error(message)
  log("ERROR: " + message)
  exit(-1)
end

#catch interupt and log shutdown
trap('INT') {
  log("Shutting down")
  exit
}

#######################################
#######################################
#                                     #
#             MAIN STUFF HERE         #
#                   |                 #
#                   |                 #
#                   V                 #
#                                     #
#######################################
#######################################

def main
  log("Staring up!")
  config = read_config()
  reader = get_reader()

  loop do
    card = read_card(reader)

    next unless card #failed to read card

    log("Read card: #{card}")

    response = send_card(card, config)

    if response.success?
      log("Successfully sent #{card}")
    else
      log("ERROR: got #{response.status} sending #{card}: #{response.body}")
    end
    sleep(1) #delay a bit to avoid double send
  end
end

# IT'S GO TIME
main()
