defmodule Shortie.LinksTest do
  use Shortie.DataCase

  alias Shortie.Links

  describe "links" do
    alias Shortie.Links.Link

    import Shortie.LinksFixtures

    @invalid_attrs %{ "url" => "http://----" }

    test "list_links/0 returns all links" do
      # arrange
      link = link_fixture()
      # act
      actual = Links.list_links()
      # assert
      assert actual == [link]
    end

    test "get_link!/1 returns the link with given id" do
      # arrange
      link = link_fixture()
      # act
      actual = Links.get_link!(link.id)
      # assert
      assert actual == link
    end

    test "create_link/1 with valid data creates a link" do
      # arrange
      valid_attrs = %{ "url" => "http://elixir-lang.org" }

      # act
      actual = Links.create_link(valid_attrs)

      # assert
      assert {:ok, %Link{} = link} = actual
      assert link.url == "http://elixir-lang.org"
    end

    test "create_link/1 with invalid data returns error changeset" do
      # act
      actual = Links.create_link(@invalid_attrs)
      # assert
      assert {:error, %Ecto.Changeset{}} = actual
    end

    test "delete_link/1 deletes the link" do
      # arrange
      link = link_fixture()
      # act
      actual = Links.delete_link(link)
      # assert
      assert {:ok, %Link{}} = actual
      assert_raise Ecto.NoResultsError, fn -> Links.get_link!(link.id) end
    end

    test "resolve_link/1 resolves to a link given a slug" do
      # arrange
      link = link_fixture()
      id = link.id |> Link.external_id()
      # act
      actual = Links.resolve_link(id)
      # assert
      assert link == actual
    end

    test "resolve_link/1 handles non-existant slugs" do
      # arrange
      id = "not_really_real"
      # act
      actual = Links.resolve_link(id)
      # assert
      assert actual == nil
    end

  end
end
