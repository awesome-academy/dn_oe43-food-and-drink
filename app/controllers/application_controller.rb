class ApplicationController < ActionController::Base
  before_action :set_locale

  rescue_from CanCan::AccessDenied, with: :access_denied

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "index.must_login"
    redirect_to login_url
  end

  def access_denied
    flash[:danger] = t :access_denied
    redirect_to root_path
  end
end
