LoanCategory.create!([
  {
    label: "vehicle purchase"
  },
  {
    label: "small business"
  },
  {
    label: "holiday"
  },
  {
    label: "unexpected expense"
  },
  {
    label: "medical bills"
  },
  {
    label: "home improvement"
  },
  {
    label: "home furnishings"
  },
  {
    label: "wedding"
  }
])

EmploymentType.create!([
  {
    label: "ongoing full-time"
  },
  {
    label: "ongoing part-time"
  },
  {
    label: "contract full-time"
  },
  {
    label: "contract part-time"
  },
  {
    label: "casual"
  },
  {
    label: "self-employed"
  }
])

emails = ([
  "maxi.merrillees@p2p.com",
  "charles.holland@p2p.com",
  "lori.dean@p2p.com",
  "darnell.howard@p2p.com",
  "terrence.mendez@p2p.com",
  "alton.greer@p2p.com",
  "erma.owens@p2p.com",
  "diana.pena@p2p.com",
  "philip.mccoy@p2p.com",
  "doug.rice@p2p.com",
  "ruth.hart@p2p.com",
  "vanessa.sanders@p2p.com",
  "latoya.pittman@p2p.com",
  "sara.wilson@p2p.com",
  "madeline.stanley@p2p.com",
  "jenny.ross@p2p.com",
  "fredrick.ellis@p2p.com",
  "aaron.dennis@p2p.com",
  "ernestine.harrington@p2p.com",
  "victoria.french@p2p.com",
  "shannon.bridges@p2p.com",
  "harvey.leonard@p2p.com",
  "cristina.hansen@p2p.com",
  "alma.brady@p2p.com",
  "cassandra.cross@p2p.com",
  "josh.holmes@p2p.com",
  "jessie.baker@p2p.com",
  "lisa.prkins@p2p.com",
  "evan.manning@p2p.com",
  "tasha.rodgers@p2p.com",
  "heather.craig@p2p.com"
  ])

cities_and_states = ([
  {
    street_address: "#{rand(60..600)} Spencer Street",
    city: "Melbourne",
    state: "Victoria",
    postcode: 3000
  },
  {
    street_address: "#{rand(60..600)} George Street",
    city: "Sydney",
    state: "New South Wales",
    postcode: 2000
  },
  {
    street_address: "#{rand(60..600)} Rundle Street",
    city: "Adelaide",
    state: "South Australia",
    postcode: 5000
  },
  {
    street_address: "#{rand(60..600)} Bell Street",
    city: "Brisbane",
    state: "Queensland",
    postcode: 4000
  },
  {
    street_address: "#{rand(60..600)} Sterling Street",
    city: "Perth",
    state: "Western Australia",
    postcode: 6000
  },
  {
    street_address: "#{rand(60..600)} Cavenagh Street",
    city: "Darwin",
    state: "Northern Territory",
    postcode: 810
  },
  {
    street_address: "#{rand(60..600)} Bathurst Street",
    city: "Hobart",
    state: "Tasmania",
    postcode: 7000
  }
])

purposes = ([
  {
    loan_category_id: 57,
    purpose_description: "I have just started a new job and I need a new car. It is a reasonably priced car and not luxurious at all. It's a used sedan with good fuel economy that will let me do my job more productively."
  },
  {
    loan_category_id: 58,
    purpose_description: "I own a small business and need some funds to renovate my interior. I have been in business for 12 years and the decoration is becoming outdated. The new interior will attract more cutomers and improve my business."
  },
  {
    loan_category_id: 59,
    purpose_description: "I haven't had a holiday in years and I really need one. I'm planning to go to travel around South America for three months. I have spent the last two years learning Spanish and am really looking forward to this trip!"
  },
  {
    loan_category_id: 60,
    purpose_description: "My car broke down and I need some funds to get it repaired. It's a 6-year-old vehicle and just came out of warranty. I need the vehicle for my work. I will take better care of my car in the future."
  },
  {
    loan_category_id: 61,
    purpose_description: "A family member came down with a serious illness recently and we need some money to pay her medical bills. It has been a hard month for us and the funds would be big big burden off our shoulders. We are good to pay it back."
  },
  {
    loan_category_id: 62,
    purpose_description: "My wife and I would like to removate our kitchen. It's a 1960s house with all the original finishings and it has become very dated. We have done all the design and planning. Now all we need is the funds to do it!"
  },
  {
    loan_category_id: 63,
    purpose_description: "Out family just moved into a new house and we need some furniture. We are planning to furnish with Ikea and only get the essentials. We have itemised everything we need and just need some short-term funding to make it happen."
  },
  {
    loan_category_id: 64,
    purpose_description: "My fiance wants a grand wedding and I need some funds to make it happen. Weddings are a once-in-a-life experience and we want it to be a day we'll never remember! We would really appreciate your suppot!"
  }
])

