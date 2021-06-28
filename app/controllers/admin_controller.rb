class AdminController < ApplicationController
  before_action :authenticate_user!

  def current_ability
    controller_name_segments = params[:controller].split "/"
    controller_name_segments.pop
    controller_namespace = controller_name_segments.join("/").camelize
    @current_ability ||= Ability.new(current_user, controller_namespace)
  end
end
