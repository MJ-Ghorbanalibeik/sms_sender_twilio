require 'sms_sender_twilio/normalizer'
require 'twilio-ruby'

module SmsSenderTwilio
  def self.client(credentials)
    @client ||= Twilio::REST::Client.new credentials['account_sid'], credentials['auth_token']
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
end
