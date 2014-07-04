JsonSchemaRails::Engine.routes.draw do
  get '*id(.:format)', to: 'schemas#show', as: :schema, id: /[\/a-zA-Z0-9_-]+/, defaults: { format: 'json' }
end
