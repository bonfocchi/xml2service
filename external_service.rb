class ExternalService
  ONE_MEGA_BYTE = 1_048_576.0

  def initialize
    @batch_num = 0
  end

  def call(batch)
    @batch_num += 1
    pretty_print(batch)
  end

  private

  def pretty_print(batch)
    products = JSON.parse(batch)
    puts format("\e[1mReceived batch%4d\e[22m", @batch_num)
    puts format('Size: %10.2fMB', (batch.bytesize / ONE_MEGA_BYTE))
    puts format('Products: %8d', products.size)
    puts "\n"
  end
end