# frozen_string_literal: true

class ShortLivedAuthTokenGenerator
  EXPIRE_AFTER = 5 # seconds

  def initialize
    config = Aws::RDS::Client.new.config

    @signer = Aws::Sigv4::Signer.new(
      service: "rds-db",
      region: config.region,
      credentials_provider: config.credentials
    )
  end

  def call(host:, port:, user:)
    @signer.presign_url(
      http_method: "GET",
      url: "https://#{host}:#{port}/?Action=connect&DBUser=#{user}",
      body: "",
      expires_in: EXPIRE_AFTER
    ).to_s.delete_prefix("https://")
  end
end
