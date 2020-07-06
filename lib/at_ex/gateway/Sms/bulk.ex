defmodule AtEx.Gateway.Sms.Bulk do
  import AtEx.Util
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
  SMS endpoint, use it to POST and GET requests to the SMS endpoint
  """
  @live_url "https://api.africastalking.com/version1"
  @sandbox_url "https://api.sandbox.africastalking.com/version1"


  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url)

  @doc """
  This function builds and runs a post request to send an SMS via the Africa's talking SMS endpoint, this
  function accepts a map of parameters that should always contain  the `to` address and the `message` to be
  sent

  ## Parameters
  attrs: - a map containing a `to` and `message` key optionally it may also contain `from`, bulk_sms, enqueue, key_word
  link_id and retry_hours keys, see the docs at https://build.at-labs.io/docs/sms%2Fsending for how to use these keys
  """
  @spec send_sms(map()) :: {:ok, term()} | {:error, term()}
  def send_sms(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    "/messaging"
    |> post(params)
    |> process_result()
  end

  @doc """
  This function makes a get request to fetch an SMS via the Africa's talking SMS endpoint, this
  function accepts a map of parameters that optionally accepts `lastReceivedId` of the message.
  sent

  ## Parameters
  attrs: - an empty map or a map containing optionally `lastReceivedId` of the message to be fetched, see the docs at https://build.at-labs.io/docs/sms%2Ffetch_messages for how to use these keys
  """

  @spec fetch_sms(map()) :: {:error, any()} | {:ok, any()}
  def fetch_sms(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.to_list()

    with {:ok, %{status: 200} = res} <- get("/messaging", query: params) do
      {:ok, Jason.decode!(res.body)}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end
end
