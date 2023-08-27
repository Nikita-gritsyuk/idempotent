# This code configures the Rack::Cors middleware to allow cross-origin resource sharing (CORS)
# for the specified origins and resources.

# Insert the Rack::Cors middleware before all other middleware
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow requests from the specified origins or default to 'http://localhost:3001'
    origins ENV['CORS_ORIGINS'] || 'http://localhost:3001'
    # Allow any resource to be accessed with any headers and methods
    resource '*', headers: :any, methods: :any
  end
end
