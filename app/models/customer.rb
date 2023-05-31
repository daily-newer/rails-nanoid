class Customer < ApplicationRecord
  include PublicIdGenerator

  self.public_id_prefix = "cus"

  def to_param
    public_id
  end
end
