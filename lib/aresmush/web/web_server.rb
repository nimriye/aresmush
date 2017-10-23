module AresMUSH
  
  class WebAppLoader

    def run(opts = {})

      server  = opts[:server] || 'thin'
      host    = opts[:host]   || '0.0.0.0'
      port    = opts[:port]   || '8181'
      web_app = WebApp

      dispatch = Rack::Builder.app do
        map '/' do
          run web_app
        end
      end

      Rack::Server.start({
        app:    dispatch,
        server: server,
        Host:   host,
        Port:   port,
        signals: false,
      })
    
    end
  end

  class WebApp < Sinatra::Base
    # threaded - False: Will take requests on the reactor thread
    #            True:  Will queue request for background thread
    configure do
      set :threaded, false
<<<<<<< HEAD
      #register Sinatra::Reloader
      #enable :sessions
=======
      register Sinatra::Reloader
>>>>>>> parent of f74f1de2... Merge remote-tracking branch 'upstream/master'
      register Sinatra::Flash
      disable :sessions
      set :public_folder, File.join(AresMUSH.game_path, 'plugins', 'website', 'web', 'public')

      db_config = YAML.load(File.read(File.join(AresMUSH.game_path, 'config', 'database.yml')))
      secret_config = YAML.load(File.read(File.join(AresMUSH.game_path, 'config', 'secrets.yml')))
      
      redis_url = AresMUSH::Database.build_url(db_config['database']['url'], secret_config['secrets']['database']['password']) 

      use Rack::Session::Redis, :redis_server => "#{redis_url}/0/rack:session"
      
      Compass.configuration do |config|
         config.project_path = File.join(AresMUSH.game_path, 'plugins', 'website', 'web')
         config.sass_dir = 'styles'
       end

       set :sass, Compass.sass_engine_options
       set :scss, Compass.sass_engine_options
    end
    
    register do
      def auth (type)
        condition do
          unless send("is_#{type}?")
            if (type == :admin)
              flash[:error] = "Please log in with an admin account."
            elsif (type == :approved)
              flash[:error] = "You must be approved first."
            else
              flash[:error] = "Please log in first"
            end
            redirect "/" 
          end
        end
      end
    end
    
    helpers do
      def find_template(views, name, engine, &block)
        views = Plugins.all_plugins.map { |p| File.join(PluginManager.plugin_path, p, 'web', 'views') }
        views.each { |v| super(v, name, engine, &block) }
      end
    end
  end
end