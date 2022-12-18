# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(email: 'mark@nashafrica.co', password: '123456')
Bank.create(name: 'MPESA')
Party.create(name: 'Mark Kariuki', user_id: 1, account_no: '0714420943')
Payment.create(payment_id: 'qwerty', user_id: 1, amount: 1000, transaction_date: DateTime.now, bank_id: 1, party_id: 1)
