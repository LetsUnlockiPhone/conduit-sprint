require 'savon/mock/spec_helper'
require 'forwardable'
require 'erb'
require 'tilt'

module Conduit::Sprint::RequestMocker
  class Base
    include Savon::SpecHelper
    extend Forwardable

    FIXTURE_PREFIX = File.dirname(__FILE__) + '/fixtures/responses'.freeze

    def initialize(base, options = nil)
      @base = base
      @options = options
      @mock_status = options[:mock_status].to_sym
    end

    def mock
      savon.mock!
      savon.expects(@base.class.operation).
        with(signed_soap: @base.signed_soap_xml).returns(response)
    end

    def unmock
      savon.unmock!
    end

    def with_mocking
      mock and yield.tap { unmock }
    end

    private

    def render_response
      Tilt::ERBTemplate.new(fixture).render(@base.view_context, mock: MockHelpers.new)
    end

    def action_name
      ActiveSupport::Inflector.demodulize(self.class.name).underscore
    end

    def fixture
      FIXTURE_PREFIX + "/#{action_name}/#{@mock_status}.xml.erb"
    end

    def response
      if [:success, :fault, :error].include?(@mock_status)
        return error_response if @mock_status == :error
        render_response
      else
        raise(ArgumentError, "Mock status must be :success, :fault, or :error")
      end
    end

    def error_response
      {:code => 500, :headers => {}, :body => "Internal Server Error"}
    end
  end
end

class MockHelpers
  def mdn
    @mdn ||= 10.times.map { rand(0..9) }.join
  end

  def msid
    @msid ||= 15.times.map { rand(0..9) }.join
  end

  def serial_number
     @serial_number ||= 18.times.map { rand(0..9) }.join
  end

  def today
    Date.today
  end
end
