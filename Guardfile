guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^spec/dummy/app/controllers/(.+_controller)\.rb$}) { |m| "spec/dummy/spec/controllers/#{m[1]}_spec.rb" }
end
