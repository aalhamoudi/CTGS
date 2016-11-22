class GrantSystemController < ApplicationController
    # This controller is responsible for managing all Grant system-related
    # actions, and thus methods. Here is a list of these actions with a short
    # description.
    # => 
    # => 
    # This controller reprensent the system as its kernel, so all operations
    # must be directed to this controller. The controller will be responsible
    # for ultimately communicating with the application's front end.

    # This controller method is reponsible for calling the appropriate 
    # controller method given the action provided. All parameters, if any,
    # will passed to the controller method. Any method that requires parameters
    # and does not receive any will raise an AppError::NoParamsFoundError to the
    # client.

    p "******** GrantSystemController!!!"

    def dispatch_system
        p "**** Dispatching system!!"
        action = param[:action]
        action = action.strip.to_s
        begin
            p "Dispatching system"
            _raise_on_error("No action was specified.") if action.size == 0
            method_to_call = "self.#{action}"
            #method(action).call
        rescue NoMethodError
            _raise_on_error("Invalid action \"#{action}\".")
        rescue NameError
            _raise_on_error("Invalid action \"#{action}\".")
        end
    end

    def check_logged_in
        p "**** #{params["action"]}!!"
        p params.include? "params"
        render :json => _check_useless_params({"status" => logged_in?}, params["params"]).to_json
    end

    def test
        render :text => "Test"
    end

    private
        def _raise_on_error(message=nil, error_class: AppError::NoParamsFoundError)
            message = message.to_s if !(message.class <= Exception)
            message = message.message if message.class <= Exception
            raise error_class.new(message)
        end

        def _check_useless_params(_hash, params_params=nil)
            _hash["warning"] = "Unecessary parameters were added." if !params_params.nil?
            _hash
        end

end
