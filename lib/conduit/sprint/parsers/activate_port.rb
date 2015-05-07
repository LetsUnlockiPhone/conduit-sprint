require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class ActivatePort::Parser < Parser::Base
    attribute :mdn
    attribute :msid
    attribute :effective_date
    attribute :csa
    attribute :esn_dec do
      parent_node = containing_node_content('serialType', 'E')
      content_for('//serialNumber', parent_node)
    end
    attribute :iccid do
      return nil unless parent_node = containing_node_content('serialType', 'U')
      content_for('//serialNumber', parent_node)
    end
    attribute :imsi do
      return nil unless parent_node = containing_node_content('serialType', 'U')
      content_for('//lteImsi', parent_node)
    end

    attribute :esn_type do
      content_for '//serialType'
    end

    attribute :msl do
      content_for '//masterSubsidyLock'
    end

    attribute :port_result do
      root.xpath('//portResult').inject({}) do |hash, attribute|
        {}.tap do |port_result|
          port_result[:mdn]                                    = content_for('mdn', attribute)
          port_result[:ppv_status]                             = content_for('ppvStatus', attribute)
          port_result[:ppv_status_text]                        = content_for('ppvStatusText', attribute)
          port_result[:port_in_status]                         = content_for('portInStatus', attribute)        
          port_result[:port_in_status_text]                    = content_for('portInStatusText', attribute)
          port_result[:port_number]                            = content_for('portId', attribute)
          port_result[:old_service_provider]                   = content_for('oldServiceProvider', attribute)
          port_result[:csa]                                    = content_for('portCsa', attribute)
          port_result[:desired_due_date_time]                  = content_for('desiredDueDateTime', attribute)
          port_result[:number_portability_direction_indicator] = content_for('numberPortabilityDirectionIndicator', attribute)
        end
      end
    end

    attribute :plan_code do
      content_for '//pricePlan//serviceCode'
    end

    attribute :service_records do
      root.xpath('//serviceRecord').map do |service_record|
        service_record_attributes(service_record)
      end
    end

    private

    def in_progress?
      true
    end

    def service_record_attributes(service_record = {})
      {}.tap do |service_record_details|
        service_record_details[:service_code]        = content_for('serviceCode', service_record)
        service_record_details[:effective_date]      = content_for('serviceEffectiveDate', service_record)
      end
    end
  end
end
