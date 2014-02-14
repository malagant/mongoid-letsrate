# -*- encoding : utf-8 -*-
class RaterController < ApplicationController
  def create
    if <%= file_name %>_signed_in?
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate params[:score].to_i, current_<%= file_name %>

      render :json => true
    else
      render :json => false
    end
  end
end
