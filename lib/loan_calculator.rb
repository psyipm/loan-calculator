class LoanCalculator
  attr_reader :amount, :periods, :interest_rate, :schedule

  def initialize(amount, periods, interest_rate)
    @amount = amount.to_f
    @periods = periods.to_i
    @interest_rate = interest_rate/100.to_f

    @schedule = []
    @total_interest = 0
    @initial_amount = amount
    @total_payments = 0
  end

  def get_totals
    return {
      total_interest: @total_interest.round(2), 
      initial_amount: @initial_amount, 
      total_payments: @total_payments.round(2)
    }
  end
  
  def differential_payment
    main_debt = @amount/@periods

    @periods.times do |n|
      interest = (@amount)*(@interest_rate/@periods)
      payment = main_debt + interest

      make_schedule n, @amount, interest, main_debt, payment

      @amount -= main_debt
    end
    return @schedule, get_totals
  end

  def annuity_payment
    # i - interest per period
    i = @interest_rate/@periods
    annuity_factor = (i * (1 + i) ** @periods) / ((1 + i) ** @periods -1)
    payment = annuity_factor * @amount

    @periods.times do |n|
      interest = (@amount)*(@interest_rate/@periods)
      main_debt = payment - interest

      make_schedule n, @amount, interest, main_debt, payment

      @amount -= main_debt
    end
    return @schedule, get_totals
  end

  private
    def make_schedule(period, loan_debt, accrued, main_debt, payment)
      @schedule << { 
        period: period + 1, 
        loan_debt: loan_debt.round(2),
        accrued_interest: accrued.round(2),
        main_debt: main_debt.round(2),
        total_payment: payment.round(2)
      }
      @total_interest += accrued
      @total_payments += payment
    end
end