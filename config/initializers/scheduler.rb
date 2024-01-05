require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1h' do
  AddDataToCacheService.max
end

scheduler.every '1h' do
  AddDataToCacheService.min
end

scheduler.every '1h' do
  AddDataToCacheService.avg
end

scheduler.every '5m' do
  AddDataToCacheService.current
end

scheduler.every '24h' do
  AddWeatherHistoryService.perform
end