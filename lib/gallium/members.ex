defmodule Gallium.Members do
  @moduledoc """
  The Members context.
  """

  import Ecto.Query, warn: false

  alias Gallium.Accounts.Scope
  alias Gallium.Members.CesiumMember
  alias Gallium.Repo
  alias NimbleCSV.RFC4180, as: CSV

  @doc """
  Subscribes to scoped notifications about any cesium_member changes.

  The broadcasted messages match the pattern:

    * {:created, %CesiumMember{}}
    * {:updated, %CesiumMember{}}
    * {:deleted, %CesiumMember{}}

  """
  def subscribe_cesium_members(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Gallium.PubSub, "user:#{key}:cesium_members")
  end

  defp broadcast_cesium_member(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Gallium.PubSub, "user:#{key}:cesium_members", message)
  end

  @doc """
  Returns the list of cesium_members.

  ## Examples

      iex> list_cesium_members(scope)
      [%CesiumMember{}, ...]

  """
  def list_cesium_members(%Scope{} = scope) do
    Repo.all_by(CesiumMember, user_id: scope.user.id)
  end

  @doc """
  Gets a single cesium_member.

  Raises `Ecto.NoResultsError` if the Cesium member does not exist.

  ## Examples

      iex> get_cesium_member!(scope, 123)
      %CesiumMember{}

      iex> get_cesium_member!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_cesium_member!(%Scope{} = scope, id) do
    Repo.get_by!(CesiumMember, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a cesium_member.

  ## Examples

      iex> create_cesium_member(scope, %{field: value})
      {:ok, %CesiumMember{}}

      iex> create_cesium_member(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cesium_member(%Scope{} = scope, attrs) do
    with {:ok, cesium_member = %CesiumMember{}} <-
           %CesiumMember{}
           |> CesiumMember.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_cesium_member(scope, {:created, cesium_member})
      {:ok, cesium_member}
    end
  end

  @doc """
  Updates a cesium_member.

  ## Examples

      iex> update_cesium_member(scope, cesium_member, %{field: new_value})
      {:ok, %CesiumMember{}}

      iex> update_cesium_member(scope, cesium_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cesium_member(%Scope{} = scope, %CesiumMember{} = cesium_member, attrs) do
    true = cesium_member.user_id == scope.user.id

    with {:ok, cesium_member = %CesiumMember{}} <-
           cesium_member
           |> CesiumMember.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_cesium_member(scope, {:updated, cesium_member})
      {:ok, cesium_member}
    end
  end

  @doc """
  Deletes a cesium_member.

  ## Examples

      iex> delete_cesium_member(scope, cesium_member)
      {:ok, %CesiumMember{}}

      iex> delete_cesium_member(scope, cesium_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cesium_member(%Scope{} = scope, %CesiumMember{} = cesium_member) do
    true = cesium_member.user_id == scope.user.id

    with {:ok, cesium_member = %CesiumMember{}} <-
           Repo.delete(cesium_member) do
      broadcast_cesium_member(scope, {:deleted, cesium_member})
      {:ok, cesium_member}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cesium_member changes.

  ## Examples

      iex> change_cesium_member(scope, cesium_member)
      %Ecto.Changeset{data: %CesiumMember{}}

  """
  def change_cesium_member(%Scope{} = scope, %CesiumMember{} = cesium_member, attrs \\ %{}) do
    true = cesium_member.user_id == scope.user.id

    CesiumMember.changeset(cesium_member, attrs, scope)
  end

  @doc """
  Imports a list of cesium_members from a CSV file.
  The CSV must have the headers: id_socio, numero_aluno, nome
  Since the file serves as a sync, existing members for this scope are deleted.
  """
  def import_cesium_members(%Scope{} = scope, file_path) do
    unless File.exists?(file_path) do
      {:error, "Ficheiro CSV não encontrado."}
    end

    try do
      stream =
        file_path
        |> File.stream!()
        |> Stream.map(&String.replace(&1, "\uFEFF", ""))
        |> CSV.parse_stream(skip_headers: false)

      format = detect_csv_format(stream)
      import_from_stream(scope, stream, format)
    rescue
      NimbleCSV.ParseError ->
        {:error,
         "Formato CSV inválido. Certifique-se de que o separador é um um ponto e vírgula (;) e não uma (,)."}
    end
  end

  defp detect_csv_format(stream) do
    case Enum.take(stream, 1) do
      [[col1, col2, col3]]
      when col1 == "id_socio" and col2 == "numero_aluno" and col3 == "nome" ->
        :id_socio_first

      [[col1, col2, col3]]
      when col1 == "nome" and col2 == "id_socio" and col3 == "numero_aluno" ->
        :nome_first

      _ ->
        {:error, "O CSV não tem a estrutura requerida (id_socio, numero_aluno, nome)."}
    end
  end

  defp import_from_stream(%Scope{} = _scope, _stream, {:error, _} = error), do: error

  defp import_from_stream(%Scope{} = scope, stream, format) do
    # Entire operation is atomic - all or nothing
    Repo.transaction(fn ->
      # Remove existing members for this scope completely inserting the new ones
      Repo.delete_all(from(c in CesiumMember))

      stream
      |> Stream.drop(1)
      |> Enum.each(&process_row(scope, format, &1))

      "Sócios importados com sucesso!"
    end)
    |> case do
      {:ok, msg} -> {:ok, msg}
      {:error, reason} -> {:error, "Erro a importar sócios: #{inspect(reason)}"}
    end
  end

  defp process_row(scope, format, row) do
    attrs = format_row_attrs(format, row)
    if attrs, do: create_cesium_member(scope, attrs)
  end

  defp format_row_attrs(:id_socio_first, [id_socio, numero_aluno, nome]) do
    %{member_id: id_socio, student_number: numero_aluno, name: nome}
  end

  defp format_row_attrs(:nome_first, [nome, id_socio, numero_aluno]) do
    %{name: nome, member_id: id_socio, student_number: numero_aluno}
  end

  defp format_row_attrs(_, _), do: nil

  def cesium_member?(student_number) do
    Repo.exists?(
      from m in CesiumMember,
        where: fragment("LOWER(TRIM(?))", m.student_number) == ^student_number
    )
  end
end
