defmodule Shortie.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shortie.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{

      })
      |> Shortie.Links.create_link()

    link
  end
end
