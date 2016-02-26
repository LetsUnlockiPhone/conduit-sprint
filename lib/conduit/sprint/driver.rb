module Conduit
  module Driver
    module Sprint
      extend Conduit::Core::Driver

      required_credentials :application_id, :application_user_id, :cert, :key
      optional_attributes  :mock_status, :test_environment

      action :activate
      action :activate_port
      action :cancel_port
      action :modify_port
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
      action :query_device_info
      action :query_port_message
      action :query_port_status
      action :query_subscription_usage
      action :validate_port
      action :add_foreign_device

    end
  end
end
