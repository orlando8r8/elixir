defmodule Deleter do
  @moduledoc """
  This module provides functions to delete employee data from a JSON file.

  ## Functions

    * `delete_employee_by_id/2` - Deletes an employee by their ID from the JSON file.

  ## Examples

      iex> Deleter.delete_employee_by_id(1)
      :ok
      iex> Deleter.delete_employee_by_id(999)
      {:error, :enoent}
  """

  alias Empresa.Employee

  @doc """
  Deletes an employee by their ID from the JSON file.

  ## Parameters

    - `id`: Integer, the ID of the employee to delete.
    - `filename`: String, the name of the JSON file to delete from (optional, default: "employees.json").

  ## Returns

    - `:ok` if the employee was successfully deleted.
    - `{:error, reason}` if there was an error reading or writing the file.

  ## Examples

      iex> Deleter.delete_employee_by_id(1)
      :ok
      iex> Deleter.delete_employee_by_id(999)
      {:error, :enoent}
  """
  @spec delete_employee_by_id(integer(), String.t()) :: :ok | {:error, term()}
  def delete_employee_by_id(id, filename \\ "employees.json") do
    case File.read(filename) do
      {:ok, contents} ->
        employees = Jason.decode!(contents, keys: :atoms)
                    |> Enum.map(&struct(Employee, &1))

        if Enum.any?(employees, &(&1.id == id)) do
          updated_employees = Enum.reject(employees, &(&1.id == id))
          updated_contents = Jason.encode!(updated_employees)
          File.write(filename, updated_contents)
          :ok
        else
          {:error, "Employee not found"}
        end

      {:error, reason} -> {:error, reason}
    end
  end
end