routes = Routes.method(:all)

# Routes.set_testing
# Routes.add_api

Rails.application.routes.draw do

    # Routes managed by ApplicationController
    root Routes.all(:application, :root, :method)

    # Routes managed by UserController
    get Routes.all(:users, :get, :path) => Routes.all(:users, :get, :method)
    get Routes.all(:users, :create, :path) => Routes.all(:users, :create, :method)
    get Routes.all(:users, :create, :alternative) => Routes.all(:users, :create, :method)
    get Routes.all(:users, :update, :path) => Routes.all(:users, :update, :method)
    get Routes.all(:users, :delete, :path) => Routes.all(:users, :delete, :method)
    get Routes.all(:users, :login, :path) => Routes.all(:users, :login, :method)

end
