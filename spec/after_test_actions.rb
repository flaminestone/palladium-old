require 'palladium_api'
class AfterTests
  def initialize(palladium, example)
    @palladium = palladium
    @example = example
    @description = @example.metadata[:description]
    @comment = nil
  end

  def set_result
    result = get_result
    @palladium.add_result(@description, "#{result}", @comment)
  end

  def get_result
    case
      when @example.exception.nil?
        @comment = ''
        :Passed
      when errors_is_contains?(%w(got: expected: return))
        @comment = "\n#{@example.exception.to_s.gsub('got:', "got:\n").gsub('expected:', "expected:\n")}\nIn line:\n#{@example.exception}"
        :Failed
    end
  end

  def errors_is_contains?(errors)
    result = false
    errors.each do |current_error|
      result = true if @example.exception.to_s.include?(current_error)
    end
    result
  end
end