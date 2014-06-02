# heavy influence for initial configuration from
# https://gist.github.com/datenimperator/3668587

require 'bundler'
Bundler.require
require 'sinatra/static_assets'
require 'sinatra/content_for'
require 'rdiscount'
require 'pry'                     if Sinatra::Base.development?
 
class StarterApp < Sinatra::Base
  register Sinatra::Partial
  register Sinatra::StaticAssets
  
  set :root,          File.dirname(__FILE__)
  set :assets,        Sprockets::Environment.new(root)
  set :precompile,    [ /\w+\.(?!js|css).+/, /application.(css|js)$/ ]
  set :assets_prefix, '/assets'
  set :digest_assets, false
  set(:assets_path)   { File.join public_folder, assets_prefix }
 
  configure do
    # Setup Sprockets
    %w{javascripts stylesheets images}.each do |type|
      assets.append_path "assets/#{type}"
    end
    assets.append_path 'assets/font'
 
    # Configure Sprockets::Helpers (if necessary)
    Sprockets::Helpers.configure do |config|
      config.environment = assets
      config.prefix      = assets_prefix
      config.digest      = digest_assets
      config.public_path = public_folder
    end
    Sprockets::Sass.add_sass_functions = false
 
    set :haml, { :format => :html5 }
  end
 
  before do
    expires 500, :public, :must_revalidate
  end
 
  get '/' do
    haml :index, :layout => :'layouts/application'
  end
 
  helpers do
    include Sprockets::Helpers
    include Sinatra::ContentFor
  end
 
end # class StarterApp