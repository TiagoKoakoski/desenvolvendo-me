require 'bundler/inline'
require 'securerandom'

gemfile do
  source 'https://rubygems.org'
  gem 'u-case'
  gem 'pry'
  gem 'awesome_print'
end



User = Struct.new(:id, :name, :email)

class CreateUser < Micro::Case
  attribute :name, default: -> value { String(value).strip }
  attribute :email, default: -> value { String(value).strip.downcase }

  def call!
    validations_errors = {}
    validations_errors[:name] = "can't be blank" if name.empty?
    validations_errors[:email] = "is invalid" if email !~ /.+@.+/

    if !validations_errors.empty?
      return Failure(:invalid_attributes, result: validations_errors)
    end

    user = User.new(SecureRandom.uuid, name, email)

    Success(:user_created, result: { user: user})
  end
end

binding.pry