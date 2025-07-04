defmodule Kata do
  defstruct [:kata, :hint]
end

defmodule HangmanWeb.Live.Index do
  import HangmanWeb.Live.CustomComponent
  alias Kata
  use HangmanWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="container mx-auto max-w-4xl">
      <!-- Title with brutalist shadow -->
      <h1 class="text-5xl font-bold text-center mb-8 text-black relative">
        <span class="relative z-10">HANGMAN</span>
        <span class="absolute top-2 left-2 text-black opacity-30 z-0">HANGMAN</span>
      </h1>
      
    <!-- Main game container with thick border -->
      <div class="bg-white rounded-none border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] mb-8 p-6">
        <div class="flex flex-col md:flex-row gap-8">
          <!-- Canvas area -->
          <div id="canvas_div" class="flex-1">
            <canvas
              phx-hook="HangmanHook"
              id="hangmanCanvas"
              data-step={@guess_left}
              width="250"
              height="300"
            >
            </canvas>
          </div>
          
    <!-- Game info area -->
          <div class="flex-1 border-l-4 border-black pl-6">
            <div class="mb-6">
              <h2 class="text-2xl font-bold mb-2 underline">HINT:</h2>
              
              <p :if={@selected} id="hint" class="text-lg">{@selected.hint}</p>
            </div>
            
            <div class="mb-6">
              <h2 class="text-2xl font-bold mb-2 underline">WORD:</h2>
              
              <div
                id="word-display"
                class="text-4xl font-bold tracking-widest min-h-12 flex justify-center items-center bg-yellow-100 p-4 border-4 border-black"
              >
                <%= if @guess_left == 0 do %>
                  {@selected.kata |> String.upcase()}
                <% else %>
                  <%= for k <- @selected.kata |> String.graphemes do %>
                    {if k not in @pressed, do: "_", else: k}
                  <% end %>
                <% end %>
              </div>
            </div>
            
            <div class="mb-6">
              <h2 class="text-2xl font-bold mb-2 underline">GUESSES LEFT:</h2>
              
              <p id="guesses-left" class="text-3xl font-bold">{@guess_left}</p>
            </div>
            
            <div
              id="message"
              class={
                if @benar,
                  do: "mb-6 p-4 font-bold text-center border-4 border-black bg-green-300",
                  else:
                    if(@guess_left == 0,
                      do: "mb-6 p-4 font-bold text-center border-4 border-black bg-red-300",
                      else: "mb-6 p-4 hidden font-bold text-center border-4 border-black bg-green-300"
                    )
              }
            >
              {if @benar,
                do: "CONGRATULATIONS! YOU WON!",
                else:
                  if(@guess_left == 0,
                    do: "GAME OVER! THE WORD WAS: #{@selected.kata |> String.upcase()}",
                    else: ""
                  )}
            </div>
            
            <button
              id="restart-btn"
              phx-click="restart_btn"
              class={
                if @benar or @guess_left == 0,
                  do:
                    "w-full bg-black text-white font-bold py-3 px-4 border-4 border-black hover:bg-white hover:text-black transition-all duration-200",
                  else:
                    "hidden w-full bg-black text-white font-bold py-3 px-4 border-4 border-black hover:bg-white hover:text-black transition-all duration-200"
              }
            >
              PLAY AGAIN
            </button>
          </div>
        </div>
      </div>
      
    <!-- Keyboard with brutalist style -->
      <.keyboard letters={@letters} pressed={@pressed} salah={@salah} />
      <!-- Keyboard with brutalist style -->
      <div class="text-center mt-8 text-gray-600">
        Made with ♥ by Aji Mustofa
      </div>
    </div>
    """
  end

  @daftar_kata [
    %Kata{
      kata: "javascript",
      hint: "Bahasa pemrograman yang digunakan untuk pengembangan web"
    },
    %Kata{
      kata: "hangman",
      hint: "Nama permainan ini"
    },
    %Kata{
      kata: "komputer",
      hint: "Perangkat elektronik untuk memproses data"
    },
    %Kata{
      kata: "internet",
      hint: "Jaringan global yang menghubungkan jutaan komputer"
    },
    %Kata{
      kata: "keyboard",
      hint: "Perangkat input dengan tombol untuk mengetik"
    },
    %Kata{
      kata: "developer",
      hint: "Orang yang membuat perangkat lunak"
    },
    %Kata{
      kata: "browser",
      hint: "Aplikasi untuk mengakses web"
    },
    %Kata{
      kata: "function",
      hint: "Blok kode yang dirancang untuk menjalankan tugas tertentu"
    }
  ]

  def mount(_params, _session, socket) do
    letters = ?A..?Z |> Enum.map(&<<&1>>)
    selected = Enum.random(@daftar_kata)

    {:ok,
     socket
     |> assign(
       letters: letters,
       pressed: [],
       salah: [],
       kata_list: String.graphemes(selected.kata),
       selected: selected,
       benar: false,
       guess_left: 6
     )}
  end

  def handle_event(
        "key_click",
        %{"key" => key},
        %{
          assigns: %{
            pressed: pressed,
            salah: salah,
            selected: selected,
            kata_list: kata_list,
            guess_left: guess_left
          }
        } =
          socket
      ) do
    updated_pressed = Enum.uniq([key | pressed])

    cond do
      String.contains?(selected.kata, key) ->
        benar = Enum.all?(kata_list, &(&1 in updated_pressed))
        {:noreply, socket |> assign(pressed: updated_pressed, benar: benar)}

      not String.contains?(selected.kata, key) ->
        {:noreply, socket |> assign(salah: [key | salah], guess_left: guess_left - 1)}
    end
  end

  def handle_event("restart_btn", _params, socket) do
    selected = Enum.random(@daftar_kata)

    {:noreply,
     socket
     |> assign(
       selected: selected,
       kata_list: String.graphemes(selected.kata),
       benar: false,
       guess_left: 6,
       pressed: [],
       salah: []
     )
     # <= ini trigger untuk reset state di Hooks
     |> push_event("hang", %{})}
  end
end
