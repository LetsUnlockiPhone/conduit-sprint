mocks = File.join(File.dirname(__FILE__), 'request_mocker', '*.rb')
Dir.glob(mocks) { |fname| require fname }