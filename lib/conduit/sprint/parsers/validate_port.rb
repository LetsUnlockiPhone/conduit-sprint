require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class ValidatePort::Parser < Parser::Base
    attribute :mdn

    attribute :status do
      content_for '//ppvStatus'
    end

    attribute :message do
      content_for '//ppvStatusText'
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
  end
end
