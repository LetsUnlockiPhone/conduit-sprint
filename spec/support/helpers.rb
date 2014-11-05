module Helpers
  def credentials
    {}.tap do |credentials|
      credentials[:application_id] = '2222333344'
      credentials[:application_user_id] = 'BEQUICK'
      credentials[:cert] = File.read('./spec/fixtures/security/cert.pem')
      credentials[:key] = File.read('./spec/fixtures/security/key.pem')
      credentials[:mock_status] = :success
    end
  end
end

RSpec.configure do |config|
  config.include Helpers
end
