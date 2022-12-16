# frozen_string_literal: true

# This class allows us to Decode Tokens
class TokenDecoder
  def initialize(token, aud)
    @token = token
    @aud = aud
    @iss = ENV['IDENTITY_PROVIDER_URL']
  end

  def decode
    JWT.decode(
      @token,
      Rails.configuration.x.oauth.hmac,
      false,
      {
        verify_iss: true,
        iss: @iss,
        verify_aud: true,
        aud: @aud,
        algorithm: 'HS256'
      }
    )
  rescue JWT::VerificationError
    puts 'verification error'
    raise
  rescue JWT::DecodeError
    puts 'bad stuff happened'
    raise
  end
end
