Rails.application.routes.draw do
  scope :samples do
    get :new, to: 'samples#new'
    get :remnant, to: 'samples#remnant'
    post :create, to: 'samples#create'
  end
end
