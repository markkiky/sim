class TextsController < ApplicationController
  before_action :set_text, only: %i[show edit update destroy]

  # GET /texts or /texts.json
  def index
    @texts = Text.all
  end

  # GET /texts/1 or /texts/1.json
  def show
    flash.now[:notice] = 'Payment Testing'
  end

  # GET /texts/new
  def new
    @text = Text.new
  end

  # GET /texts/1/edit
  def edit; end

  # POST /texts or /texts.json
  def create
    @text = Text.new(text_params)
    @text.message_hash = Digest::SHA1.hexdigest(text_params[:message])
    @text.message_date = DateTime.now unless text_params[:message_date].present?

    if @text.save!
      flash.now[:notice] = 'Text was successfully created'
      render turbo_stream: [
        turbo_stream.prepend('texts', @text),

        turbo_stream.replace('notice', partial: 'layouts/flash')
      ]
    else
      render :index, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique => e
    flash.now[:alert] = 'Message Already Exists. Contact Support'
    render turbo_stream: [
      turbo_stream.replace('alert', partial: 'layouts/flash')
    ]
  end

  # PATCH/PUT /texts/1 or /texts/1.json
  def update
    if @text.update(update_params)
      flash.now[:notice] = 'text was successfully updated.'
      render turbo_stream: [
        turbo_stream.replace(@text, @text),
        turbo_stream.replace('notice', partial: 'layouts/flash')
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique => e
    flash.now[:alert] = 'Message Already Exists. Contact Support'
    render turbo_stream: [
      turbo_stream.replace('alert', partial: 'layouts/flash')
    ]
  end

  # DELETE /texts/1 or /texts/1.json
  def destroy
    @text.destroy
    flash.now[:notice] = 'text was successfully destroyed.'
    render turbo_stream: [
      turbo_stream.remove(@text),
      turbo_stream.replace('notice', partial: 'layouts/flash')
    ]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_text
    @text = Text.find(params[:id])
  end

  def update_params
    resource = text_params
    resource.delete(:message_hash)
    resource.merge!(
      message_hash: Digest::SHA1.hexdigest(resource[:message])
    )
  end

  # Only allow a list of trusted parameters through.
  def text_params
    params.require(:text).permit(:id, :message, :message_hash, :message_date, :is_processed)
  end
end
