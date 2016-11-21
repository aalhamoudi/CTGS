class UsersController < ApplicationController
    # This class represents the User controller and is responsible for
    # managing the user-related actions and thus methods such as the
    # following :
    # => login (check if the username and password are valid)
    # => create (called upon registration request)
    # => get (returns and instance of the user based its unique id given on creation)
    # => update (updating the user's password, email address, etc.)
    # => delete (deleting the user from the database (aka destroy model))

	parser = Parsing::ParamsParser

	# The create controller. This method is responsible for creating a user given
	# certain parameters. Here are the params expected by the client:
	# [login_id, password, password_confirmation, email]
    # => Use case : "Add User"
    def create
        tags = params[:tags]
        tags = Parsing::ParamsParser.parse(tags)
        result = DBAdapter.create_model(:user, tags)
        model = result["model"]
        method_to_call = result["method"]
        status = result["status"]
        render :json => method_to_call.call(model, code: status["id"], message: status["message"])
    end

    # The get controller. This method is responsible for retrieving a user given
    # its id. Here are the params expected by the client:
    # [id]
    def get
        id = params[:id]
        model = DBAdapter.fetch_model(:user, id)
        render :json => model.to_json
    end

    # The login controller. This method is responsible for authenticating a user given
    # certain parameters. Here are the params expected by the client:
    # [login_id, password]
    def login
        tags = Parsing::ParamsParser.parse(params[:tags])
        result = DBAdapter.authenticate(:user, tags)
        method_to_call = result["method"]
        status = result["status"]
        render :json => method_to_call.call(nil, code: status["id"], message: status["message"])
    end

    # The update controller. This method is responsible for updating a user given
    # certain parameters. Here are the params expected by the client:
    # [login_id, password, email]
    def update
        tags = params[:tags]
        tags = Parsing::ParamsParser.parse(tags)
        result = DBAdapter.update_model(:user, params[:id], tags)
        model = result["model"]
        method_to_call = result["method"]
        status = result["status"]
        render :json => method_to_call.call(model, code: status["id"], message: status["message"])
    end

    # The delete controller. This method is responsible for deleting a user given
    # its id. Here are the params expected by the client:
    # [id]
    def delete
        result = DBAdapter.delete_model(:user, params[:id])
        method_to_call = result["method"]
        status = result["status"]
        model = result["model"] # just in case
        render :json => method_to_call.call(model, code: status["id"], message: status["message"])
    end

end
