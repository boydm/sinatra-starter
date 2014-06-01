require './starter_app'
 
use Rack::Cache, verbose: false
 
map StarterApp.assets_prefix do
  run StarterApp.assets
end
 
map '/' do
  run StarterApp
end