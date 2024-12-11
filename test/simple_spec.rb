require 'open3'

RSpec.describe 'script.rb' do
  let(:script_path) { 'assignment.rb' }
  let(:test_file) { 'test/feed_min.xml' }

  it 'processes the XML file and outputs expected result' do
    stdout, stderr, status = Open3.capture3("ruby #{script_path} #{test_file}")

    expect(status.success?).to be true
    expect(stderr).to eq("")
    expect(stdout).to include("Received batch   1", "Size:       0.02MB", "Products:       55")
  end

end