defmodule TaskService.Config do
  def oban, do: Application.fetch_env!(:task_service, Oban)
end
