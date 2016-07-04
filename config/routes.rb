LogInspector::Engine.routes.draw do
  root 'logs#index'
  get 'logs/dir_contents'  => 'logs#dir_contents'
  get 'logs/file_contents' => 'logs#file_contents'
end
