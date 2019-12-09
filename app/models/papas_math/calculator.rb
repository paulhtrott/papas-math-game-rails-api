module PapasMath
  class Calculator
    attr_reader :array_of_numbers
    attr_reader :calculated_values
    attr_reader :combinations_used
    attr_reader :flattened_collection
    attr_reader :operation
    attr_reader :errors


    def initialize(array_of_numbers)
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
      @flattened_collection = @array_of_numbers.flatten.compact.map { |i| i.to_i }.select { |i| i != 0 }

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
  end
end
