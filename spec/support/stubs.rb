RSpec.configure do |config|
  config.before(:example) do
    time = Time.utc(2014, 1, 1, 0, 0, 0)
    allow(Time).to receive_message_chain(:now, :utc).and_return(time)
    allow(SecureRandom).to receive(:base64).and_return('9999999999')
  end
end
