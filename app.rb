require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup' 
require 'rack-flash'

enable :sessions
use Rack::Flash, :sweep => true
set :session, true
set :database, "sqlite3:project.sqlite3"
configure(:development){set :
database, "sqlite:///project.sqlite3"}

require './models'

get "/"  do
	@user = current_user if current_user
	erb :home
end

get "/fail" do
	erb :fail
end

get "/sign-up" do
	erb :sign_up
end

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

# get "/sign-out" do
# 	session[:user_id] = nil
# 	redirect "/"
# end

post '/sign-up' do
	params[:username]
	params[:password]
	@user = User.create(username: params[:username], password: params[:password]) 
	redirect "/"
end

post '/sign-in' do
 	@user = User.where(username: params[:username]).first
 	if @user && @user.password == params[:password]
 		# session[:user_id] = @user.id
 		flash[:notice] = "Welcome back " + @user.username + "!"
 		redirect "/"
 	else
 		redirect "/fail"
 	end
end

# Get the New Post form
get "/posts/new" do
  @title = "New Post"
  @post = Post.new
  erb :"posts/new"
end
 
# The New Post form sends a POST request (storing data) here
# where we try to create the post it sent in its params hash.
# If successful, redirect to that post. Otherwise, render the "posts/new"
# template where the @post object will have the incomplete data that the 
# user can modify and resubmit.
post "/posts" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}"
  else
    erb :"posts/new"
  end
end

# Get the individual page of the post with this ID.
get "/posts/:id" do
  @post = Post.find(params[:id])
  @title = @post.title
  erb :"posts/show"
end