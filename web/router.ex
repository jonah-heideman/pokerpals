defmodule Pokerpals.Router do
  use Pokerpals.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Pokerpals.Auth, repo: Pokerpals.Repo
    plug :put_user_token
  end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pokerpals do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/games", GameController, only: [:index, :show, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Rampant do
  #   pipe_through :api
  # end
end
