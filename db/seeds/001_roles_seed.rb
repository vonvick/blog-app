[
  { title: 'super_admin', rank: 1 },
  { title: 'admin', rank: 2 },
  { title: 'moderator', rank: 3 },
  { title: 'user', rank: 4 }
].each do |role|
  new_role = Role.find_or_initialize_by(rank: role[:rank])
  new_role.title = role[:title]
  new_role.rank = role[:rank]
  new_role.save!
end
