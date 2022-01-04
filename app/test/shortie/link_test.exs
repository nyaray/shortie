defmodule LinkTest do
  use ExUnit.Case
  doctest Shortie.Links.Link

  alias Shortie.Links.Link

  @empty_link %Link{}

  test "accepts valid http url" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "http://elixir-lang.org/"})
    # assert
    assert actual.errors == []
  end

  test "accepts valid https url" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "https://elixir-lang.org/"})
    # assert
    assert actual.errors == []
  end

  test "accepts weird-looking, numerical, port" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "http://www.com:00002323/" })
    # assert
    assert actual.errors == []
  end

  test "rejects an invalid url" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "-elixir-lang-"})
    # assert
    assert actual.errors == [{:url, {"is malformed, it should contain at least a protocol (http/https) and a domain", []}}]
  end

  test "rejects url without protocol" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "elixir-lang.org"})
    # assert
    assert actual.errors == [{:url, {"has no protocol", []}}]
  end

  test "rejects url without protocol, but with path" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "elixir-lang.org/index.html"})
    # assert
    assert actual.errors == [{:url, {"has no protocol", []}}]
  end

  test "rejects url without protocol, but with query" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "elixir-lang.org?page=index"})
    # assert
    assert actual.errors == [{:url, {"has no protocol", []}}]
  end

  test "rejects url without protocol, but with fragment" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "elixir-lang.org#easter-egg"})
    # assert
    assert actual.errors == [{:url, {"has no protocol", []}}]
  end

  test "rejects non-http(s) protocol" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "ftp://i-will-hax-u.lol/" })
    # assert
    assert actual.errors == [{:url, {"should begin with http:// or https://", []}}]
  end

  test "rejects userinfo" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "http://gullible:secretpass@i-will-hax-u.lol/" })
    # assert
    assert actual.errors == [{:url, {"has userinfo, which is not allowed", []}}]
  end

 test "rejects invalid host domain" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "http://www-.com/" })
    # assert
    assert actual.errors == [{:url, {"has invalid domain (host)", []}}]
  end

  test "rejects invalid, malformed, port number" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "http://www.com:23a23/" })
    # assert
    assert actual.errors == [{:url, {"has an issue around the port, check that port is in 1-65535", []}}]
  end

  test "rejects invalid, alphanumerical, port number with letters grouped at the end" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "http://www.com:2323abc" })
    # assert
    assert actual.errors == [{:url, {"has an issue around the port, check that port is in 1-65535", []}}]
  end

  test "rejects invalid, alphanumerical, port number with letters grouped at the end with trailing slash" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "http://www.com:2323abc/" })
    # assert
    assert actual.errors == [{:url, {"has an issue around the port, check that port is in 1-65535", []}}]
  end

  test "rejects invalid, alphanumerical, port number" do
    # arrange
    # act
    actual = Link.changeset(@empty_link, %{ "url" => "http://www.com:2323index.html" })
    # assert
    assert actual.errors == [{:url, {"has an issue around the port, check that port is in 1-65535", []}}]
  end

end
