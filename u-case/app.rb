require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'u-case'
  gem 'pry'
  gem 'awesome_print'
end

class Sum < Micro::Case
  attributes :a, :b

  def call!
    if a.is_a?(Numeric) && b.is_a?(Numeric)
      Success(result: { number: a + b })
    else
      Failure(:attributes_must_be_numerics)
    end
  end
end

class Add3 < Micro::Case
  attributes :number

  def call!
    if number.is_a?(Numeric)
      Success(result: { number: number + 3 })
    else
      Failure(:number_must_be_numerics)
    end
  end
end

SumAndAdd3 = Micro::Cases.flow([Sum, Add3])

result = Sum.call(a: 1, b: 2)


binding.pry
