defmodule Ahab.Utils do
   def underscore(input) do
    input |> String.trim |> String.replace(" ", "_")
  end
end
