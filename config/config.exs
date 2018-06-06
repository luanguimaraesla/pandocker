# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :pandocker, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:pandocker, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

config :pandocker, envs: %{
  config_yaml:    "PANDOCKER_CONFIG_YAML",
  project_root:   "PANDOCKER_PATH",
  source_path:    "PANDOCKER_SOURCE_PATH",
  output_file:    "PANDOCKER_OUTPUT_FILE",
  files:          "PANDOCKER_FILES",
  custom_flags:   "PANDOCKER_CUSTOM_FLAGS",
  cmd:            "PANDOCKER_CMD",
}

config :pandocker, defaults: %{
  command:        "help",
  config_yaml:    "pandocker.yml",
  project_root:   "/code",
  source_path:    'src',
  output_file:    'out.pdf',
  files:          "/pandocker/examples/example.md",
  templates_url:  "https://github.com/luanguimaraesla/pandocker-templates",
  template:       "default",
}

config :pandocker, tokens: %{
  command:        ~r/^\s*(?P<command>(compile|help|new))/,
  template:       ~r/(-t|--template)\s*(?<template>[-_\w\d\.]+)/,
  config_yaml:    ~r/(-f|--file)\s*(?P<config_yaml>\/?([-_\w\d\.]+\/?)*[-_\w\d\.]+\.(yaml|yml))/,
}

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
