LogInspector::Engine.routes.draw do
  root 'log#index'
  get 'file' => 'log#file_api'
  get 'folder' => 'log#folder_api'
end
