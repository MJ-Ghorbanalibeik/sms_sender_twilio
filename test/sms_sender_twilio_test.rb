require 'test_helper'

class SmsSenderTwilioTest < ActiveSupport::TestCase
  test_messages = [
    'This message has been sent from automated test 😎',
    'این پیام از آزمون خودکار فرستاده شده است 😎',
    'Automated test, more ascii 😎 آزمون خودکار',
    'Automated test 😎 بیشتر غیر اسکی ،آزمون خودکار'
  ]
  if !ENV['REAL'].blank? && ENV['REAL']
    WebMock.allow_net_connect!
  else
    # Config webmock for sending messages 
    test_messages.each do |m|
      request_body_header = {:body => {'To' => SmsSenderTwilio::Normalizer.normalize_number_e_164(ENV['mobile_number']), 'From' => SmsSenderTwilio::Normalizer.normalize_number_e_164(ENV['sender']), 'Body' => SmsSenderTwilio::Normalizer.normalize_message(m)}, :headers => {'Accept'=>'application/json', 'Accept-Charset'=>'utf-8', 'Content-Type'=>'application/x-www-form-urlencoded'}}
      WebMock::API.stub_request(:post, "https://#{ENV['account_sid']}:#{ENV['auth_token']}@api.twilio.com/2010-04-01/Accounts/#{ENV['account_sid']}/Messages.json").
        with(request_body_header).
        to_return(:status => 200, 
          :body => "{
            \"sid\": \"SMc781610ec0b3400c9e0cab8e757da937\",
            \"date_created\": \"Mon, 19 Oct 2015 07:07:03 +0000\",
            \"date_updated\": \"Mon, 19 Oct 2015 07:07:03 +0000\",
            \"date_sent\": null,
            \"account_sid\": \"#{ENV['account_sid']}\",
            \"to\": \"#{ENV['mobile_number']}\",
            \"from\": \"#{ENV['sender']}\",
            \"messaging_service_sid\": null,
            \"body\": \"#{m}\",
            \"status\": \"queued\",
            \"num_segments\": \"1\",
            \"num_media\": \"0\",
            \"direction\": \"outbound-api\",
            \"api_version\": \"2010-04-01\",
            \"price\": null,
            \"price_unit\": \"USD\",
            \"error_code\": null,
            \"error_message\": null,
            \"uri\": \"/2010-04-01/Accounts/#{ENV['account_sid']}/Messages/SMc781610ec0b3400c9e0cab8e757da937.json\",
            \"subresource_uris\": {
              \"media\": \"/2010-04-01/Accounts/#{ENV['account_sid']}/Messages/SMc781610ec0b3400c9e0cab8e757da937/Media.json\"
            }
          }", 
          :headers => {'Access-Control-Allow-Credentials' => true,
            'Access-Control-Allow-Headers' => 'Accept, Authorization, Content-Type, If-Match, If-Modified-Since, If-None-Match, If-Unmodified-Since',
            'Access-Control-Allow-Methods' => 'GET, POST, DELETE, OPTIONS',
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Expose-Headers' => 'ETag',
            'Content-Type' => 'application/json'
          }
        )
    end
  end

  test 'send test' do
    test_messages.each do |m|
      send_sms_result = SmsSenderTwilio.send_sms({'account_sid' => ENV['account_sid'], 'auth_token' => ENV['auth_token']}, ENV['mobile_number'], m, ENV['sender'])
      assert_not_equal send_sms_result[:message_id], nil
      assert_equal send_sms_result[:error], nil
    end
  end
end
