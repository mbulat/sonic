require 'spec_helper'

module Sonic
  describe ServiceChecker do
    context "creating" do
      context "supplied appropriate arguments" do
        let(:protocol)  { :http }
        let(:host) { "localhost" }
        let(:port) { 8081 }
        subject(:service_checker) { ServiceChecker.new(protocol, host, port) }
        it { should be_kind_of ServiceChecker }

      end
    end
  end
end
