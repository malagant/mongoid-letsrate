# -*- encoding : utf-8 -*-
class RaterController < ApplicationController
  def create
    if user_signed_in?
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate params[:score].to_i, current_user

      render :json => true
    else
      render :json => false
    end
  end
end
