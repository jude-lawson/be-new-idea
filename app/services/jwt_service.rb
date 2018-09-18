class JwtService
  def self.encode(payload)
    JWT.encode payload, ENV['secret'], 'HS256'
  end

  def self.decode(claim)
    JWT.decode claim, ENV['secret'], true, { algorithm: 'HS256' }
  end
end
