require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class ValidatePort::Parser < Parser::Base
    PORTABILITY_DIRECTION_INDICATOR_MAPPING = {
      'A' => 'Wireless to Wireless',
      'C' => 'Wireline to Wireless'
    }.freeze

    attribute :mdn

    attribute :status do
      content_for '//ppvStatus'
    end

    attribute :message do
      content_for '//ppvStatusText'
    end

    attribute :port_in_status do
      content_for '//portInStatus'
    end

    attribute :port_in_status_text do
      content_for '//portInStatusText'
    end

    attribute :port_id do
      content_for '//portId'
    end

    attribute :old_service_provider do
      content_for '//oldServiceProvider'
    end

    attribute :csa do
      content_for '//portCsa'
    end

    attribute :desired_due_date do
      content_for '//desiredDueDateTime'
    end

    attribute :number_portability_direction_indicator do
      content_for '//numberPortabilityDirectionIndicator'
    end

    attribute :number_portability_direction_indicator_description do
      idn = content_for '//numberPortabilityDirectionIndicator'
      PORTABILITY_DIRECTION_INDICATOR_MAPPING[idn] ? PORTABILITY_DIRECTION_INDICATOR_MAPPING[idn] : idn
    end
  end
end
