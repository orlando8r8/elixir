defmodule Company.GenServer do
  @moduledoc """
  This module provides a GenServer implementation for managing employee data.

  ## Functions

    * `start_link/1` - Starts the GenServer.
    * `crash/0` - Intentionally crashes the GenServer.
    * `new_employee/3` - Adds a new employee.
    * `write_employee/1` - Writes an employee's data.
    * `read_all_employees/0` - Reads all employees' data.
    * `read_employee_by_id/1` - Reads an employee's data by ID.
    * `delete_employee_by_id/1` - Deletes an employee by ID.
    * `increase_salary/1` - Increases an employee's salary by ID.

  ## Examples

      iex> Company.GenServer.start_link([])
      {:ok, pid}

      iex> Company.GenServer.new_employee("John Doe", "Developer")
      %Empresa.Employee{name: "John Doe", position: "Developer"}

      iex> emp = Company.GenServer.new_employee("John Doe", "Developer")
      Company.GenServer.write_employee(emp)

      iex> Company.GenServer.read_all_employees()
      [%Empresa.Employee{name: "John Doe", position: "Developer"}]

      iex> Company.GenServer.read_employee_by_id(1)
      %Empresa.Employee{id: 1, name: "John Doe", position: "Developer"}

      iex> Company.GenServer.delete_employee_by_id(1)
      :ok

      iex> Company.GenServer.increase_salary(1)
      :ok
  """

  use GenServer

  @doc """
  Starts the GenServer.

  ## Parameters

    - `args`: List of arguments (optional).

  ## Returns

    - `{:ok, pid}` if the GenServer starts successfully.
    - `{:error, reason}` if there is an error starting the GenServer.
  """
  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Intentionally crashes the GenServer.
  """
  def crash do
    raise "Intentional crash"
  end

  @doc """
  Stops the GenServer.
  """
  def stop do
    GenServer.stop(__MODULE__)
  end

  @doc """
  Adds a new employee.

  ## Parameters

    - `name`: String, the name of the employee.
    - `position`: String, the position of the employee.
    - `opts`: List of options (optional).

  ## Returns

    - `{:ok, employee}` if the employee is added successfully.
    - `{:error, reason}` if there is an error adding the employee.
  """
  def new_employee(name, position, opts \\ []) do
    GenServer.call(__MODULE__, {:new_employee, name, position, opts})
  end

  @doc """
  Writes an employee's data.

  ## Parameters

    - `employee`: The employee struct to write.

  ## Returns

    - `:ok` if the employee's data is written successfully.
    - `{:error, reason}` if there is an error writing the data.
  """
  def write_employee(employee) do
    GenServer.call(__MODULE__, {:write_employee, employee})
  end

  @doc """
  Reads all employees' data.

  ## Returns

    - A list of employee structs.
  """
  def read_all_employees do
    GenServer.call(__MODULE__, :read_all_employees)
  end

  @doc """
  Reads an employee's data by ID.

  ## Parameters

    - `id`: Integer, the ID of the employee.

  ## Returns

    - The employee struct if found.
    - `{:error, reason}` if there is an error or the employee is not found.
  """
  def read_employee_by_id(id) do
    GenServer.call(__MODULE__, {:read_employee_by_id, id})
  end

  @doc """
  Deletes an employee by ID.

  ## Parameters

    - `id`: Integer, the ID of the employee to delete.

  ## Returns

    - `:ok` if the employee is deleted successfully.
    - `{:error, reason}` if there is an error deleting the employee.
  """
  def delete_employee_by_id(id) do
    GenServer.call(__MODULE__, {:delete_employee_by_id, id})
  end

  @doc """
  Increases an employee's salary by ID.

  ## Parameters

    - `id`: Integer, the ID of the employee whose salary is to be increased.

  ## Returns

    - `:ok` if the salary is increased successfully.
    - `{:error, reason}` if there is an error increasing the salary.
  """
  def increase_salary(id) do
    GenServer.call(__MODULE__, {:increase_salary, id})
  end

  # Server Callbacks
  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call({:new_employee, name, position, opts}, _from, state) do
    result = Empresa.Employee.new(name, position, opts)
    {:reply, result, state}
  end

  def handle_call({:write_employee, employee}, _from, state) do
    result = Writer.write_employee(employee)
    {:reply, result, state}
  end

  def handle_call(:read_all_employees, _from, state) do
    result = Reader.read_all_employees()
    {:reply, result, state}
  end

  def handle_call({:read_employee_by_id, id}, _from, state) do
    result = Reader.read_employee_by_id(id)
    {:reply, result, state}
  end

  def handle_call({:delete_employee_by_id, id}, _from, state) do
    result = Deleter.delete_employee_by_id(id)
    {:reply, result, state}
  end

  def handle_call({:increase_salary, id}, _from, state) do
    result = Manager.increase_salary(id)
    {:reply, result, state}
  end
end