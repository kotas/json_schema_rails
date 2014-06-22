JsonSchemaRails::Engine.routes.draw do
  get '*schema(.:format)', to: 'schemas#get'
end
