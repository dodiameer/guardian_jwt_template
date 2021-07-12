defmodule MyApp.Utilities do

  def decode_signed_cookie(""), do: nil
  def decode_signed_cookie(nil), do: nil
  def decode_signed_cookie(cookie) do
    [_, payload, _] = String.split(cookie, ".", parts: 3)
    {:ok, encoded_term } = Base.url_decode64(payload, padding: false)
    {value, _, _} = :erlang.binary_to_term(encoded_term)
    value
  end
end
