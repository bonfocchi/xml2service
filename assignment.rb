require 'nokogiri'
require 'json'
require_relative 'external_service'

MAX_SIZE = 5 * 1024 * 1024 # 5 MB in bytes
DEAFULT_FILE = "./feed.xml"

def over_max_size?(current_size, new_item_size)
  current_size + new_item_size > MAX_SIZE
end

def process_xml(file_path)
  document = Nokogiri::XML(File.read(file_path))
  service = ExternalService.new

  # Define the namespace
  namespaces = {
    'g' => 'http://base.google.com/ns/1.0'
  }

  batch = []
  initial_batch_size = (batch.to_json.bytesize) -1 #subtracting 1 byte from the non-existing comma of the first item
  current_batch_size = initial_batch_size

  # Iterate through each <item> element
  document.xpath('//rss/channel/item', namespaces).each do |item|
    new_item = {
      id: item.at_xpath('g:id', namespaces)&.text,
      title: item.at('title')&.text,
      description: item.at('description')&.text
    }
    new_item_size = new_item.to_json.bytesize


    if over_max_size?(current_batch_size, new_item_size)
      service.call(batch.to_json)
      batch.clear
      current_batch_size = initial_batch_size
    end

    batch << new_item
    current_batch_size += new_item_size
    current_batch_size += 1 # adding the comma size (1 byte)
  end

  # Send remaining items in the batch
  if batch.any?
    service.call(batch.to_json)
  end
end


if $PROGRAM_NAME == __FILE__
  file_path = ARGV[0]
  file_path = DEAFULT_FILE if file_path.nil?

  process_xml(file_path)
end