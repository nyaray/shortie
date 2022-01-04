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

  def empty_changeset() do
    %Shortie.Links.Link{}
    |> Ecto.Changeset.cast(%{}, [])
  end

  def external_id(<< "l_"::utf8, hashid::binary >>), do: hashid

  #
  # Internal
  #

  require Logger

  defp validate_url(%Changeset{} = changeset, field) do
    url = get_field(changeset, field)
    case URI.new(url) do
      {:error, ":"} ->
        add_error(changeset, field, "has an issue around the port, check that port is in 1-65535")
      {:error, part} ->
        add_error(changeset, field, "has an issue around: #{part}")
      {:ok, %URI{ scheme: scheme, host: host, path: path}=uri} ->
        case { scheme, host } do
          { nil, nil } ->
            # NOTE: URI assumes that a URL without a protocol is a path, but we
            # can be a bit smarter if the "path" is a domain
            host_candidate = path |> String.split(~r|[/#\?]|, parts: 2) |> List.first()
            if String.match?(host_candidate, @host_pattern),
              do: add_error(changeset, field, "has no protocol"),
              else: add_error(changeset, field, "is malformed, it should contain at least a protocol (http/https) and a domain")
          { nil, _host } ->
            add_error(changeset, field, "has no protocol, it should begin with http:// or https://")
          { _scheme, nil } ->
            add_error(changeset, field, "has no domain")
          { _scheme, _host } ->
            do_validate_url(changeset, field, uri, url)
        end

    end
  end

  defp do_validate_url(changeset, field, %URI{ scheme: scheme, host: host } = uri, url) do
    changeset = validate_userinfo_absence(changeset, field, uri)
    changeset = validate_scheme(changeset, field, scheme)
    changeset = validate_host(changeset, field, host)
    changeset = validate_port(changeset, field, uri, url)

    changeset
  end

  defp validate_userinfo_absence(changeset, _field, %URI{ userinfo: nil }), do: changeset
  defp validate_userinfo_absence(changeset, field, %URI{ userinfo: _ }), do: add_error(changeset, field, "has userinfo, which is not allowed")

  defp validate_scheme(changeset, field, scheme) do
    if scheme in ["http", "https"],
      do: changeset,
      else: add_error(changeset, field, "should begin with http:// or https://")
  end

  defp validate_host(changeset, field, host) do
    if not String.match?(host, @host_pattern),
      do: add_error(changeset, field, "has invalid domain (host)"),
      else: changeset
  end

  defp validate_port(changeset, field, %URI{ host: host, port: port}, url) do
    with {:port_prefix, [_, post_host]} <- {:port_prefix, String.split(url, << host::binary, ":" >>, parts: 2)},
          {:port_parse, {^port, ""}} <- {:port_parse, post_host |> String.split(~r|[/#\?]|, parts: 2) |> List.first() |> Integer.parse()} do
      changeset
    else
      # no port specified in url
      {:port_prefix, _} ->
        changeset
      {:port_parse, {_partial_port, string_rest}} ->
        add_error(changeset, field, "has a malformed port around '%{port_rest}'", port_rest: string_rest)
    end
  end
end
