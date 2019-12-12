# frozen_string_literal: true.

module PapasMathGame
  # Generate values and answers needed for Papas Math Game.
  class Create
    attr_reader :calculator
    attr_reader :operation
    attr_reader :max_range
    attr_reader :number_count
    attr_reader :random_numbers

    # Initialize a new instance of [PapasMathGame::Create].
    #
    # @param [Integer] number_count How many numbers to base calculations on.
    # @param [Integer] max_range Maximum number for random value.
    # @param [Symbol] operation Addition or Multiplication operation for calculator.
    def initialize(number_count = 5, max_range = 100, operation = :addition)
      @number_count = number_count > 15 ? 15 : number_count
      @max_range = max_range + 1
      @random_numbers = []
      @operation = operation
    end

    # Generate the numbers needed for game results.
    #
    # @returns [Boolean] true on success, otherwise false.
    def execute
      (1..number_count).each do |count|
        random_numbers << rand(1..max_range)
      end

      @calculator = PapasMath::Calculator.new(random_numbers)

      # Complete
      calculator.execute(operation: operation)
    end
  end
end
