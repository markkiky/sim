module Api
  class TextsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authorize_request

    # POST /api/texts
    def create
      bank = Bank.find_or_initialize_by(name: params[:bank])
      bank.save unless bank.id
      failures = 0
      texts = []
      text_params[:texts].each do |text|
        texts << {
          user_id: current_user.id,
          bank_id: bank.id,
          message: text[:message],
          message_hash: Digest::SHA1.hexdigest(text[:message])
        }

      rescue ActiveRecord::RecordNotUnique => e
        failures += 1
      end

      tst = Text.import texts, on_duplicate_key_ignore: true

      current_user.texts.each do |text|
        text.process_text
      end

      render json: {
        message: "#{text_params[:texts].count} Message(s) Received. #{failures} Message(s) failed"
      }
    end

    def index
      @texts = current_user.texts

      render json: @texts
    end

    private

    def text_params
      params.permit(
        texts: %i[
          message
        ]
      )
    end
  end
end
