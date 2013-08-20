require 'bunny'
require 'spec_helper'

module Sonic
  describe ServiceChecker do
    context "create" do
      context "with valid http arguments" do
        let(:protocol)  { :http }
        let(:host) { "localhost" }
        let(:port) { 8081 }

        subject(:service_checker) { ServiceChecker.new(protocol, host, port) }
        it { should be_kind_of ServiceChecker }

        describe "attributes" do
          its(:protocol) { should be_kind_of(Symbol) }
          its(:host)     { should be_kind_of(String) }
          its(:port)     { should be_kind_of(Integer) }
        end

        context "with responding service" do
          let(:uri) { "#{protocol}://#{host}:#{port}" }
          before { stub_request(:get, uri) }

          describe '#check_service' do
            subject { service_checker.check_service }
            it { should be_true }
          end

          context "with a valid response from service" do
            before { service_checker.check_service }
            describe '#response' do
              subject { service_checker.response }
              it { should_not be_nil }
            end
            describe '#error' do
              subject { service_checker.error }
              it { should be_nil }
            end
          end

          context "with an invalid response from service" do
            before { stub_request(:get, uri).to_return(:status => 500) }
            before { service_checker.check_service }
            describe '#response' do
              subject { service_checker.response }
              it { should_not be_nil }
            end
            describe '#error' do
              subject { service_checker.error }
              it { should == "service error" }
            end
          end
        end

        context "without a responding service" do
          let(:uri) { "#{protocol}://#{host}:#{port}" }
          before { stub_request(:get, uri).to_raise(SocketError) }

          describe '#check_service' do
            subject { service_checker.check_service }
            it { should be_false }
          end

          context "successfuly checked down service" do
            before { service_checker.check_service }
            describe '#response' do
              subject { service_checker.response }
              it { should be_nil }
            end
            describe '#error' do
              subject { service_checker.error }
              it { should == "Exception from WebMock" }
            end
          end
        end

      end

      context "with valid tcp arguments" do
        let(:protocol)  { :tcp }
        let(:host) { "localhost" }
        let(:port) { 6667 }
        let(:payload) { "test" }

        subject(:service_checker) { ServiceChecker.new(protocol, host, port, nil, payload) }
        it { should be_kind_of ServiceChecker }

        describe "attributes" do
          its(:protocol) { should be_kind_of(Symbol) }
          its(:host)     { should be_kind_of(String) }
          its(:port)     { should be_kind_of(Integer) }
          its(:payload)  { should be_kind_of(String) }
        end

        context "with responding service" do
          describe '#check_service' do
            before(:each) do
              double_socket = double(TCPSocket)
              TCPSocket.stub(:new).with(host, port).and_return(double_socket)
              double_socket.stub(:syswrite).with(payload).and_return(true)
              double_socket.stub(:sysread).with(1).exactly(6).times.and_return("hello\n")
              double_socket.stub(:close)
            end

            subject { service_checker.check_service }
            it { should be_true }

            describe '#response' do
              before { service_checker.check_service }
              subject { service_checker.response }
              it { should == "hello\n" }
            end
          end
        end

        context "without responding service" do
          describe '#check_service' do
            subject { service_checker.check_service }
            it { should be_false }
          end

          context "successfuly checked down service" do
            before { service_checker.check_service }
            describe '#response' do
              subject { service_checker.response }
              it { should be_nil }
            end
            describe '#error' do
              subject { service_checker.error }
              it { should == "Connection refused - connect(2)" }
            end
          end
        end

      end

      context "with valid amqp arguments" do
        let(:protocol)  { :amqp }
        let(:host) { "localhost" }
        let(:port) { 567222 }

        subject(:service_checker) { ServiceChecker.new(protocol, host, port) }
        it { should be_kind_of ServiceChecker }

        describe "attributes" do
          its(:protocol) { should be_kind_of(Symbol) }
          its(:host)     { should be_kind_of(String) }
          its(:port)     { should be_kind_of(Integer) }
        end

        context "with responding service" do
          describe '#check_service' do
            before(:each) do
              double_bunny = double(::Bunny)
              double_bunny.stub(:start)
              double_bunny.stub(:status).and_return(:open)
              double_bunny.stub(:close).and_return(:closed)
              ::Bunny.stub(:new).with({:host => host, :port => port}).and_return(double_bunny)
            end

            subject { service_checker.check_service }
            it { should be_true }

            describe '#response' do
              before { service_checker.check_service }
              subject { service_checker.response }
              it { should == :open }
            end
          end
        end

        context "without responding service" do
          describe '#check_service' do
            subject { service_checker.check_service }
            it { should be_false }
          end

          context "successfuly checked down service" do
            before { service_checker.check_service }
            describe '#response' do
              subject { service_checker.response }
              it { should be_nil }
            end
            describe '#error' do
              subject { service_checker.error }
              it { should == "Could not establish TCP connection to localhost:567222: " }
            end
          end
        end

      end

    end
  end
end
