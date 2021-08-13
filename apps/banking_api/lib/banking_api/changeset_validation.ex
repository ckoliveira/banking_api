defmodule BankingApi.ChangesetValidation do
  @moduledoc """
  Validate input given to controller.
  """

  alias Ecto.Changeset

  def cast_and_apply(input, params) do
    %{}
    |> input.__struct__()
    |> input.changeset(params)
    |> case do
      %{valid?: true} = changeset ->
        {:ok, Changeset.apply_changes(changeset)}

      %Ecto.Changeset{valid?: false} = changeset ->
        {:error, changeset}
    end
  end
end
