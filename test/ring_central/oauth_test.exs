defmodule RingCentral.OAuthTest do
  use RingCentral.TestCase, async: false

  describe "authorize/2" do
    test "Authorization Code Flow", %{bypass: bypass, ringcentral: ringcentral} do
      Bypass.expect_once(bypass, "GET", "/restapi/oauth/authorize", fn conn ->
        conn
        |> Plug.Conn.put_resp_header(
          "Location",
          "https://service.ringcentral.com/mobile/loginDispatcher?session=2008293087662283621&clientId=9oQlL98tTQGhpdqq5KB60Q&state=ABC123&brandId=1210&appUrlScheme=https%3A%2F%2Fmyapp%2Eexample%2Ecom%2Foauthredirect&localeId=en_US&display=page&prompt=login&hideNavigationBar=true"
        )
        |> Plug.Conn.resp(302, "")
      end)

      response =
        RingCentral.OAuth.authorize(ringcentral, %{
          response_type: "code",
          redirect_uri: "https://ringcentral-elixir.test"
        })

      assert {:ok,
              "https://service.ringcentral.com/mobile/loginDispatcher?session=2008293087662283621&clientId=9oQlL98tTQGhpdqq5KB60Q&state=ABC123&brandId=1210&appUrlScheme=https%3A%2F%2Fmyapp%2Eexample%2Ecom%2Foauthredirect&localeId=en_US&display=page&prompt=login&hideNavigationBar=true"} ==
               response
    end

    test "Implicit Grant Type Flow", %{bypass: bypass, ringcentral: ringcentral} do
      Bypass.expect_once(bypass, "GET", "/restapi/oauth/authorize", fn conn ->
        conn
        |> Plug.Conn.put_resp_header(
          "Location",
          "https://service.ringcentral.com/mobile/loginDispatcher?session=2008293087662283621&clientId=9oQlL98tTQGhpdqq5KB60Q&state=xyz&brandId=1210&appUrlScheme=http%3A%2F%2Fmyapp%2Eexample%2Ecom%2Foauthredirect&localeId=en_US&display=page&prompt=login%20consent&hideNavigationBar=true"
        )
        |> Plug.Conn.resp(302, "")
      end)

      response =
        RingCentral.OAuth.authorize(ringcentral, %{
          response_type: "token",
          redirect_uri: "https://ringcentral-elixir.test",
          state: "xyz",
          prompt: "login consent"
        })

      assert {:ok,
              "https://service.ringcentral.com/mobile/loginDispatcher?session=2008293087662283621&clientId=9oQlL98tTQGhpdqq5KB60Q&state=xyz&brandId=1210&appUrlScheme=http%3A%2F%2Fmyapp%2Eexample%2Ecom%2Foauthredirect&localeId=en_US&display=page&prompt=login%20consent&hideNavigationBar=true"} ==
               response
    end
  end

  describe "get_token/2" do
    test "Authorization Code Flow", %{bypass: bypass, ringcentral: ringcentral} do
      Bypass.expect_once(bypass, "POST", "/restapi/oauth/token", fn conn ->
        conn
        |> Plug.Conn.resp(
          200,
          ~s"""
          {
            "access_token" : "U1BCMDFUMDRKV1MwMXxzLFSvXdw5PHMsVLEn_MrtcyxUsw",
            "token_type" : "bearer",
            "expires_in" : 7199,
            "refresh_token" : "U1BCMDFUMDRKV1MwMXxzLFL4ec6A0XMsUv9wLriecyxS_w",
            "refresh_token_expires_in" : 604799,
            "scope" : "AccountInfo CallLog ExtensionInfo Messages SMS",
            "owner_id" : "256440016"
          }
          """
        )
      end)

      response =
        RingCentral.OAuth.get_token(ringcentral, %{
          grant_type: "authorization_code",
          code: "U0pDMDFQMDRQQVMwMnxBQUFGTVUyYURGYi0wUEhEZ2VLeGFiamFvZlNMQlZ5TExBUHBlZVpTSVlhWk",
          redirect_uri: "https://www.example.com/myapp"
        })

      {:ok, token_info} = response

      assert token_info["access_token"] == "U1BCMDFUMDRKV1MwMXxzLFSvXdw5PHMsVLEn_MrtcyxUsw"
      assert token_info["token_type"] == "bearer"
    end

    test "Password Flow (Phone)", %{bypass: bypass, ringcentral: ringcentral} do
      Bypass.expect_once(bypass, "POST", "/restapi/oauth/token", fn conn ->
        conn
        |> Plug.Conn.resp(
          200,
          ~s"""
          {
            "access_token" : "U1BCMDFUMDRKV1MwMXxzLFSvXdw5PHMsVLEn_MrtcyxUsw",
            "token_type" : "bearer",
            "expires_in" : 7199,
            "refresh_token" : "U1BCMDFUMDRKV1MwMXxzLFL4ec6A0XMsUv9wLriecyxS_w",
            "refresh_token_expires_in" : 604799,
            "owner_id" : "256440016"
          }
          """
        )
      end)

      response =
        RingCentral.OAuth.get_token(ringcentral, %{
          grant_type: "password",
          username: "18559100010*123",
          password: "121212"
        })

      {:ok, token_info} = response

      assert token_info["access_token"] == "U1BCMDFUMDRKV1MwMXxzLFSvXdw5PHMsVLEn_MrtcyxUsw"
      assert token_info["token_type"] == "bearer"
    end

    test "Password Flow (Email)", %{bypass: bypass, ringcentral: ringcentral} do
      Bypass.expect_once(bypass, "POST", "/restapi/oauth/token", fn conn ->
        conn
        |> Plug.Conn.resp(
          200,
          ~s"""
          {
            "access_token" : "U1BCMDFUMDRKV1MwMXxzLFSvXdw5PHMsVLEn_MrtcyxUsw",
            "token_type" : "bearer",
            "expires_in" : 7199,
            "refresh_token" : "U1BCMDFUMDRKV1MwMXxzLFL4ec6A0XMsUv9wLriecyxS_w",
            "refresh_token_expires_in" : 604799,
            "owner_id" : "256440016"
          }
          """
        )
      end)

      response =
        RingCentral.OAuth.get_token(ringcentral, %{
          grant_type: "password",
          username: "john%2Bdoe%40example.com",
          password: "121212"
        })

      {:ok, token_info} = response

      assert token_info["access_token"] == "U1BCMDFUMDRKV1MwMXxzLFSvXdw5PHMsVLEn_MrtcyxUsw"
      assert token_info["token_type"] == "bearer"
    end

    test "Refresh Token Flow", %{bypass: bypass, ringcentral: ringcentral} do
      Bypass.expect_once(bypass, "POST", "/restapi/oauth/token", fn conn ->
        conn
        |> Plug.Conn.resp(
          200,
          ~s"""
          {
            "access_token" : "U1BCMDFUMDRKV1MwMXxzLFSvXdw5PHMsVLEn_MrtcyxUsw",
            "token_type" : "bearer",
            "expires_in" : 7199,
            "refresh_token" : "U1BCMDFUMDRKV1MwMXxzLFL4ec6A0XMsUv9wLriecyxS_w",
            "refresh_token_expires_in" : 604799,
            "owner_id" : "256440016"
          }
          """
        )
      end)

      response =
        RingCentral.OAuth.get_token(ringcentral, %{
          grant_type: "refresh_token",
          refresh_token: "BCMDFUMDRKV1MwMXx5d5dwzLFL4ec6U1A0XMsUv935527jghj48"
        })

      {:ok, token_info} = response

      assert token_info["access_token"] == "U1BCMDFUMDRKV1MwMXxzLFSvXdw5PHMsVLEn_MrtcyxUsw"
      assert token_info["token_type"] == "bearer"
    end
  end

  describe "revoke_token/2" do
    test "Revoke Token", %{bypass: bypass, ringcentral: ringcentral} do
      Bypass.expect_once(bypass, "POST", "/restapi/oauth/revoke", fn conn ->
        conn
        |> Plug.Conn.resp(200, "")
      end)

      assert :ok ==
               RingCentral.OAuth.revoke_token(
                 ringcentral,
                 "U0pDMDFQMDFKV1MwMXwJ_W7L1fG4eGXBW9Pp-otywzriCw"
               )
    end
  end
end
