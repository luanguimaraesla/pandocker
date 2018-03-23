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

config :pandocker, sys_env: %{
  root_path:     "PANDOCKER_PATH",
  template_path: "PANDOCKER_TEMPLATE_PATH",
  source_path:   "PANDOCKER_SOURCE_PATH",
  figures_path:  "PANDOCKER_FIGURES_PATH",
  output:        "PANDOCKER_OUTPUT",
  tof:           "PANDOCKER_ENABLE_TABLE_FIGURES",
  toc:           "PANDOCKER_ENABLE_TABLE_CONTENTS",
  tot:           "PANDOCKER_ENABLE_TABLE_TABLES",
  crossref:      "PANDOCKER_ENABLE_CROSSREF_FILTER",
  citeproc:      "PANDOCKER_ENABLE_CITEPROC_FILTER",
}

config :pandocker, config_yaml: %{
  env: "PANDOCKER_CONFIG_YAML",
  default: "pandocker.yml"
}

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
