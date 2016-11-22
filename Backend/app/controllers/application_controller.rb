class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, we may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # Include necessary helpers
  include ApplicationHelper

  # Make sure the action (method) executed requires authentication
  before_filter :check_authentication

  # Rescue these exceptions
  rescue_from ::ActionController::RoutingError, :with => :no_route_exception_json
  rescue_from ::ActiveRecord::UnknownAttributeError, :with => :exception_json
  rescue_from ::ActiveRecord::RecordNotUnique, :with => :record_not_unique_json
  rescue_from ::AppError, :with => :exception_json
  rescue_from ::AppError::AuthenticationError, :with => :exception_custom_code_json
  rescue_from ::JSON::ParserError, :with => :invalid_json_json

  # Route methods
  # Main page
  def root
    render :json => JSONResponse.json(0, "Welcome!")
  end

  # Exception rescuing method. Integer codes are used for system-wide exception,
  # the alphanumeric codes are for more specific errors.
  # A regular exception
  def exception_json(exception,code=500)
    render :json => Status::Errors.exception_json(exception, code).to_json, :status => code
  end

  def exception_custom_code_json(exception)
    exception_json(exception, exception.code)
  end

  # No route was found.
  def no_route_exception_json(exception)
    code = 404
    render :json => Status::Errors.exception_json(exception, code).to_json, :status => code
  end

  # The resource was not found or is gone.
  def does_not_exist_json(exception=nil)
    message = exception.message if !exception.nil?
    exception = AppError::UndefinedRouteOrActionError.new
    code = exception.code
    render :json => Status::Errors.exception_json(exception, code, message).to_json, :status => code
  end

  # Method is not allowed.
  def record_not_unique_json(exception)
    code = 405
    original_message = exception.message
    exception = ActiveRecord::RecordNotUnique.new(Status::Errors::ERROR_NON_UNIQUE_DB_ID["message"])
    render :json => Status::Errors.exception_json(exception, code, original_message).to_json, :status => code
  end

  # Invalid JSON used for our configuration.
  def invalid_json_json(exception)
    code = 500
    render :json => Status::Errors.exception_json("We are currently experiencing issues with our data server, please try again soon.", code).to_json, :status => code
  end

  # Miscellaneous
  def teapot
    code = 418
    render :json => {
      "code" => code,
      "message" => [
            "Welcome to our SEG3502 third deliverable's implementation part.",
            "There is nothing particular to see here.",
            "In case you are wondering, I am a teapot."
      ]}.to_json,
            :status => code
  end
    
  private
    def process(action, *args)
      super
      rescue AbstractController::ActionNotFound => e
      does_not_exist_json(e)
    end

    def check_authentication
      controller = params["controller"]
      action = params["action"]
      # If not logged in, check if the route needs authentication.
      if !logged_in?
        raise not_logged_in_error if Routes.requires_authentication(controller, action)
      end

      # If logged in, then check if action needs to be accessed by a priviledged user.
      if !current_user.is_privileged?
        raise not_admin_in_error if Routes.requires_admin(controller, action)
      end
    end

    def not_logged_in_error
      AppError::AuthenticationError.new(Status::Errors::ERROR_USER_AUTHENTICATION_REQUIRED)
    end

    def not_admin_in_error
      AppError::AuthenticationError.new(Status::Errors::ERROR_USER_ADMIN_REQUIRED)
    end

end
