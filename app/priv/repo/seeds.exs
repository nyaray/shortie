# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Shortie.Repo.insert!(%Shortie.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

require Logger

alias Shortie.Repo

import Ecto.Query

if System.get_env("SHORTIE_WIPE") do
  Logger.info("SHORTIE_WIPE set, wiping db entries.")
  {delete_count, _} = Shortie.Repo.delete_all(Shortie.Link)
  Logger.info("Deleted #{ inspect delete_count } links.")
end

# YOLO - you only load once
needs_seeding = Repo.one!(from l in Shortie.Link, select: count(l.id)) == 0
if needs_seeding do
  Logger.info("No links found, proceeding with seeding.")

  Shortie.Repo.insert!(%Shortie.Link{ url: "https://www.reddit.com/r/WearOS/" })
  Shortie.Repo.insert!(%Shortie.Link{ url: "https://www.imdb.com/title/tt12759424/" })
  Shortie.Repo.insert!(%Shortie.Link{ url: "https://www.healthygamer.gg/content" })
  Shortie.Repo.insert!(%Shortie.Link{ url: "https://caniuse.com/?search=%40import" })
  Shortie.Repo.insert!(%Shortie.Link{ url: "https://www.erlang.org/doc/programming_examples/bit_syntax.html#examples" })
  Shortie.Repo.insert!(%Shortie.Link{ url: "https://www.google.com/search?q=css+text+overflow&source=hp&ei=k23LYZStIdmiptQP4fC9wAs&iflsig=ALs-wAMAAAAAYct7o_mZio_6cns6K8JNKhFvoqM2qQtj&ved=0ahUKEwjUwoKGpYf1AhVZkYkEHWF4D7gQ4dUDCAg&uact=5&oq=css+text+overflow&gs_lcp=Cgdnd3Mtd2l6EAMyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEOgsIABCABBCxAxCDAToICAAQgAQQsQM6EQguEIAEELEDEIMBEMcBEKMCOhEILhCABBCxAxCDARDHARDRAzoOCC4QgAQQsQMQxwEQowI6CAguEIAEELEDOgsILhCABBDHARDRA1AAWPYNYLgPaABwAHgBgAHQAYgBmAqSAQYxNS4xLjGYAQCgAQE&sclient=gws-wiz" })
  Shortie.Repo.insert!(%Shortie.Link{ url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ" })

  # Feel free to add more links.
  # Shortie.Repo.insert!(%Shortie.Link{ url: "" })
  # Shortie.Repo.insert!(%Shortie.Link{ url: "" })
  # Shortie.Repo.insert!(%Shortie.Link{ url: "" })
  # Shortie.Repo.insert!(%Shortie.Link{ url: "" })
  # Shortie.Repo.insert!(%Shortie.Link{ url: "" })

  Logger.info("Seeding completed!")
else
  Logger.info("Links already exist, aborting seeding.")
end
