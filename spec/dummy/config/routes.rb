Rails.application.routes.draw do
  scope :samples do
    get :index, to: 'samples#index'
    get :new, to: 'samples#new'
    post :create, to: 'samples#create'
  end
end
