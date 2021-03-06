class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  layout :layout_by_resource

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private

  def current_user
    return @_logged_in_user if defined?(@_logged_in_user)
    warden = request.env["warden"]
    @_logged_in_user = warden && warden.user(:user)
  end
  helper_method :current_user

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def get_user
    @user = current_user
  end

  # error pages

  def render_error_page(exception = nil)
    if exception
      logger.info "Rendering #{status_code}: #{exception.message}"
    end

    render file: "errors/#{status_code}.html", :status => status_code, :layout => false
  end

  def record_not_found
    render "errors/404.html"
  end

  protected

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def status_code
    params[:code] || 500
  end

  def authenticate_user!
    if current_admin_user.present?
      unless request.original_url.include?('/admin')
        redirect_to admin_root_path, notice: "You are not authorized to view this page"
      end
    else
      super
    end
  end
end
