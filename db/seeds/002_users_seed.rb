user = {
  first_name: ENV['ADMIN_FIRST_NAME'],
  last_name: ENV['ADMIN_LAST_NAME'],
  username: ENV['ADMIN_USERNAME'],
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
  uid: ENV['ADMIN_UID']
}
role = Role.find_by(rank: 1)
new_user = User.find_or_initialize_by(email: user[:email])

new_user.first_name = user[:first_name]
new_user.last_name = user[:last_name]
new_user.username = user[:username]
new_user.password = user[:password]
new_user.email = user[:email]
new_user.uid = user[:uid]
new_user.role = role

new_user.save!
