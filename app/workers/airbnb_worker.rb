class AirbnbWorker
	include Sidekiq::Worker
  require 'capybara/poltergeist'

  def perform(appartment_id)
    appartment = Appartment.find_by_id(appartment_id)
    session = Capybara::Session.new(:poltergeist)
    session.visit('https://www.airbnb.com/host/homes')
    sleep rand(0.1..0.3)
    s = session.find('.earning-estimation__location-input input').set(appartment.address)
    sleep rand(0.1..0.3)
    s.send_keys :enter
    sleep rand(0.1..0.3)
    l = session.find('.earning-estimation__accommodation select').click
    sleep rand(0.1..0.3)
    l.find(:xpath, 'option[2]').select_option
    sleep rand(0.5..1.0)
    city = session.find('.space-4 .text-babu span').text
    earning = session.find('.earning-estimation__amount strong').text
    puts city
    puts earning
    converted_earning = '%.2f' % earning.split(',').join[1..-1]
    monthly_earning = converted_earning.to_f * 4
    profit = monthly_earning - appartment.rent
    appartment.update_attributes(earning: monthly_earning, profit: profit)
  end
end