emails.each do |email|

  individual_city_and_state = cities_and_states.sample

  User.create!([
    {
      email: email,
      password: "password" 
    }
  ])

  weekly_income = (rand(50..500) * 1000)
  weekly_expenses = (weekly_income.to_f * (rand(50..90).to_f / 100.0))
  work_gap_months = rand (1..12)
  employment_type_id = rand(43..48)
  individual_purpose = purposes.sample

  # Create first loan application
  LoanApplication.create! ([{
    user_id: User.last.id,
    loan_amount: (rand(10..500) * 10000),
    loan_term: rand(6..60),
    purpose: individual_purpose[:purpose_description],
    status: "being assessed",
    first_name: email.split(".")[0].capitalize,
    last_name: email.split(".")[1].split("@")[0].capitalize,
    loan_category_id: individual_purpose[:loan_category_id],
    street_address: individual_city_and_state[:street_address],
    city: individual_city_and_state[:city],
    state: individual_city_and_state[:state],
    postcode: individual_city_and_state[:postcode],
    employment_type_id: employment_type_id,
    weekly_income: weekly_income,
    weekly_expenses: weekly_expenses,
    work_gap_months: work_gap_months
  }])

  # Create remaining loan application
  5.times do
    individual_purpose = purposes.sample
    LoanApplication.create! ([{
      user_id: User.last.id,
      loan_amount: (rand(10..500) * 10000),
      loan_term: rand(6..60),
      purpose: individual_purpose[:purpose_description],
      status: "being assessed",
      first_name: email.split(".")[0].capitalize,
      last_name: email.split(".")[1].split("@")[0].capitalize,
      loan_category_id: individual_purpose[:loan_category_id],
      street_address: individual_city_and_state[:street_address],
      city: individual_city_and_state[:city],
      state: individual_city_and_state[:state],
      postcode: individual_city_and_state[:postcode],
      employment_type_id: employment_type_id,
      weekly_income: weekly_income,
      weekly_expenses: weekly_expenses,
      work_gap_months: work_gap_months
    }])
  end

  # Create first transaction
  amount = (rand(5..25) * 10000)
  Transaction.create! ([
    {
      amount: amount,
      from_account_id: User.last.accounts.where(label: "Credit card").first.id,
      to_account_id: User.last.accounts.where(label: "Cash").first.id,
      from_account_balance: amount * -1,
      to_account_balance: amount,
      transaction_type: "principal",
    }
  ])

  # Create remaining transaction
  30.times do 
    amount = (rand(5..25) * 10000)

    total_transactions_from_cc_so_far = 0
    from_account_transactions = Transaction.where(from_account_id: User.last.accounts.where(label: "Credit card").first.id)
    from_account_transactions.each do |transaction|
      total_transactions_from_cc_so_far += transaction.amount
    end

    total_transactions_to_cash_so_far = 0
    to_account_transactions = Transaction.where(to_account_id: User.last.accounts.where(label: "Cash").first.id)
    to_account_transactions.each do |transaction|
      total_transactions_to_cash_so_far += transaction.amount
    end

    Transaction.create! ([
      {
        amount: amount,
        from_account_id: User.last.accounts.where(label: "Credit card").first.id,
        to_account_id: User.last.accounts.where(label: "Cash").first.id,
        from_account_balance: ((total_transactions_from_cc_so_far * -1) + (amount * -1)),
        to_account_balance: (total_transactions_to_cash_so_far + amount),
        transaction_type: "principal",
      }
    ])
  end 

end