class LoanCalcApp < Sinatra::Base
  helpers Sinatra::Param

  get '/' do
    slim :index
  end

  post '/calculate' do
    rate, amount, @method, periods = loan_params

    lc = LoanCalculator.new amount, periods, rate

    if @method
      @schedule, @totals = lc.differential_payment
    else
      @schedule, @totals = lc.annuity_payment
    end

    slim :calculate
  end

  private
    def loan_params
      param :rate, Float, required: true
      param :amount, Float, required: true
      param :method, Boolean, required: true
      param :periods, Integer, required: true

      return params[:rate], params[:amount], params[:method], params[:periods]
    end
end