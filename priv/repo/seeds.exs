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

alias WingManager.{Accounts, Organizations, Personnel, Scoring}

{:ok, sweats} =
  Accounts.register_user(%{
    email: "sweats@example.com",
    password: "asdfasdfasdf"
  })

{:ok, two} =
  Accounts.register_user(%{
    email: "wingman@example.com",
    password: "asdfasdfasdf"
  })

{:ok, three} =
  Accounts.register_user(%{
    email: "sectionlead@example.com",
    password: "asdfasdfasdf"
  })

Triplex.create("sweat")

Organizations.create_wing(%{
  name: "Sweaty Squadron",
  slug: "sweat"
})

{:ok, sweats_pilot} =
  Personnel.create_pilot(
    %{
      user_id: sweats.id,
      callsign: "Sweats",
      title: "Grand Poobah",
      roles: ["admin", "flight-lead", "section-lead", "pilot"]
    },
    "sweat"
  )

{:ok, two_pilot} =
  Personnel.create_pilot(
    %{
      user_id: two.id,
      callsign: "Blind",
      title: "LT",
      roles: ["pilot"]
    },
    "sweat"
  )

{:ok, three_pilot} =
  Personnel.create_pilot(
    %{
      user_id: three.id,
      callsign: "Maverick",
      title: "CPT",
      roles: ["pilot", "section-lead"]
    },
    "sweat"
  )

raw_kills = [
  %{pilot_id: sweats_pilot.id, target: "MiG-28"},
  %{pilot_id: sweats_pilot.id, target: "MiG-28"},
  %{pilot_id: sweats_pilot.id, target: "MiG-28"},
  %{pilot_id: two_pilot.id, target: "MiG-28"},
  %{pilot_id: two_pilot.id, target: "MiG-28"},
  %{pilot_id: two_pilot.id, target: "MiG-28"},
  %{pilot_id: two_pilot.id, target: "MiG-28"},
  %{pilot_id: three_pilot.id, target: "MiG-28"},
  %{pilot_id: three_pilot.id, target: "MiG-28"},
  %{pilot_id: three_pilot.id, target: "MiG-28"},
  %{pilot_id: three_pilot.id, target: "MiG-28"}
]

Enum.each(raw_kills, fn attrs -> Scoring.create_kill(attrs, "sweat") end)
