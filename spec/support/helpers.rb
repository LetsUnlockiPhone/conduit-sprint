module Helpers
  def credentials
    {}.tap do |credentials|
      credentials[:application_id] = '2013020701'
      credentials[:application_user_id] = 'MOBILENET'
      credentials[:cert] = File.read('./spec/fixtures/security/cert.pem')
      credentials[:key] = File.read('./spec/fixtures/security/key.pem')
    end
  end
end

RSpec.configure do |config|
  config.include Helpers
end
