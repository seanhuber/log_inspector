Rails.application.routes.draw do
  root 'demo#index'
  mount LogInspector::Engine => "/log_inspector"
end
