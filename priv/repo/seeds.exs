# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WingManager.Repo.insert!(%WingManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Triplex.create("cjtf")
WingManager.Repo.insert!(%WingManager.Wing.Tenant{
    name: "Combined Joint Task Force"
    slug: "cjtf"
})
