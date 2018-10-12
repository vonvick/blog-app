[
  { title: 'admin', rank: 1 },
  { title: 'manager', rank: 2 },
  { title: 'user', rank: 3 }
].each do |role|
  new_role = Role.find_or_initialize_by(rank: role[:rank])
  new_role.title = role[:title]
  new_role.rank = role[:rank]
  new_role.save!
end
