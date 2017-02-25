defmodule Discuss.Repo.Migrations.AddUserIdToTopics do
  use Ecto.Migration

  # to reference another table, users table, in db
  # `references(:users)
  def change do
    alter table(:topics) do
      add :user_id, references(:users)
    end
  end
end
