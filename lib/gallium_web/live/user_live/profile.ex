defmodule GalliumWeb.UserLive.Profile do
  use GalliumWeb, :live_view

  alias Gallium.Accounts
  import GalliumWeb.Components.Button
  import GalliumWeb.Layouts

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_scope.user.id

    case Accounts.get_user_info_by_id(user_id) do
      {:ok, user_info} ->
        {:ok, assign(socket, :user_info, user_info)}

      {:error, _} ->
        {:ok, assign(socket, :user_info, nil)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-3xl mx-auto py-12 px-4">
        <div class="text-center mb-10">
          <h1 class="text-5xl font-amarante text-olive uppercase mb-4">O Meu Perfil</h1>
          <p class="font-cormorant text-gray-600 text-2xl">
            {@current_scope.user.email}
          </p>
        </div>

        <%= if @user_info do %>
          <div class="bg-white border-2 border-olive p-8 rounded-md shadow-sm mb-8 relative overflow-hidden">
            <div class="absolute top-0 right-0 bg-olive text-white font-amarante px-4 py-1 rounded-bl-lg text-sm uppercase">
              Bilhete Confirmado
            </div>

            <h2 class="font-amarante text-olive uppercase text-2xl mb-6">Informação do Bilhete</h2>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 font-cormorant text-lg">
              <div>
                <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">Nome</p>
                <p class="text-gray-800 font-bold">{@user_info.full_name}</p>
              </div>

              <div>
                <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">Telemóvel</p>
                <p class="text-gray-800">{@user_info.phone_number}</p>
              </div>

              <div>
                <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">Número de Aluno</p>
                <p class="text-gray-800">{@user_info.student_number}</p>
              </div>

              <div>
                <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">Tipo de Bilhete</p>
                <p class="text-gray-800">
                  {if @user_info.is_cesium_member, do: "Sócio CeSIUM", else: "Normal"}
                </p>
              </div>
              <%= if @user_info.nif do %>
                <div>
                  <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">NIF</p>
                  <p class="text-gray-800">{@user_info.nif}</p>
                </div>
              <% end %>
            </div>

            <%= if @user_info.accompany do %>
              <div class="mt-8 pt-6 border-t-2 border-dashed border-olive-200">
                <h2 class="font-amarante text-olive uppercase text-xl mb-4">Acompanhante</h2>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 font-cormorant text-lg">
                  <div>
                    <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">Nome</p>
                    <p class="text-gray-800 font-bold">{@user_info.accompany.full_name}</p>
                  </div>

                  <div>
                    <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">Telemóvel</p>
                    <p class="text-gray-800">{@user_info.accompany.phone_number}</p>
                  </div>

                  <div>
                    <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">Email</p>
                    <p class="text-gray-800">{@user_info.accompany.email}</p>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        <% else %>
          <div class="bg-beige border-2 border-dashed border-olive p-10 rounded-box text-center">
            <div class="bg-white rounded-full p-4 inline-block mb-4 shadow-sm text-olive">
              <.icon name="hero-ticket" class="size-12" />
            </div>

            <h3 class="font-amarante text-olive text-3xl mb-3">Ainda não tens bilhete!</h3>
            <p class="font-cormorant text-gray-600 text-lg mb-8 max-w-md mx-auto">
              Junta-te a nós na Quinta da Aldeia no dia 30 de Maio para um evento inesquecível. Garante já o teu lugar!
            </p>
            <.primary_button
              text="Comprar Bilhete Agora"
              icon="hero-arrow-right"
              iconpos={:right}
              class="font-cormorant text-lg px-8 py-3"
              color={:blue}
              link={~p"/bilhetes"}
            />
          </div>
        <% end %>
      </div>
    </.app>
    """
  end
end
