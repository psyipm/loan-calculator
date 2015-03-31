require_relative '../config/boot.rb'
require "spec_helper"

describe 'Loan Calculator app', :type => :feature do
  it "should load the home page" do
    visit '/'
    expect(page).to have_content 'Кредитный калькулятор'
  end

  it "should not submit empty form" do
    visit '/'
    click_button "submit-btn"

    expect(page).to have_content 'Кредитный калькулятор'
  end

  it "should not submit partial form" do
    visit '/'
    fill_in 'amount', :with => '100'
    click_button "submit-btn"

    expect(page).to have_content 'Кредитный калькулятор'
  end

  it "should not allow to submit incorrect data" do
    visit '/'
    fill_in 'rate', :with => 'test'
    fill_in 'amount', :with => 'test'
    fill_in 'periods', :with => 'test'
    click_button "submit-btn"

    expect(page).to have_content 'Кредитный калькулятор'
  end

  it "should correctly calculate short term differential payments" do
    visit '/'
    fill_in 'rate', :with => '20'
    fill_in 'amount', :with => '1000'
    choose 'method', :option => 'true'
    fill_in 'periods', :with => '3'
    click_button "submit-btn"

    expect(page).to have_content 'Расчет дифференцированного платежа'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tbody/tr[2]/td[3]').text).to have_content '11.11'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tfoot/tr/td[3]').text).to have_content '33.33'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tfoot/tr/td[5]').text).to have_content '1033.33'
  end

  it "should correctly calculate short term annuity payments" do
    visit '/'
    fill_in 'rate', :with => '20'
    fill_in 'amount', :with => '1000'
    choose 'method', :option => 'false'
    fill_in 'periods', :with => '3'
    click_button "submit-btn"

    expect(page).to have_content 'Расчет аннуитетного платежа'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tbody/tr[3]/td[2]').text).to have_content '338.86'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tfoot/tr/td[3]').text).to have_content '33.52'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tfoot/tr/td[5]').text).to have_content '1033.52'
  end

  it "should correctly calculate long term differential payments" do
    visit '/'
    fill_in 'rate', :with => '20'
    fill_in 'amount', :with => '1000'
    choose 'method', :option => 'true'
    fill_in 'periods', :with => '24'
    click_button "submit-btn"

    expect(page).to have_content 'Расчет дифференцированного платежа'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tbody/tr[10]/td[3]').text).to have_content '10.42'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tfoot/tr/td[3]').text).to have_content '208.33'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tfoot/tr/td[5]').text).to have_content '1208.33'
  end

  it "should correctly calculate long term annuity payments" do
    visit '/'
    fill_in 'rate', :with => '20'
    fill_in 'amount', :with => '1000'
    choose 'method', :option => 'false'
    fill_in 'periods', :with => '24'
    click_button "submit-btn"

    expect(page).to have_content 'Расчет аннуитетного платежа'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tbody/tr[4]/td[3]').text).to have_content '14.93'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tfoot/tr/td[3]').text).to have_content '221.5'
    expect(find(:xpath, '/html/body/div/section/div[2]/table/tfoot/tr/td[5]').text).to have_content '1221.5'
  end
end