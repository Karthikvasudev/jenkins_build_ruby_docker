require "sinatra/base"
require "models"
require "redis"

class Application < Sinatra::Base
  def initialize(app=nil)
    super(app)

    @redis = Redis.new(host: ENV["REDIS_HOST"])
    @redis.setnx("visitors_counter", 0)
  end
#bind localhost to listen to all
set :bind, '0.0.0.0'

  get "/" do
    @redis.incr("visitors_counter")
    @number_of_visitors = @redis.get("visitors_counter")

    @guestbook_entries = Guestbook.all

    erb :index
  end

  post "/" do
    Guestbook.create(
      name: params[:name],
      message: params[:message],
      created_at: DateTime.now
    )

    redirect "/"
  end
end
