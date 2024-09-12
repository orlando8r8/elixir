defmodule InventoryManager do
  defstruct products: [], cart: []

  def add_product(%InventoryManager{products: products} = inventory, name, price, stock) do
    id = Enum.count(products) + 1
    product = %{id: id, name: name, price: price, stock: stock}
    %{inventory | products: products ++ [product]}
  end

  def list_products(%InventoryManager{products: products}) do
    if Enum.empty?(products) do
      IO.puts("No existen productos.")
    else
      Enum.each(products, fn product ->
        formatted_price = :io_lib.format("~.1f", [product.price]) |> List.to_string()
        IO.puts(" #{product.name} [Id: #{product.id} Precio: #{formatted_price} Stock: #{product.stock}]")
      end)
    end
  end

  def increase_stock(%InventoryManager{products: products} = inventory, id, quantity) do
    updated_products = Enum.map(products, fn product ->
      if product.id == id do
        IO.puts("Producto agregado.")
        %{product | stock: product.stock + quantity}
      else
        product
      end
    end)
    %{inventory | products: updated_products}
  end

  def sell_product(%InventoryManager{products: products, cart: cart} = inventory, id, quantity) do
    {updated_products, updated_cart} = Enum.reduce(products, {[], cart}, fn product, {acc_products, acc_cart} ->
      if product.id == id do
        if product.stock >= quantity do
          updated_product = %{product | stock: product.stock - quantity}
          updated_cart = acc_cart ++ [%{product | stock: quantity}]
          IO.puts("Se vendieron #{quantity} unidades del producto #{product.name}.")
          {[updated_product | acc_products], updated_cart}
        else
          IO.puts("Stock insuficiente para el producto #{product.name}")
          {[product | acc_products], acc_cart}
        end
      else
        {[product | acc_products], acc_cart}
      end
    end)
    %{inventory | products: Enum.reverse(updated_products), cart: updated_cart}
  end

  def view_cart(cart) do
    total_cost = Enum.reduce(cart, 0, fn product, acc ->
      cost = product.price * product.stock
      IO.puts("#{product.name} [Cantidad: #{product.stock} Precio: #{product.price} Costo: #{cost}]")
      acc + cost
    end)
    IO.puts("Costo total: #{total_cost}")
  end

  def checkout(%InventoryManager{cart: cart} = inventory) do
    total_cost = Enum.reduce(cart, 0, fn product, acc ->
      acc + (product.price * product.stock)
    end)

    IO.puts("El costo total es: #{total_cost}")
    IO.puts("Productos comprados.")

    %{inventory | cart: []}
  end

  def run do
    inventory = %InventoryManager{}
    loop(inventory)
  end

  defp loop(inventory) do
    IO.puts("""
    Gestor de Inventario
    1. Agregar Producto
    2. Listar Productos
    3. Aumentar Stock
    4. Agregar producto al carrito
    5. Ver Carrito
    6. Checkout
    7. Salir
    """)

    IO.write("Seleccione una opción: ")
    option = IO.gets("") |> String.trim() |> String.to_integer()

    case option do
      1 ->
        IO.write("Ingrese el nombre del producto: ")
        name = IO.gets("") |> String.trim()
        IO.write("Ingrese el precio del producto: ")
        price = IO.gets("") |> String.trim() |> String.to_float()
        IO.write("Ingrese el stock del producto: ")
        stock = IO.gets("") |> String.trim() |> String.to_integer()
        inventory = add_product(inventory, name, price, stock)
        loop(inventory)

      2 ->
        list_products(inventory)
        loop(inventory)

      3 ->
        IO.write("Ingrese el ID del producto: ")
        id = IO.gets("") |> String.trim() |> String.to_integer()
        IO.write("Ingrese la cantidad a aumentar: ")
        quantity = IO.gets("") |> String.trim() |> String.to_integer()
        inventory = increase_stock(inventory, id, quantity)
        loop(inventory)

      4 ->
        IO.write("Ingrese el ID del producto: ")
        id = IO.gets("") |> String.trim() |> String.to_integer()
        IO.write("Ingrese la cantidad del producto que desea agregar: ")
        quantity = IO.gets("") |> String.trim() |> String.to_integer()
        inventory = sell_product(inventory, id, quantity)
        loop(inventory)

      5 ->
        view_cart(inventory.cart)
        loop(inventory)

      6 ->
        inventory = checkout(inventory)
        loop(inventory)

      7 ->
        IO.puts("¡Adiós!")
        :ok

      _ ->
        IO.puts("Opción no válida.")
        loop(inventory)
    end
  end
end

InventoryManager.run()