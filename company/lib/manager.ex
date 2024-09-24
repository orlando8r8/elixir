defmodule Manager do
  @moduledoc """
  This module provides functions to manage employee data, including increasing salaries.

  ## Functions

    * `increase_salary/2` - Increases the salary of an employee by their ID.

  ## Examples

      iex> Manager.increase_salary(1)
      :ok
      iex> Manager.increase_salary(999)
      {:error, "Employee not found"}
  """

  alias Empresa.Employee

  @doc """
  Increases the salary of an employee by their ID.

  ## Parameters

    - `id`: Integer, the ID of the employee whose salary is to be increased.
    - `filename`: String, the name of the JSON file to read from (optional, default: "employees.json").

  ## Returns

    - `:ok` if the salary was successfully increased.
    - `{:error, reason}` if there was an error reading or writing the file, or if the employee was not found.

  ## Examples

      iex> Manager.increase_salary(1)
      :ok
      iex> Manager.increase_salary(999)
      {:error, "Employee not found"}
  """
  @spec increase_salary(integer(), String.t()) :: :ok | {:error, term()}
  def increase_salary(id, filename \\ "employees.json") do
    case File.read(filename) do
      {:ok, contents} ->
        employees = Jason.decode!(contents, keys: :atoms)
                    |> Enum.map(&struct(Employee, &1))

        if Enum.any?(employees, &(&1.id == id)) do
          updated_employees = Enum.map(employees, fn employee ->
            if employee.id == id do
              salary = Map.get(employee, :salary, 0)
              new_salary = if is_number(salary), do: Float.round(salary * 1.1, 2), else: 0
              Map.put(employee, :salary, new_salary)
            else
              employee
            end
          end)
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