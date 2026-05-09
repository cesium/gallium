defmodule GalliumWeb.UserLive.Profile do
  use GalliumWeb, :live_view

  alias Gallium.Accounts
  alias Gallium.Ticketing
  import GalliumWeb.Components.Button
  import GalliumWeb.Layouts

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_scope.user.id

    case Accounts.get_user_info_by_id(user_id) do
      {:ok, user_info} ->
        if connected?(socket) && user_info.payment && user_info.payment.status == :pending do
          Ticketing.subscribe_to_payment_order_updates(user_info.payment.order_id)
        end

        {:ok, assign(socket, :user_info, user_info)}

      {:error, _} ->
        {:ok, assign(socket, :user_info, nil)}
    end
  end

  @impl true
  def handle_info({:payment_order_updated, _payment}, socket) do
    user_id = socket.assigns.current_scope.user.id

    user_info =
      case Accounts.get_user_info_by_id(user_id) do
        {:ok, info} -> info
        {:error, _} -> socket.assigns.user_info
      end

    {:noreply, assign(socket, :user_info, user_info)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.app flash={@flash} current_scope={@current_scope}>
      <div class="grow flex flex-col">
        <div class="max-w-3xl mx-auto w-full py-12 px-4 flex flex-col gap-6">
          <div class="text-center mb-4">
            <div class="inline-flex items-center justify-center w-14 h-14 rounded-full bg-blue mb-4">
              <.icon name="hero-user" class="size-7 text-beige" />
            </div>
            <h1 class="text-5xl font-amarante text-olive uppercase mb-2">O Meu Perfil</h1>
            <p class="font-cormorant text-gray-500 text-xl">{@current_scope.user.email}</p>
          </div>

          <%= if @user_info do %>
            <div class="bg-white rounded-xl shadow-sm overflow-hidden">
              <div class={[
                "px-8 py-5 flex items-center justify-between",
                if(@user_info.payment && @user_info.payment.status == :paid,
                  do: "bg-olive",
                  else: "bg-blue"
                )
              ]}>
                <h2 class="font-amarante text-white/90 uppercase tracking-wider text-lg">
                  Bilhete
                  <span class="ml-2 text-white/60 text-sm font-glacial font-normal normal-case tracking-normal">
                    {if @user_info.is_cesium_member, do: "Sócio CeSIUM", else: "Normal"}
                  </span>
                </h2>
                <span class={[
                  "font-amarante text-xs uppercase tracking-wider px-3 py-1 rounded-full flex items-center justify-center text-center",
                  if(@user_info.payment && @user_info.payment.status == :paid,
                    do: "bg-white/20 text-white",
                    else: "bg-white/20 text-white/90"
                  )
                ]}>
                  {if @user_info.payment && @user_info.payment.status == :paid,
                    do: "Pago",
                    else: "Pagamento Pendente"}
                </span>
              </div>

              <div class="p-8">
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-y-6 gap-x-10 font-cormorant text-lg">
                  <div>
                    <p class="text-gray-400 text-xs uppercase tracking-widest mb-1">Nome</p>
                    <p class="text-gray-800 font-semibold text-xl">{@user_info.full_name}</p>
                  </div>
                  <div>
                    <p class="text-gray-400 text-xs uppercase tracking-widest mb-1">Telemóvel</p>
                    <p class="text-gray-800 text-xl">{@user_info.phone_number}</p>
                  </div>
                  <div>
                    <p class="text-gray-400 text-xs uppercase tracking-widest mb-1">
                      Número de Aluno
                    </p>
                    <p class="text-gray-800 text-xl">{@user_info.student_number}</p>
                  </div>
                  <%= if @user_info.nif do %>
                    <div>
                      <p class="text-gray-400 text-xs uppercase tracking-widest mb-1">NIF</p>
                      <p class="text-gray-800 text-xl">{@user_info.nif}</p>
                    </div>
                  <% end %>
                </div>

                <%= if @user_info.payment do %>
                  <div class="mt-8 pt-6 border-t border-gray-100">
                    <p class="text-gray-400 text-xs uppercase tracking-widest mb-3">
                      Estado do Pagamento
                    </p>
                    <div class="flex items-center gap-3">
                      <div class={[
                        "w-2.5 h-2.5 rounded-full flex-shrink-0",
                        case @user_info.payment.status do
                          :paid -> "bg-olive"
                          :pending -> "bg-amber-400 animate-pulse"
                          :failed -> "bg-red-500"
                        end
                      ]} />
                      <div class="flex flex-col sm:flex-row sm:items-center gap-2">
                        <span class="font-cormorant text-lg text-gray-700">
                          {case @user_info.payment.status do
                            :paid -> "Pagamento confirmado"
                            :pending -> "Aguarda confirmação de pagamento MBWay"
                            :failed -> "Pagamento falhado"
                          end}
                        </span>
                        <span class="font-amarante text-olive text-xl font-semibold">
                          {@user_info.payment.amount} €
                        </span>
                      </div>
                    </div>
                  </div>
                <% end %>

                <%= if @user_info.accompany do %>
                  <div class="mt-8 pt-6 border-t border-gray-100">
                    <p class="text-gray-400 text-xs uppercase tracking-widest mb-4">Acompanhante</p>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-y-6 gap-x-10 font-cormorant text-lg">
                      <div>
                        <p class="text-gray-400 text-xs uppercase tracking-widest mb-1">Nome</p>
                        <p class="text-gray-800 font-semibold text-xl">
                          {@user_info.accompany.full_name}
                        </p>
                      </div>
                      <div>
                        <p class="text-gray-400 text-xs uppercase tracking-widest mb-1">Telemóvel</p>
                        <p class="text-gray-800 text-xl">{@user_info.accompany.phone_number}</p>
                      </div>
                      <div>
                        <p class="text-gray-400 text-xs uppercase tracking-widest mb-1">Email</p>
                        <p class="text-gray-800 text-xl">{@user_info.accompany.email}</p>
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
          <% else %>
            <div class="text-center py-16">
              <div class="inline-flex items-center justify-center w-20 h-20 rounded-full bg-blue/10 mb-6">
                <.icon name="hero-ticket" class="size-10 text-blue" />
              </div>
              <h3 class="font-amarante text-blue text-3xl uppercase mb-3">Ainda não tens bilhete</h3>
              <p class="font-cormorant text-gray-500 text-xl mb-8 max-w-sm mx-auto leading-relaxed">
                Garante já o teu lugar no Jantar de Gala na Quinta da Aldeia.
              </p>
              <.primary_button
                text="Comprar Bilhete"
                icon="hero-arrow-right"
                iconpos={:right}
                class="font-cormorant text-lg px-8 py-3"
                color={:blue}
                link={~p"/bilhetes"}
              />
            </div>
          <% end %>
        </div>
      </div>
    </.app>
    """
  end
end
