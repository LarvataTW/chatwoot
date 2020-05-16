class Integrations::Slack::ChannelBuilder
  attr_reader :params, :channel

  def initialize(params)
    @params = params
  end

  def perform
    create_channel
    update_reference_id
    #send_welcome_message
  end

  private

  def hook
    @hook ||= params[:hook]
  end

  def slack_client
    Slack.configure do |config|
      config.token = hook.access_token
    end
    Slack::Web::Client.new
  end

  def create_channel
    @channel = slack_client.conversations_create(name: params[:channel])
  end
  
  def update_reference_id
    @hook.reference_id = channel['channel']['id']
  end

  # def send_welcome_message
  #   client.chat_postMessage(channel: @hook.reference_id, text: 'Hello World')
  # end
end