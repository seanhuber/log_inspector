LogInspector::Engine.routes.draw do
  root 'log#index'
  get 'file' => 'log#file_api'
  get 'folder' => 'log#folder_api'

  get 'logs' => 'logs#index'
  get 'logs/dir_contents'  => 'logs#dir_contents'
  get 'logs/file_contents' => 'logs#file_contents'
end
