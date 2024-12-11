require 'open3'
require 'benchmark'


RSpec.describe 'script.rb' do
  let(:script_path) { 'assignment.rb' }
  let(:test_file) { 'feed.xml' }

  it 'processes a large XML file within reasonable time' do

    time = Benchmark.measure do
      stdout, stderr, status = Open3.capture3("ruby #{script_path} #{test_file}")
    end

    expect(time.real).to be < 10.0 # Expect processing to complete in under 10 seconds
    end

end
