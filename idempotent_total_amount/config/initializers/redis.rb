REDIS = ConnectionPool.new(size: 20) do
  Redis.new
end
