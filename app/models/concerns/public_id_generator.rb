# frozen_string_literal: true

module PublicIdGenerator
  extend ActiveSupport::Concern

  included do
    class_attribute :public_id_prefix
    self.public_id_prefix = nil

    before_create :set_public_id
  end

  PUBLIC_ID_ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  PUBLIC_ID_LENGTH = 14
  MAX_RETRY = 1000

  class_methods do
    def generate_nanoid(alphabet: PUBLIC_ID_ALPHABET, size: PUBLIC_ID_LENGTH, prefix: nil)
      random_id = Nanoid.generate(size:, alphabet:)
      prefix.present? ? "#{prefix}_#{random_id}" : random_id
    end
  end

  def set_public_id
    return if public_id.present?

    MAX_RETRY.times do
      self.public_id = generate_public_id
      return unless self.class.exists?(public_id:)
    end
    raise "Failed to generate a unique public id after #{MAX_RETRY} attempts"
  end

  def generate_public_id
    self.class.generate_nanoid(prefix: self.class.public_id_prefix)
  end
end
