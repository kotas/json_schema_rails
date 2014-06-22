JsonSchemaRails::Engine.routes.draw do
  get '/:schema(.:format)', to: 'schemas#get', constraints: { schema: /[\/a-zA-Z0-9_-]+/ }
end
