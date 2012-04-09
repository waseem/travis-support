require 'spec_helper'

if RUBY_PLATFORM != 'java'

  describe Travis::Amqp::Publisher do
    let(:connection) { Travis::Amqp.connection }
    let(:message)    { queue.pop(:nowait => false) }
    let(:publisher)  { Travis::Amqp::Publisher.new('reporting') }
    let!(:queue) do
      queue = connection.queue('reporting', :durable => true, :exclusive => false)
      exchange = connection.exchange('reporting.jobs.1', :durable => true, :type => :topic, :auto_delete => false)
      queue.bind(exchange, :key => 'reporting')
      queue
    end

    before do
      Travis::Amqp.config = { :host => 'localhost' }
    end

    it "encodes the data as json" do
      publisher.publish({})
      message.should_not == nil
      message[:payload].should == "{}"
    end

    it "defaults to a direct type" do
      publisher.type.should == "direct"
    end
  end

end
