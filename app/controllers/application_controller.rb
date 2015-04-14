class ApplicationController < ActionController::Base
after_filter :flash_to_headers

def flash_to_headers
  return unless request.xhr?
  response.headers['X-Message'] = flash[:error]  unless flash[:error].blank?

  flash.discard
end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
