defmodule RingCentral.OAuth do
  @moduledoc """
  The Main module to interact with RingCentral [OAuth 2.0 Flow](https://developer.ringcentral.com/api-reference#OAuth-2-0).

  All functions are delegated to `OAuth2.Client`.

  Example:

  ```elixir
  RingCentral.OAuth.authorize_url!(client, ui_options: "hide_logo")
  ```

  Generates:

  ```
  "https://platform.devtest.ringcentral.com/restapi/oauth/authorize?client_id=ID&redirect_uri=https%3A%2F%2Fringcentral-elixir.test&response_type=code&ui_options=hide_logo
  ```
  """

  defdelegate authorize_url!(client, params \\ []), to: OAuth2.Client

  defdelegate get_token!(client, params \\ [], headers \\ [], opts \\ []), to: OAuth2.Client
  defdelegate get_token(client, params \\ [], headers \\ [], opts \\ []), to: OAuth2.Client

  defdelegate refresh_token!(client, params \\ [], headers \\ [], opts \\ []), to: OAuth2.Client
  defdelegate refresh_token(client, params \\ [], headers \\ [], opts \\ []), to: OAuth2.Client
end
