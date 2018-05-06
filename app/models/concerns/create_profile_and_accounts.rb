def create_profile_and_accounts
  Profile.create!([
    {
    user_id: self.id
    }
  ])

  accounts = ([
    {
      user_id: self.id,
      label: "Credit card"
    },
    {
      user_id: self.id,
      label: "Cash"
    },
    {
      user_id: self.id,
      label: "Active investments"
    },
    {
      user_id: self.id,
      label: "Pending investments"
    },
    {
      user_id: self.id,
      label: "Distressed investments"
    },
    {
      user_id: self.id,
      label: "Outstanding loans"
    },
    {
      user_id: self.id,
      label: "Defaulted loans"
    },
    {
      user_id: self.id,
      label: "Bank account"
    },
  ])
  
  Account.create!(accounts)
end