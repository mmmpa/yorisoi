Rails.application.routes.draw do
  scope :samples do
    get :new, to: 'samples#new'
    post :create, to: 'samples#create'
  end
end
