class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, we may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # Rescue these exceptions
  rescue_from ::AppError, :with => :exception_json
  rescue_from ::ActiveRecord::UnknownAttributeError, :with => :exception_json
  rescue_from ::ActiveRecord::RecordNotFound, :with => :does_not_exist_json
  rescue_from ::ActiveRecord::RecordNotUnique, :with => :record_not_unique_json
  rescue_from ::ActionController::RoutingError, :with => :no_route_exception_json
  rescue_from ::JSON::ParserError, :with => :invalid_json_json

  # Route methods
  # Main page
  def root
    render :json => JSONResponse.json(0, "Welcome!")
  end

  # Exception rescuing method. Integer codes are used for system-wide exception,
  # the alphanumeric codes are for more specific errors.
  # A regular exception
  def exception_json(exception)
    code = 500
    render :json => Status::Errors.exception_json(exception, code).to_json, :status => code
  end

  # No route was found.
  def no_route_exception_json(exception)
    code = 404
    render :json => Status::Errors.exception_json(exception, code).to_json, :status => code
  end

  # The ressource was not found or is gone.
  def does_not_exist_json(exception)
    code = 410
    render :json => Status::Errors.exception_json(exception, code).to_json, :status => code
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

end
