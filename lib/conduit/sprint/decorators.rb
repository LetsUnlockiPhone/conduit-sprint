mocks = File.join(File.dirname(__FILE__), 'decorators', '*.rb')
Dir.glob(mocks) { |fname| require fname }