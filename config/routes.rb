JsonSchemaRails::Engine.routes.draw do
  resources :schemas, only: :show, path: '', id: /[\/a-zA-Z0-9_-]+/, defaults: { format: 'json' }
end
