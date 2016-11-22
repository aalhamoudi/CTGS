routes = Routes.method(:all)

# Routes.set_testing
# Routes.add_api

Rails.application.routes.draw do

    # Routes managed by ApplicationController
    root Routes.all(:application, :root, :method)
    get Routes.all(:application, :teapot, :path) => Routes.all(:application, :teapot, :method)

    # Routes managed by UserController
    get Routes.all(:users, :get, :path) => Routes.all(:users, :get, :method)
    get Routes.all(:users, :create, :path) => Routes.all(:users, :create, :method)
    get Routes.all(:users, :create, :alternative) => Routes.all(:users, :create, :method)
    get Routes.all(:users, :update, :path) => Routes.all(:users, :update, :method)
    get Routes.all(:users, :delete, :path) => Routes.all(:users, :delete, :method)
    get Routes.all(:users, :login, :path) => Routes.all(:users, :login, :method)

    # Routes managed by GrantSystemController
    get Routes.all(:grant_system, :dispatch_system, :path) => Routes.all(:grant_system, :dispatch_system, :method)
    get Routes.all(:grant_system, :dispatch_system, :alternative) => Routes.all(:grant_system, :dispatch_system, :method)

    # Special cases
    match "*a" => Routes.all(:application, :does_not_exist_json, :method), via: :all

end
