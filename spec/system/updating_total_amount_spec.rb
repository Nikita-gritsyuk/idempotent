require 'rails_helper'

RSpec.describe 'updating totals', type: :system do

  let (:idempotency_key1) { '7ee60c68-ad68-484e-8257-80cee28dd3b512' }
  let (:idempotency_key2) { '75a4d06d-2ec2-4b45-9521-21c900d0cef13d' }

  before(:each) do
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
    REDIS.del [Rails.env, idempotency_key1].join(':')
    REDIS.del [Rails.env, idempotency_key2].join(':')
  end

  it 'shows total amount if no value provided' do
    visit root_path
    fill_in 'value', with: ''
    fill_in 'idempotency_key', with: ''
    click_on 'Submit'
    expect(page).to have_content({status: 'ok', total_amount: 0}.to_json)
  end

  it 'shows updated total amount if value provided' do
    visit root_path
    fill_in 'value', with: '10'
    fill_in 'idempotency_key', with: ''
    click_on 'Submit'
    expect(page).to have_content({status: 'ok', total_amount: 10}.to_json)
  end


  it 'shows updated total amount if value and idempotency_key provided 1 time' do
    visit root_path
    fill_in 'value', with: '10'
    fill_in 'idempotency_key', with: idempotency_key1
    click_on 'Submit'
    expect(page).to have_content({status: 'ok', total_amount: 10}.to_json)
  end

  it 'shows error amount if value and idempotency_key provided 2 times' do
    visit root_path
    fill_in 'value', with: '10'
    fill_in 'idempotency_key', with: idempotency_key1
    click_on 'Submit'
    expect(page).to have_content({status: 'ok', total_amount: 10}.to_json)
    click_on 'Submit'
    expect(page).to have_content({status: 'error', message: 'idempotency_key verification failed!'}.to_json)
  end

  it 'shows updated total amount if value and idempotency_key provided 2 times with a delay' do
    visit root_path
    fill_in 'value', with: '10'
    fill_in 'idempotency_key', with: idempotency_key1
    click_on 'Submit'
    expect(page).to have_content({status: 'ok', total_amount: 10}.to_json)
    REDIS.expire [Rails.env, idempotency_key1].join(':'), 0
    click_on 'Submit'
    expect(page).to have_content({status: 'ok', total_amount: 20}.to_json)
  end

  it 'shows error if value provided idempotency_key provided 2 times without delay, but show total with second key' do
    visit root_path
    fill_in 'value', with: '10'
    fill_in 'idempotency_key', with: idempotency_key1
    click_on 'Submit'
    expect(page).to have_content({status: 'ok', total_amount: 10}.to_json)
    click_on 'Submit'
    expect(page).to have_content({status: 'error', message: 'idempotency_key verification failed!'}.to_json)
    fill_in 'idempotency_key', with: idempotency_key2
    click_on 'Submit'
    expect(page).to have_content({status: 'ok', total_amount: 20}.to_json) 
  end
end
