module Conduit
  module Driver
    module Sprint
      extend Conduit::Core::Driver

      required_credentials :application_id, :application_user_id, :cert, :key

      action :activate
      action :change
      action :change_device
      action :change_number
      action :deactivate
      action :hotline
      action :query_csa
      action :query_subscription
      action :restore
      action :suspend
    end
  end
end