use Mix.Config

config :tesla, adapter: Tesla.Mock

config :at_ex,
  api_key: "6f2a021cbd7b2b0f5e9ba324f42dbf42403ab9a239d1c55c5a68cf54922bda77",
  content_type: "application/json",
  accept: "application/json",
  auth_token: "",
  stk_product_name: "AtEx",
  b2c_product_name: "AtEx"
