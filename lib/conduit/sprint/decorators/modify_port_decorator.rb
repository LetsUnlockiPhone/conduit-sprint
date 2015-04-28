require_relative 'base'

module Conduit::Sprint::Decorators
  class ModifyPortDecorator < Base

    def modify_port_xml
      data = {}
      root = { 'sub:modifyPortIn' => data }

      add_identification_key(data)
      add_zip_key(data)
      data['sub:timeZone']         = 'CST'
      data['sub:remark']           = modify_port_remark
      data['sub:billFirstName']    = first_name       if !first_name.nil? && !first_name.empty?
      data['sub:billLastName']     = last_name        if !last_name.nil? && !last_name.empty?
      data['sub:businessName']     = business_name    if !business_name.nil? && !business_name.empty?
      data['sub:billStreetNumber'] = street_number    if !street_number.nil? && !street_number.empty?
      data['sub:billStreetName']   = street_name      if !street_name.nil? && !street_name.empty?
      data['sub:billCityName']     = city             if !city.nil? && !city.empty?
      data['sub:billStateCode']    = state            if !state.nil? && !state.empty?
      data['sub:ssn']              = ssn              if !ssn.nil? && !ssn.empty?
      data['sub:taxId']            = tax_id           if !tax_id.nil? && !tax_id.empty?
      data['sub:accountNumber']    = carrier_account  if !carrier_account.nil? && !carrier_account.empty?
      data['sub:passwordPin']      = carrier_password if !carrier_password.nil? && !carrier_password.empty?
      data['sub:desiredDueDateTime']           = desired_due_date_time if !desired_due_date_time.nil? && !desired_due_date_time.empty?
      data['sub:billStreetDirectionIndicator'] = street_direction      if !street_direction.nil? && !street_direction.empty?

      Gyoku.xml(root)
    end

    private

    def add_identification_key(data)
      if !external_port_number.nil? && external_port_number
        data['sub:portId'] = external_port_number
      elsif !mdn.nil? && !mdn.empty?
        data['sub:mdn']    = mdn
      end
    end

    def add_zip_key(data)
      if !zip.nil? && !zip.empty?
        zip_data = { 'sub:uspsPostalCd' => zip }
        data['sub:zip'] = zip_data
      end
    end

    def modify_port_remark
      remark || 'modify_port'
    end
  end
end
