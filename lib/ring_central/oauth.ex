defmodule RingCentral.OAuth do
  @moduledoc """
  The main module for the [Authorization flow](https://developers.ringcentral.com/api-reference/authentication)
  """

  alias RingCentral.HTTPClient
  alias RingCentral.Response
  alias RingCentral.Error

  @doc """
  Get the URL for initializing the OAuth 2.0 authorizaiton flow.

  `params` is a map contains the options described in
  the [official documentation](https://developers.ringcentral.com/api-reference/Authorization)

  ## Example

  ```elixir
  ringcentral = %RingCentral{
    client_id: "the-client-id",
    client_secret: "the-client-secret",
    http_client: RingCentral.HTTPClient.DefaultClient,
    server_url: "https://platform.ringcentral.com",
    token_info: nil
  }

  {:ok, authorization_url} = RingCentral.OAuth.authorize(ringcentral, %{
    response_type: "code",
    redirect_uri: "https://ringcentral-elixir.test"
  })
  # {:ok, "https://service.ringcentral.com/..."}
  ```
  """
  @spec authorize(RingCentral.t(), map()) :: {:error, RingCentral.Error.t()} | {:ok, String.t()}
  def authorize(%RingCentral{} = ringcentral, params \\ %{}) do
    query =
      Map.merge(
        %{
          client_id: ringcentral.client_id
        },
        params
      )

    url =
      ringcentral
      |> build_url("/restapi/oauth/authorize")
      |> Map.put(:query, URI.encode_query(query))

    with {:ok, %Response{status: 302, headers: headers}} <-
           HTTPClient.perform_request(ringcentral, :get, url, nil) do
      location =
        headers
        |> Enum.reduce_while(nil, fn
          {"location", v}, _acc -> {:halt, v}
          _, acc -> {:cont, acc}
        end)

      {:ok, location}
    else
      error -> handle_error(error)
    end
  end

  @doc """
  Get the access token and refresh token.

  `params` is a map contains the options described in
  the [official documentation](https://developers.ringcentral.com/api-reference/Get-Token)

  ## Example

  ```elixir
  ringcentral = %RingCentral{
    client_id: "the-client-id",
    client_secret: "the-client-secret",
    http_client: RingCentral.HTTPClient.DefaultClient,
    server_url: "https://platform.ringcentral.com",
    token_info: nil
  }

  {:ok, token_info} = RingCentral.OAuth.get_token(ringcentral, %{
    grant_type: "authorization_code",
    code: "U0pDMDFQMDRQQVMwMnxBQUFGTVUyYURGYi0wUEhEZ2VLeGFiamFvZlNMQlZ5TExBUHBlZVpTSVlhWk",
    redirect_uri: "https://ringcentral-elixir.test"
  })
  # {:ok, %{"access_token": "...", "token_type": "bearer", "refresh_token": "..."}}
  ```
  """
  @spec get_token(RingCentral.t(), map()) :: {:error, RingCentral.Error.t()} | {:ok, String.t()}
  def get_token(%RingCentral{} = ringcentral, params \\ %{}) do
    url =
      ringcentral
      |> build_url("/restapi/oauth/token")

    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Authorization",
       "Basic " <> Base.encode64("#{ringcentral.client_id}:#{ringcentral.client_secret}")}
    ]

    with {:ok, %Response{status: 200, body: body}} <-
           HTTPClient.perform_request(
             ringcentral,
             :post,
             url,
             {:form, params},
             headers
           ) do
      token_info = RingCentral.JSON.decode!(ringcentral, body)
      {:ok, token_info}
    else
      error -> handle_error(error)
    end
  end

  @doc """
  Revokes access/refresh token.

  `token` is the active access or refresh token to be revoked,
  see the [official documentation](https://developers.ringcentral.com/api-reference/Revoke-Token) for more information.

  ## Example

  ```elixir
  ringcentral = %RingCentral{
    client_id: "the-client-id",
    client_secret: "the-client-secret",
    http_client: RingCentral.HTTPClient.DefaultClient,
    server_url: "https://platform.ringcentral.com",
    token_info: nil
  }

  RingCentral.OAuth.revoke_token(ringcentral, "U0pDMDFQMDFKV1MwMXwJ_W7L1fG4eGXBW9Pp-otywzriCw")
  # :ok
  ```

  """
  @spec revoke_token(RingCentral.t(), String.t()) :: {:error, RingCentral.Error.t()} | :ok
  def revoke_token(%RingCentral{} = ringcentral, token) do
    url =
      ringcentral
      |> build_url("/restapi/oauth/revoke")

    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Authorization",
       "Basic " <> Base.encode64("#{ringcentral.client_id}:#{ringcentral.client_secret}")}
    ]

    request_body = %{
      token: token
    }

    with {:ok, %Response{status: 200}} <-
           HTTPClient.perform_request(
             ringcentral,
             :post,
             url,
             {:form, request_body},
             headers
           ) do
      :ok
    else
      error -> handle_error(ringcentral, error)
    end
  end

  defp handle_error(
         ringcentral,
         {:ok, %Response{status: status_code, body: body, headers: headers}}
       )
       when status_code >= 400 and status_code < 500 do
    error_info = RingCentral.JSON.decode!(ringcentral, body)

    {:error,
     %Error{
       code: :client_error,
       detail: %{
         status: status_code,
         data: error_info,
         headers: headers
       }
     }}
  end

  defp handle_error(
         ringcentral,
         {:ok, %Response{status: status_code, body: body, headers: headers}}
       )
       when status_code >= 500 do
    error_info = RingCentral.JSON.decode!(ringcentral, body)

    {:error,
     %Error{
       code: :server_error,
       detail: %{
         status: status_code,
         data: error_info,
         headers: headers
       }
     }}
  end

  defp handle_error({:error, %Error{} = err}) do
    {:error, err}
  end

  defp build_url(%RingCentral{} = client, path) do
    URI.merge(client.server_url, path)
  end
end
