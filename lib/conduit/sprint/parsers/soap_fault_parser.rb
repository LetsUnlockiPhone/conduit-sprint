# This class takes a savon soap fault exception
# and maps out a simpler error hash.
#
class SoapFaultParser
  def initialize(savon_soap_fault)
    @fault = savon_soap_fault
  end

  def self.parse(savon_soap_fault)
    parser = new(savon_soap_fault)
    if parser.has_provider_errors?
      parser.parse_provider_errors
    else
      parser.parse_generic_fault
    end
  end

  def parse_provider_errors
    unparsed_provider_errors.map do |provider_error|
      {
        code: provider_error[:provider_error_code],
        message: provider_error[:provider_error_text]
      }
    end
  end

  def parse_generic_fault
    wrap
      {
        code: fault_hash[:faultcode],
        message: fault_hash[:faultstring]
      }
  end

  def has_provider_errors?
    fault_hash.has_key?(:detail)
  end

  private

  def fault_hash
    @fault.to_hash[:fault]
  end

  def unparsed_provider_errors
    wrap fault_hash[:detail][:error_detail_item][:provider_error]
  end

  def wrap(object)
    object.is_a?(Array) ? object : [object]
  end
end
