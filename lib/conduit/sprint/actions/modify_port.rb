require_relative 'base'

module Conduit::Driver::Sprint
  class ModifyPort < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleWnpService/v1'
    xsd                 'WholesaleWnp/v1/PortEnvelope.xsd'
    operation           :modify_port_in
    optional_attributes :mdn, :port_id, :desired_due_date_time, :first_name, :last_name,
                        :business_name, :street_number, :street_name, :street_direction,
                        :city, :state, :ssn, :tax_id, :account_number, :password, :zip
    required_attributes :remark
  end
end
