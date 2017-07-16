class Api::V1::PinsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate, only: [:index, :create]

  def index
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end

    def authenticate
      user = User.find_by(email: request.headers['X-User-Email'])
      if user
        if user.api_token == request.headers['X-Api-Token']
          true
        else
          head 401
        end
      else
        head 422
      end
    end
end