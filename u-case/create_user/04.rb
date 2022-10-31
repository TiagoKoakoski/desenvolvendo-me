require 'bundler/inline'
require 'securerandom'

gemfile do
  source 'https://rubygems.org'
  gem 'u-case'
  gem 'pry'
  gem 'awesome_print'
end

User = Struct.new(:id, :name, :email)

class NormalizeNameAndEmail < Micro::Case
  attributes :name, :email

  def call!
    Success result: {
      name: String(name).strip,
      email: String(email).strip.downcase
    }
  end
end

class CreateUser < Micro::Case
  attributes :name, :email

  def call!
    call(NormalizeNameAndEmail)
      .then(apply(:validate_attributes))
      .then(apply(:create_user))
  end

  private
  
    def validate_attributes(name:, email:, **)
      validations_errors = {}
      validations_errors[:name] = "can't be blank" if name.empty?
      validations_errors[:email] = "is invalid" if email !~ /.+@.+/
      return Success(:valid_attributes) if validations_errors.empty?

      return Failure(:invalid_attributes, result: validations_errors)
    end

    def create_user(name:, email:, **)
      user = User.new(
        SecureRandom.uuid,
        name,
        email 
      )

      Success(:user_created, result: { user: user})
    end
end

binding.pry