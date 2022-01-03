defmodule Shortie.Links.Link do
  use Ecto.Schema

  require Logger

  alias Ecto.Changeset
  import Ecto.Changeset

  @primary_key {:id, EctoHashids.Types.L, read_after_writes: true}

  @max_length 1024
  @host_pattern ~r/^((?!-)[A-Za-z0-9\-]{1,63}(?<!-)\.)+[A-Za-z]{2,6}$/

  def max_length(), do: @max_length


  @declared_fields [:url]
  schema "links" do
    field :url, :string

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, @declared_fields)
    |> validate_required([:url])
    |> validate_length(:url, [max: @max_length])
    |> validate_url(:url)
  end

  def external_id(<< "l_"::utf8, hashid::binary >>), do: hashid

  #
  # Internal
  #

  require Logger

  # TODO: factor out ...?
  defp validate_url(%Changeset{} = changeset, field) do
    case get_field(changeset, field) do
      nil ->
        changeset
      field_value ->
        {changeset, domain_etc} = check_protocol(changeset, field, field_value)
        {changeset, port} = check_host_domain(changeset, field, domain_etc)
        changeset = check_port(changeset, field, port)

        changeset
    end

  end

  defp check_protocol(changeset, field, url_candidate) do
    case url_candidate do
      << "http://", rest :: binary >> -> {changeset, rest}
      << "https://", rest :: binary >> -> {changeset, rest}
      _ -> {add_error(changeset, field, "should begin with http:// or https://"), ""}
    end
  end

  defp check_host_domain(changeset, field, host_candidate) do
    host =
      case String.split(host_candidate, "/", parts: 2) do
        [host] -> host
        [host, _path] -> host
      end

    case String.split(host, ":", parts: 2) do
      [host] -> {match_host_domain(changeset, field, host), :no_port}
      [host, port] -> {match_host_domain(changeset, field, host), port}
    end
  end

  require Logger
  defp match_host_domain(changeset, field, domain_candidate) do
    if not String.match?(domain_candidate, @host_pattern),
      do: add_error(changeset, field, "has invalid host"),
      else: changeset
  end

  #(:[1-9][0-9]{0,4})?
  defp check_port(changeset, _field, :no_port), do: changeset
  defp check_port(changeset, field, port_candidate) do
    case Integer.parse(port_candidate) do
      {port_num, ""} when port_num in 1..65535-> changeset
      _ -> add_error(changeset, field, "has invalid port, not in range 1..65535")
    end
  end

end
