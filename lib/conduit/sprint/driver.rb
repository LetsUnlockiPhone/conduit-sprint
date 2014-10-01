module Conduit
  module Driver
    module Sprint
      extend Conduit::Core::Driver

      required_credentials :application_id, :application_user_id, :cert, :key, :mode

      action :activate
      action :change
      action :change_device
      action :change_number
      action :deactivate
      action :hotline
      action :check_coverage
      action :query_subscription
      action :restore
      action :suspend
      action :transfer_ownership
    end
  end
end
