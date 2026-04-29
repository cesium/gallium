defmodule Gallium.Members do
  @moduledoc """
  The Members context.
  """

  import Ecto.Query, warn: false

  alias Gallium.Members.CesiumMember
  alias Gallium.Repo
  alias NimbleCSV.RFC4180, as: CSV


  @doc """
  Returns the list of cesium_members.

  ## Examples

      iex> list_cesium_members()
      [%CesiumMember{}, ...]

  """
  def list_cesium_members do
    Repo.all(CesiumMember)
  end

  @doc """
  Gets a single cesium_member.

  Raises `Ecto.NoResultsError` if the Cesium member does not exist.

  ## Examples

      iex> get_cesium_member!(123)
      %CesiumMember{}

      iex> get_cesium_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cesium_member!(id) do
    Repo.get_by!(CesiumMember, id: id)
  end

  @doc """
  Creates a cesium_member.

  ## Examples

      iex> create_cesium_member(%{field: value})
      {:ok, %CesiumMember{}}

      iex> create_cesium_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cesium_member(attrs) do
    with {:ok, cesium_member = %CesiumMember{}} <-
           %CesiumMember{}
           |> CesiumMember.changeset(attrs)
           |> Repo.insert() do
      {:ok, cesium_member}
    end
  end

  @doc """
  Updates a cesium_member.

  ## Examples

      iex> update_cesium_member(cesium_member, %{field: new_value})
      {:ok, %CesiumMember{}}

      iex> update_cesium_member(cesium_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cesium_member(%CesiumMember{} = cesium_member, attrs) do
    with {:ok, cesium_member = %CesiumMember{}} <-
           cesium_member
           |> CesiumMember.changeset(attrs)
           |> Repo.update() do
      {:ok, cesium_member}
    end
  end

  @doc """
  Deletes a cesium_member.

  ## Examples

      iex> delete_cesium_member(cesium_member)
      {:ok, %CesiumMember{}}

      iex> delete_cesium_member(cesium_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cesium_member(%CesiumMember{} = cesium_member) do
    with {:ok, cesium_member = %CesiumMember{}} <-
           Repo.delete(cesium_member) do
      {:ok, cesium_member}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cesium_member changes.

  ## Examples

      iex> change_cesium_member(cesium_member)
      %Ecto.Changeset{data: %CesiumMember{}}

  """
  def change_cesium_member(%CesiumMember{} = cesium_member, attrs \\ %{}) do
    CesiumMember.changeset(cesium_member, attrs)
  end

  @doc """
  Imports a list of cesium_members from a CSV file.
  The CSV must have the headers: id_socio, numero_aluno, nome
  Since the file serves as a sync, existing members for this scope are deleted.

  The headers of the CSV file must be exactly: id_socio, numero_aluno, nome. The function will return an error if the structure is not correct or if the file is not found.
  """
  def import_cesium_members(file_path) do
  if File.exists?(file_path) do
    try do
      stream =
        file_path
        |> File.stream!()
        |> CSV.parse_stream(skip_headers: false)

      status = validate_csv_headers(stream)
      import_from_stream(stream, status)
    rescue
      NimbleCSV.ParseError ->
        {:error,
         "Formato CSV inválido. Certifique-se de que o separador é um ponto e vírgula (;) e não uma (,)."}
    end
  else
    {:error, "Ficheiro CSV não encontrado."}
  end
end

  defp validate_csv_headers(stream) do
    case Enum.take(stream, 1) do
      [["id_socio", "numero_aluno", "nome"]] ->
        :ok

      _ ->
        {:error, "O CSV não tem a estrutura requerida (id_socio, numero_aluno, nome)."}
    end
  end

  defp import_from_stream(_stream, {:error, _} = error), do: error

  defp import_from_stream(stream, :ok) do
    # Entire operation is atomic - all or nothing
    Repo.transaction(fn ->
      # Remove existing members completely inserting the new ones
      CesiumMember
      |> Repo.delete_all()

      stream
      |> Stream.drop(1)
      |> Enum.each(&process_row/1)

      "Sócios importados com sucesso!"
    end)
    |> case do
      {:ok, msg} -> {:ok, msg}
      {:error, reason} -> {:error, "Erro a importar sócios: #{inspect(reason)}"}
    end
  end

  defp process_row(row) do
    attrs = format_row_attrs(row)
    if attrs, do: create_cesium_member(attrs)
  end

  defp format_row_attrs([id_socio, numero_aluno, nome]) do
    %{member_id: id_socio, student_number: String.downcase(String.trim(numero_aluno)), name: nome}
  end
  defp format_row_attrs(_), do: nil

  def cesium_member?(student_number) do
    query = from m in CesiumMember, where: m.student_number == ^student_number
    Repo.exists?(query)
  end
end
