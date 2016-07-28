require 'sms_sender_twilio/normalizer'
require 'twilio-ruby'
require 'typhoeus/adapters/faraday'

module SmsSenderTwilio
  def self.supported_methods 
    ['send_sms', 'query_sms']
  end

  def self.client(credentials)
    @client ||= Twilio::REST::Client.new credentials['account_sid'], credentials['auth_token']
    @client.http_client.adapter = :typhoeus
    return @client
  end

  # According to documentation: 
  def self.send_sms(credentials, mobile_number, message, sender, options = nil)
    mobile_number_normalized = SmsSenderTwilio::Normalizer.normalize_number_e_164(mobile_number)
    sender_normalized = SmsSenderTwilio::Normalizer.normalize_number_e_164(sender)
    message_normalized = SmsSenderTwilio::Normalizer.normalize_message(message)
    response = client(credentials).api.account.messages.create({
      :from => sender_normalized, 
      :to => mobile_number_normalized, 
      :body => message_normalized,
    })
    if response.respond_to?(:sid)
      return { message_id: response.sid, code: 0 }
    else
      result = {error: response.error_message, code: error_code}
      raise result[:error]
      return result
    end
  end

  def self.query_sms(credentials, message_sid, options = nil)
    response = client(credentials).api.account.messages(message_sid).fetch
    return_hash = {
      'status' => response.status,
      'date_created' => response.date_created,
      'date_sent' => response.date_sent,
      'date_updated' => response.date_updated,
      'error_code' => response.error_code,
      'error_message' => response.error_message,
    }
    return return_hash
  end
end
