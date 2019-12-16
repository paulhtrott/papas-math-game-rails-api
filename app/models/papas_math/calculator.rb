# frozen_string_literal: true.

module PapasMath
  class Calculator
    attr_reader :array_of_numbers,
                :calculated_values,
                :combinations_used,
                :flattened_collection,
                :numbers_to_choose_from,
                :operation,
                :user_message,
                :errors


    def initialize(array_of_numbers)
      @numbers_to_choose_from = []
      @array_of_numbers = array_of_numbers
      @flattened_collection = []
      @combinations_used = []
      @calculated_values = []
    end

    def execute(operation: :addition, remove_duplicates: false, sort: true)
      unless array_of_numbers.is_a?(Array)
        @errors = ['Calculator only works with arrays']

        return false
      end

      # Flatten array, remove nil values, convert values in array to integer (converts strings to 0), remove 0 values.
      @flattened_collection = @array_of_numbers.flatten.compact.map { |i| i.to_i }.sort.select { |i| i != 0 }

      if @flattened_collection.blank?
        @errors = ['Calculator does not have any values to work on']

        return false
      end

      # Set the operation type.
      @operation = operation.to_sym

      # Calculate the values.
      calculate([], 0, 0)

      @calculated_values.uniq! if remove_duplicates

      @calculated_values.sort! if sort

      gather_numbers_to_choose_from

      # Complete
      true
    end

    private

      def calculate(current, index, accumulation)
        case operation
        when :addition
          (index...flattened_collection.length).each do |i|
            calculate(current + [flattened_collection[i]], i + 1, accumulation + flattened_collection[i])
          end
        when :multiplication
          (index...flattened_collection.length).each do |i|
            calculate(current + [flattened_collection[i]], i + 1, (accumulation.zero? ? 1 : accumulation) * flattened_collection[i])
          end
        else
          @operation = :addition

          (index...flattened_collection.length).each do |i|
            calculate(current + [flattened_collection[i]], i + 1, accumulation + flattened_collection[i])
          end
        end

       combinations_used.push("#{current.join(selected_operation)}=#{accumulation}") if current.size > 1

       calculated_values.push(accumulation) if current.size > 1
      end

      def selected_operation
        selected_operation ||= operations[operation]
      end

      def operations
        {
          addition: '+',
          multiplication: '*'
        }
      end

      def gather_numbers_to_choose_from
        numbers = flattened_collection.sort
        lowest = numbers.first - rand(1..10)
        lowest_number = lowest < 1 ? 1 : lowest

        highest_number  = numbers.last + rand(1..10)

        @user_message = "Figure out which #{numbers.size} numbers were used to get the following answers. Options are from #{lowest_number} to #{highest_number}."

        @numbers_to_choose_from = (lowest_number..highest_number).to_a
      end
  end
end
