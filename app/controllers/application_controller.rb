class ApplicationController < ActionController::Base
  include Pagy::Backend
  # Check for Token Presence
  def authorize_request
    header = request.headers['Authorization']
    header = header.split.last if header

    decoded = JWT.decode(header, nil, false)

    @decoded = OpenStruct.new(decoded.first)

    @user = User.find_by(email: @decoded.email)

    @user ||= User.create(
      email: @decoded.email,
      password: @decoded.sid,
      sid: @decoded.sid,
      token: @decoded.token,
      identity_url: @decoded.iss
    )

    expiry = DateTime.strptime(@decoded.exp.to_s, '%s')


    sign_in(@user)
  rescue ActiveRecord::RecordNotFound => e
    render json: {
             status: 404,
             message: 'Access Token valid, But owner user does not exist',
             errors: e.message
           },
           status: :unauthorized
  rescue JWT::DecodeError => e
    render json: {
      status: 401,
      message: 'UnAuthorized',
      errors: e.message
    }, status: :unauthorized
  end
end
