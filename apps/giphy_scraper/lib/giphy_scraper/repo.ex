defmodule GiphyScraper.Repo do
  use Ecto.Repo,
    otp_app: :giphy_scraper,
    adapter: Ecto.Adapters.Postgres
end
