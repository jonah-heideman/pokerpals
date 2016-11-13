defmodule Pokerpals.SessionController do
  use Pokerpals.Web, :controller

  plug :bounce_user when action in [:new]

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    case Pokerpals.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> redirect(to: "/")
      {:error, _reason, conn} ->
        conn
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Pokerpals.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
