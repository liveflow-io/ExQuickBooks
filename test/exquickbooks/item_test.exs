defmodule ExQuickBooks.ItemTest do
  use ExUnit.Case, async: false
  use ExQuickBooks.APICase

  alias ExQuickBooks.AccessToken
  alias ExQuickBooks.Item

  doctest Item

  @token %AccessToken{
    token: "token",
    token_secret: "secret",
    realm_id: "realm_id"
  }

  test "create_item/3 creates an item" do
    load_response("item/create_item.json") |> send_response

    assert {:ok, %{"Item" => _}} =
      Item.create_item(@token, %{foo: true})

    assert %{body: body} = take_request()
    assert String.contains?(to_string(body), "foo")
  end

  test "create_item/3 recovers from an error" do
    load_response("item/create_item_error.json")
    |> Map.put(:status_code, 400)
    |> send_response

    assert {:error, %{"Fault" => _}} =
      Item.create_item(@token, %{foo: true})
  end

  test "read_item/3 retrieves an item" do
    load_response("item/read_item.json") |> send_response

    assert {:ok, %{"Item" => _}} =
      Item.read_item(@token, "item_id")

    assert %{url: url} = take_request()
    assert String.contains?(url, "/item_id")
  end

  test "read_item/3 recovers from an error" do
    load_response("item/read_item_error.json")
    |> Map.put(:status_code, 400)
    |> send_response

    assert {:error, %{"Fault" => _}} =
      Item.read_item(@token, "item_id")
  end

  test "update_item/3 updates and retrieves an item" do
    load_response("item/update_item.json") |> send_response

    assert {:ok, %{"Item" => _}} =
      Item.update_item(@token, %{foo: true})

    assert %{body: body} = take_request()
    assert String.contains?(to_string(body), "foo")
  end

  test "update_item/3 recovers from an error" do
    load_response("item/update_item_error.json")
    |> Map.put(:status_code, 400)
    |> send_response

    assert {:error, %{"Fault" => _}} =
      Item.update_item(@token, %{foo: true})
  end
end
