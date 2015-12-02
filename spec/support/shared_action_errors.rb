require 'spec_helper'

shared_examples_for "a 500 error" do  
  let(:response_errors) do
    [{ message: 'Unexpected response from server.' }]
  end
  
  subject                 { action.perform }
  its(:response_status)   { should eq 'failure' }
  its(:response_errors)   { should eq response_errors }
end
