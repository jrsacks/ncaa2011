# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_marchMadness_session',
  :secret      => 'f40bedfd015da16f9887de1b2c69238e14f9fb912158c1c6dbd9367417d630270d2c22516c74d97d3d22b3d84319c85abc06feb05f5cb544be68d8c755a4b27b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
