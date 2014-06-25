# This class takes a savon soap fault exception
# and maps out a simpler error hash.
#
class ProviderErrorParser
  def initialize(savon_soap_fault)
    @fault = savon_soap_fault
  end

  def self.parse(savon_soap_fault)
    new(savon_soap_fault).provider_errors
  end

  def provider_errors
    unparsed_provider_errors.map do |provider_error|
      {
        code: provider_error[:provider_error_code],
        message: provider_error[:provider_error_text]
      }
    end
  end

  private

  def unparsed_provider_errors
    @fault.to_hash[:fault][:detail][:error_detail_item][:provider_error]
  end
end
