require_relative 'base'

module Conduit::Driver::Sprint
  class ModifyPort < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleWnpService/v1'
    xsd                 'WholesaleWnp/v1/PortEnvelope.xsd'
    operation           :modify_port_in
    optional_attributes :mdn, :external_port_number, :desired_due_date_time, :address1, :first_name, :last_name,
                        :business_name, :city, :state, :ssn, :tax_id, :carrier_account, :carrier_password, :zip, :remark
  end
end
