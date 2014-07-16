require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryCSA::Parser < Parser::Base
    attribute :csa
    attribute :npa
    attribute :nxx
    attribute :city
    attribute :state
    attribute :is3g
    attribute :affiliate_name
    attribute :confidence
    attribute :coverage_quality_cdma
    attribute :coverage_quality_iden
    attribute :evdo
    attribute :hybrid
    attribute :iden
    attribute :latitude
    attribute :longitude
    attribute :roam_digital

    attribute :zip do
      content_for '//uspsPostalCd'
    end

    attribute :zip4 do
      content_for '//uspsPostalCdExtension'
    end
  end
end
