routes = Routes.method(:all)


Rails.application.routes.draw do

    # Routes managed by ApplicationController
    get Routes.all(:application, :root, :path) => Routes.all(:application, :root, :method)

    # Routes managed by UserController
    get Routes.all(:users, :get, :path) => Routes.all(:users, :get, :method)
    get Routes.all(:users, :update, :path) => Routes.all(:users, :update, :method)

end
