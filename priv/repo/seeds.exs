# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MyApp.Repo.insert!(%MyApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias MyApp.{Repo, Identity, Identity.Account}

account1 =
  Identity.change_account(%Account{}, %{email: "user1@example.com", password: "Pass123$"})

Repo.insert!(account1)
