defmodule Discuss.User do
  use Discuss.Web, :model

  schema "users" do
    field :email, :string
    field :provider, :string
    add :token, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
  end

end