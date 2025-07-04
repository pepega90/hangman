defmodule HangmanWeb.Live.CustomComponent do
  use Phoenix.Component

  attr :letters, :list, default: []
  attr :pressed, :list, default: []
  attr :salah, :list, default: []

  def keyboard(assigns) do
    ~H"""
    <div class="bg-white rounded-none border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] p-6">
      <h2 class="text-2xl font-bold mb-4 text-center underline">CHOOSE A LETTER:</h2>
      
      <div id="keyboard" class="grid grid-cols-7 gap-3">
        <!-- Alphabet buttons will be generated here -->
        <button
          :for={v <- @letters}
          phx-click="key_click"
          phx-value-key={v |> String.downcase()}
          class={
            if String.downcase(v) in @pressed,
              do:
                "letter-button correct bg-white hover:bg-black hover:text-white font-bold py-2 px-4 rounded-none border-4 border-black transition-all duration-200",
              else:
                if(String.downcase(v) in @salah,
                  do:
                    "letter-button incorrect bg-white hover:bg-black hover:text-white font-bold py-2 px-4 rounded-none border-4 border-black transition-all duration-200",
                  else:
                    "letter-button bg-white hover:bg-black hover:text-white font-bold py-2 px-4 rounded-none border-4 border-black transition-all duration-200"
                )
          }
        >
          {v}
        </button>
      </div>
    </div>
    """
  end
end
