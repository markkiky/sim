# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @payments = current_user.payments

    @months = %w[January February March April May June July August September October November December]
    year = 2022

    gon.annual_in = []
    gon.annual_out = []
    gon.drilldown = []
    gon.monthly_in = []
    gon.montly_out = []

    @months.each_with_index do |name, index|
      month = index + 1
      start_date = Date.new(year, month, 1)
      end_date = Date.new(year, month, -1)
      payments = @payments.select do |payment|
        payment.transaction_date ? payment.transaction_date.between?(start_date, end_date) : nil
      end
      monthly_in_payments = []
      monthly_out_payments = []
      payments.map do |payment|
        if payment.payment_type == 'In'
          monthly_in_payments << payment.amount
        else
          monthly_out_payments << payment.amount
        end
      end

      monthly_in = monthly_in_payments.sum
      monthy_out = monthly_out_payments.sum

      gon.annual_in << {
        name:,
        y: monthly_in.to_f,
        drilldown: "in-#{name}"
      }

      gon.annual_out << {
        name:,
        y: monthy_out.to_f,
        drilldown: "out-#{name}"
      }

      in_drilldown = []
      out_dilldown = []
      (start_date..end_date).each_with_index do |day, index|
        # puts "#{day} in #{name} index #{index}"
        today_payments = payments.select { |payment| payment.transaction_date == day }
        in_payments = []
        out_payments = []
        today_payments.map do |payment|
          if payment.payment_type == 'In'
            in_payments << payment.amount
          else
            out_payments << payment.amount
          end
        end
        in_payments = in_payments.sum
        in_drilldown << ["#{index + 1}", in_payments.to_f]
        out_payments = out_payments.sum
        out_dilldown << ["#{index + 1}", out_payments.to_f]
      end

      gon.drilldown << {
        name: "Money In #{name}",
        id: "in-#{name}",
        data: in_drilldown
      }

      gon.drilldown << {
        name: "Money Out #{name}",
        id: "out-#{name}",
        data: out_dilldown
      }
    end
  end

  def dashboard
    @payments = current_user.payments

    @months = %w[January February March April May June July August September October November December]
    year = 2022

    gon.annual_in = []
    gon.annual_out = []
    gon.drilldown = []
    gon.monthly_in = []
    gon.montly_out = []

    @months.each_with_index do |name, index|
      month = index + 1
      start_date = Date.new(year, month, 1)
      end_date = Date.new(year, month, -1)
      payments = @payments.select do |payment|
        payment.transaction_date ? payment.transaction_date.between?(start_date, end_date) : nil
      end
      monthly_in_payments = []
      monthly_out_payments = []
      payments.map do |payment|
        if payment.payment_type == 'In'
          monthly_in_payments << payment.amount
        else
          monthly_out_payments << payment.amount
        end
      end

      monthly_in = monthly_in_payments.sum
      monthy_out = monthly_out_payments.sum

      gon.annual_in << {
        name:,
        y: monthly_in.to_f,
        drilldown: "in-#{name}"
      }

      gon.annual_out << {
        name:,
        y: monthy_out.to_f,
        drilldown: "out-#{name}"
      }

      in_drilldown = []
      out_dilldown = []
      (start_date..end_date).each_with_index do |day, index|
        # puts "#{day} in #{name} index #{index}"
        today_payments = payments.select do |payment|
          payment.transaction_date ? payment.transaction_date.between?(day.to_time, day.to_time.end_of_day) : nil
        end
        in_payments = []
        out_payments = []
        today_payments.map do |payment|
          if payment.payment_type == 'In'
            in_payments << payment.amount
          else
            out_payments << payment.amount
          end
        end
        in_payments = in_payments.sum
        in_drilldown << ["#{index + 1}", in_payments.to_f]
        out_payments = out_payments.sum
        out_dilldown << ["#{index + 1}", out_payments.to_f]
      end

      gon.drilldown << {
        name: "Money In #{name}",
        id: "in-#{name}",
        data: in_drilldown
      }

      gon.drilldown << {
        name: "Money Out #{name}",
        id: "out-#{name}",
        data: out_dilldown
      }
    end
  end
end
