defmodule Discuss.Topic do
  use Discuss.Web, :model

  # ------------------------- #
  # MODEL RELATES EVERYTHING IN APP TO DATABASE
  # ------------------------- #

  schema "topics" do
    # every field must have :title of type :string
    field :title, :string

    # topic has only one user
    # set up relationship through User model
    belongs_to :user, Discuss.User
    has_many :comments, Discuss.Comment
  end

  # NOTE! - MAGIC!
  # use ^ brings about a struct with same name as 
  # module - Discuss.Topic => "topic" struct

  # iex(1)> struct = %Discuss.Topic{}
  # %Discuss.Topic{__meta__: #Ecto.Schema.Metadata<:built, "topics">, id: nil, title: nil}
  # iex(2)> params = %{title: "Great JS"}
  # %{title: "Great JS"}

  # iex(3)> Discuss.Topic.changeset(struct, params)
  #Ecto.Changeset<action: nil, changes: %{title: "Great JS"}, errors: [], data: #Discuss.Topic<>, valid?: true>

  # ------------------------- #
  # changeset returns an Ecto.changeset object which we save to database
  # ------------------------- #
  def changeset(struct, params \\ %{}) do
    # struct is record going into database
    # params are what we are updating.
    #
    # records whatever updates that takes struct
    # modifies with params to take it to where we need to be
    # produced by cast()
    # then pass to validator
    # returns new changeset object

    # validate_required checks theres a title

    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end