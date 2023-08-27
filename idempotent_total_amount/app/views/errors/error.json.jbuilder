json.status 'error'
json.error do
  json.message @exception.message
  json.backtrace @exception.backtrace if Rails.env.development?
end
