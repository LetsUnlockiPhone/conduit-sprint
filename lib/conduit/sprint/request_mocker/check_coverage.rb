require 'conduit/sprint/request_mocker/base'

module Conduit::Sprint::RequestMocker
  class CheckCoverage < Base

    def fixture
      xml_file = @mock_status == :failure ? @mock_status : determine_success_xml
      FIXTURE_PREFIX + "/check_coverage/#{xml_file}.xml.erb"
    end

    def determine_success_xml
      if @options[:city] && @options[:state]
        'successful_city_state_response'
      elsif @options[:zip]
        'successful_zipcode_response'
      else
        raise NoMethodError, "Unable to determine which success response to use, zip or city state." 
      end
    end
  end
end
