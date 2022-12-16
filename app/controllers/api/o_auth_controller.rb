# frozen_string_literal: true

# This controller with User Authentication
module Api
  class OAuthController < ApplicationController
    def initialize
      @oauth_client = OAuth2::Client.new(ENV.fetch('IDENTITY_CLIENT_ID', nil),
                                         ENV.fetch('IDENTITY_CLIENT_SECRET', nil),
                                         authorize_url: '/connect/authorize',
                                         site: ENV.fetch('IDENTITY_PROVIDER_URL', nil),
                                         token_url: '/connect/token',
                                         redirect_uri: "#{ENV.fetch('HOST', nil)}/oauth/callback")
    end

    # The OAuth callback
    def oauth_callback
      # Make a call to exchange the authorization_code for an access_token
      response = @oauth_client.auth_code.get_token(params[:code])

      # Extract the access token from the response
      token = response.to_hash[:access_token]
      puts token
      # Decode the token
      begin
        decoded_jwt = TokenDecoder.new(token, @oauth_client.id).decode
      rescue StandardError => e
        puts "An unexpected exception occurred: #{e.inspect}"
        head :forbidden
        return
      end
      # Pick the Token body and ignore the Header
      decoded = decoded_jwt.first

      # Find or Create User
      @user = User.find_or_initialize_by(email: decoded['email'])

      @user.attributes = {
        password: decoded['sid'],
        sid: decoded['sid'],
        token:,
        identity_url: decoded['iss']
      }

      @user.save

      sign_in(@user)

    #   NashTreasuryJobs::UserBusinessJobs.perform_later(@user)
    rescue OAuth2::Error => e
      respond_to do |format|
        format.html { redirect_to root_path, alert: e.message }
      end
    # rescue Exceptions::NotAuthorized => e
    #   respond_to do |format|
    #     format.html { redirect_to root_path, alert: 'Only Admins are allowed. Sorry 😔' }
    #   end
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Login Successful 😃' }
      end
    end

    def logout
      # Invalidate session with FusionAuth
      @oauth_client.request(:get, 'connect/endsession')

      # # Reset Rails session
      reset_session
      redirect_to '/', notice: 'Logged Out Successfully 🙋‍♂️'
      # redirect_to oauth_response.response.env.url.to_s
    rescue OAuth2::Error => e
      respond_to do |format|
        format.html { redirect_to root_path, alert: e.message }
      end
    end

    def post_logout
      reset_session

      redirect_to '/'
    end

    # GET /logout_callback
    def logout_callback
      @user = User.find_by(sid: params['sid'])

      sign_in(@user) if @user

      reset_session

      redirect_to '/'
    end

    def login
      redirect_to @oauth_client.auth_code.authorize_url(scope: 'MobileMoney'), allow_other_host: true
    end
  end
end
