require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class CheckCoverage::Parser < Parser::Base
    attribute :csa
    attribute :npa
    attribute :nxx
    attribute :city
    attribute :state
    attribute :affiliate_name
    attribute :confidence
    attribute :coverage_quality_cdma
    attribute :coverage_quality_iden
    attribute :coverage_quality_lte
    attribute :coverage_quality_wi_max
    attribute :latitude
    attribute :longitude
    attribute :roam_digital_ind
    attribute :cdma_ind
    attribute :evdo_ind
    attribute :iden_ind
    attribute :wi_max_ind
    attribute :hpptt_ind
    attribute :hybrid_ind
    attribute :lte_ind
    attribute :airave_consumer_ind
    attribute :airave_enterprise_ind
    attribute :upcoming_coverage_cdma_ind
    attribute :upcoming_coverage_iden_ind


    attribute :zip do
      content_for '//uspsPostalCd'
    end

    attribute :zip4 do
      content_for '//uspsPostalCdExtension'
    end
  end
end
