RSpec.configure do |config|
  config.before(:example) do
    Time.stub_chain(:now, :utc) { Time.utc(2014, 1, 1, 0, 0, 0) }
    SecureRandom.stub(base64: '9999999999')
  end
end
