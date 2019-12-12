module Api
  module V1
    class PapasMathGameController < ApplicationController

      # GET /api/v1/papas_math_game
      #
      # Get usable game calculation values.
      def index
        service = PapasMathGame::Create.new(5)

        if service.execute
          render json: { game: service.calculator, success: true }, status: :ok
        else
          head 400
        end
      end

      private

        # Allowed game setting params.
        def game_settings_params
          params.require(:game_settings).permit(
            :operation,
            :number_count,
            :max_range
          )
        end
    end
  end
end
