# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kizuna2_session',
  :secret      => '7d2a3538b06d186b27042a73342c32b2c4d5f9771318e08579e8ab7938ef7713914444ac7be3bfca8dc5a3efd58e84fec38675a58c9c8c8c18cc855de3d16655'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
