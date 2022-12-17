class Text < ApplicationRecord
  # before_create :generate_hash
  after_create :process_text
  belongs_to :bank, optional: true
  belongs_to :user, optional: true

  # Types Checker
  MPESA_PAYMENT_RECEIVED = /received .* New M-PESA balance/
  MPESA_TILL_RECEIVED = /received .* New Account balance/
  MPESA_WITHDRAW_AGENT = /Withdraw Ksh[0-9.,]+ from/
  MPESA_SEND_MONEY = /sent to .+ on/
  MPESA_PAYBILL_SEND = /sent to .+ for account/
  MPESA_BUY_GOODS = /Ksh[0-9.,]+ paid to /
  MPESA_OTHER_AIRTIME = /You bought Ksh[0-9.,]+ of airtime for (\d+) on/
  MPESA_PERSONAL_AIRTIME = /You bought Ksh[0-9.,]+ of airtime on/

  PAYMENT_RECEIVED = %r{([A-Z0-9]+) Confirmed\.[\s\n]*You have received ([A-Za-z]+)([0-9.,]+[0-9]) from[\s\n]+([0-9a-zA-Z '.]+) ([0-9a-zA-Z '.]+)[\s\n]*on (\d\d?/\d\d?/\d\d) at (\d\d?:\d\d [AP]M)[\s\n.]*New M-PESA balance is ([A-Za-z]+)([0-9.,]+[0-9])}
  WITHDRAW_AGENT = %r{([A-Z0-9]+) Confirmed\.[\s\n]*on (\d\d?/\d\d?/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]*Withdraw ([A-Za-z]+)([0-9.,]+[0-9]) from ([0-9]+) - (.*) New M-PESA balance is ([A-Za-z]+)([0-9.,]+[0-9])[\s\n.]*Transaction cost, ([A-Za-z]+)([0-9.,]+[0-9]). Amount you can transact within the day is ([0-9,.]+)\.}
  SENT = %r{([A-Z0-9]+) Confirmed\.[\s\n]*([A-Za-z]+)([0-9.,]+[0-9]) sent to ([0-9a-zA-Z '.]+) ([0-9]+) on (\d\d?/\d\d?/\d\d) at (\d\d?:\d\d [AP]M)[\s\n.]*New M-PESA balance is ([A-Za-z]+)([0-9.,]+[0-9])[\s\n.]*Transaction cost, ([A-Za-z]+)([0-9.,]+[0-9]). Amount you can transact within the day is ([0-9,.]+)\.}
  PAYBILL_SEND = %r{([A-Z0-9]+) Confirmed\.[\s\n]*([A-Za-z]+)([0-9.,]+) sent to[\s\n]*(.+)[\s\n]*for account (.+)[\s\n]*on (\d\d?/\d\d?/\d\d) at (\d\d?:\d\d [AP]M)[\s\n.]*New M-PESA balance is ([A-Za-z]+)([0-9.,]+[0-9])[\s\n.]*Transaction cost, ([A-Za-z]+)([0-9.,]+[0-9]).Amount you can transact within the day is ([0-9,.]+)\.}
  BUY_GOODS_SEND = %r{([A-Z0-9]+) Confirmed\.[\s\n]*([A-Za-z]+)([0-9.,]+) paid to (.*[0-9a-zA-Z.]+)\.[\s\n]*on (\d\d?/\d\d?/\d\d) at (\d\d?:\d\d [AP]M)[\s\n.]*New M-PESA balance is ([A-Za-z]+)([0-9.,]+[0-9])[\s\n.]*Transaction cost, ([A-Za-z]+)([0-9.,]+[0-9]). Amount you can transact within the day is ([0-9,.]+)\.}
  OTHER_AIRTIME = %r{([A-Z0-9]+) confirmed\.[\s\n]*You bought ([A-Za-z]+)([0-9.,]+[0-9]) of airtime for (\d+) on (\d\d?/\d\d?/\d\d) at (\d\d?:\d\d [AP]M)[\s\n.]*New  balance is ([A-Za-z]+)([0-9.,]+[0-9])[\s\n.]*Transaction cost, ([A-Za-z]+)([0-9.,]+[0-9]). Amount you can transact within the day is ([0-9,.]+)\.}
  PERSONAL_AIRTIME = %r{([A-Z0-9]+) confirmed\.[\s\n]*You bought ([A-Za-z]+)([0-9.,]+[0-9]) of airtime on (\d\d?/\d\d?/\d\d) at (\d\d?:\d\d [AP]M)[\s\n.]*New M-PESA balance is ([A-Za-z]+)([0-9.,]+[0-9])[\s\n.]*Transaction cost, ([A-Za-z]+)([0-9.,]+[0-9]). Amount you can transact within the day is ([0-9,.]+)\.}

  # Produce JSON from MPESA message REGEX
  def process_text
    data = nil
    if payment_received_type = message.match(MPESA_PAYMENT_RECEIVED)
      if result = message.match(PAYMENT_RECEIVED)
        data = {
          user_id: user.id,
          payment_type: 0,
          bank_id: bank.id,
          payment_id: result[1],
          party_name: result[4],
          party_account: result[5]&.strip,
          currency_code: result[2],
          amount: result[3]&.remove(','),
          transaction_type: 'Received Money',
          transaction_date: DateTime.strptime("#{result[6]} #{result[7]}", '%d/%m/%y %I:%M %p')
        }
      end
    elsif payment_received_type = message.match(MPESA_TILL_RECEIVED)
      if result = message.match(//)
        data = {
          user_id: user.id,
          payment_type: 0,
          bank_id: bank.id,
          payment_id:
        }
      end
    elsif withdraw_type = message.match(MPESA_WITHDRAW_AGENT)
      if result = message.match(WITHDRAW_AGENT)
        data = {
          user_id: user.id,
          payment_type: 1,
          bank_id: bank.id,
          payment_id: result[1],
          party_name: result[7],
          party_account: result[6]&.strip,
          currency_code: result[4],
          amount: result[5]&.remove(','),
          transaction_type: 'Withdraw',
          transaction_date: DateTime.strptime("#{result[2]} #{result[3]}", '%d/%m/%y %I:%M %p'),
          transaction_cost: result[11]&.remove(','),
          balance: result[9]&.remove(',')
        }
      end
    elsif paybill_type = message.match(MPESA_PAYBILL_SEND)
      if result = message.match(PAYBILL_SEND)
        data = {
          user_id: user.id,
          payment_type: 1,
          bank_id: bank.id,
          payment_id: result[1],
          party_name: result[4],
          party_account: result[5]&.strip,
          currency_code: result[2],
          amount: result[3]&.remove(','),
          transaction_type: 'Paybill',
          transaction_date: DateTime.strptime("#{result[6]} #{result[7]}", '%d/%m/%y %I:%M %p'),
          transaction_cost: result[11]&.remove(','),
          balance: result[9]&.remove(',')
        }
      end
    elsif sent_type = message.match(MPESA_SEND_MONEY)
      if result = message.match(SENT)
        data = {
          user_id: user.id,
          payment_type: 1,
          bank_id: bank.id,
          payment_id: result[1],
          party_name: result[4],
          party_account: result[5]&.strip,
          currency_code: result[2],
          amount: result[3]&.remove(','),
          transaction_type: 'Withdraw',
          transaction_date: DateTime.strptime("#{result[6]} #{result[7]}", '%d/%m/%y %I:%M %p'),
          transaction_cost: result[11]&.remove(','),
          balance: result[9]&.remove(',')
        }
      end
    elsif buy_goods_type = message.match(MPESA_BUY_GOODS)
      if result = message.match(BUY_GOODS_SEND)
        data = {
          user_id: user.id,
          payment_type: 1,
          bank_id: bank.id,
          payment_id: result[1],
          party_name: result[4],
          party_account: nil,
          currency_code: result[2],
          amount: result[3]&.remove(','),
          transaction_type: 'BuyGoods',
          transaction_date: DateTime.strptime("#{result[5]} #{result[6]}", '%d/%m/%y %I:%M %p'),
          transaction_cost: result[10]&.remove(','),
          balance: result[9]&.remove(','),
          transactable_amount: result[11]&.remove(',')
        }
      end
    elsif other_airtime = message.match(MPESA_OTHER_AIRTIME)
      if result = message.match(OTHER_AIRTIME)
        data = {
          user_id: user.id,
          payment_type: 1,
          bank_id: bank.id,
          payment_id: result[1],
          party_name: nil, # Get Party with that Account
          party_account: result[4],
          currency_code: result[2],
          amount: result[3]&.remove(','),
          transaction_type: 'BuyGoods',
          transaction_date: DateTime.strptime("#{result[5]} #{result[6]}", '%d/%m/%y %I:%M %p'),
          transaction_cost: result[10]&.remove(','),
          balance: result[8]&.remove(','),
          transactable_amount: result[11]&.remove(',')
        }
      end
    elsif personal_airtime = message.match(MPESA_PERSONAL_AIRTIME)
      if result = message.match(PERSONAL_AIRTIME)
        data = {
          user_id: user.id,
          payment_type: 1,
          bank_id: bank.id,
          payment_id: result[1],
          party_name: 'Safaricom Limited',
          party_account: nil,
          currency_code: result[2],
          amount: result[3]&.remove(','),
          transaction_type: 'Personal AirTime',
          transaction_date: DateTime.strptime("#{result[4]} #{result[5]}", '%d/%m/%y %I:%M %p'),
          transaction_cost: result[9]&.remove(','),
          balance: result[7]&.remove(','),
          transactable_amount: result[10]&.remove(',')
        }
      end
    end

    return if data.nil?

    update(
      data:
    )
    make_payment
  end
  # handle_asynchronously :process_text

  def make_payment
    text_data = OpenStruct.new(data)

    party = Party.find_or_initialize_by(user_id: text_data.user_id, name: text_data.party_name)

    party.save unless party.id

    Payment.create!(
      user_id: text_data.user_id,
      payment_type: text_data.payment_type,
      payment_id: text_data.payment_id,
      bank_id: text_data.bank_id,
      party_id: party.id,
      amount: text_data.amount,
      transaction_cost: text_data.transaction_cost,
      transaction_date: text_data.transaction_date
    )
  end

  private

  def generate_hash
    hash = Digest::SHA1.hexdigest(message)

    self.message_hash = hash
  end
end
