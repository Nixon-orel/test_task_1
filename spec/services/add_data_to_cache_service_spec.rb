# frozen_string_literal: true

require "rails_helper"

RSpec.describe AddDataToCacheService do
  subject(:call_method) { described_class.send(method) }

  let(:value) { Faker::Number.decimal }

  shared_examples 'calls Rails.cache.write with expected attributes' do
    before do
      allow(service).to receive(:perform).and_return(value)
    end

    it 'calls Rails.cache.write with expected attributes' do
      expect(Rails.cache).to receive(:write).with(write_name, value)
      call_method
    end
  end

  describe '.current' do
    let(:service) { WeatherApi::Base }
    let(:write_name) { 'current_temperature' }
    let(:method) { :current }

    include_examples 'calls Rails.cache.write with expected attributes'
  end

  describe '.min' do
    let(:service) { WeatherApi::Min }
    let(:write_name) { 'min_temperature' }
    let(:method) { :min }

    include_examples 'calls Rails.cache.write with expected attributes'
  end

  describe '.max' do
    let(:service) { WeatherApi::Max }
    let(:write_name) { 'max_temperature' }
    let(:method) { :max }

    include_examples 'calls Rails.cache.write with expected attributes'
  end

  describe '.avg' do
    let(:service) { WeatherApi::Avg }
    let(:write_name) { 'avg_temperature' }
    let(:method) { :avg }

    include_examples 'calls Rails.cache.write with expected attributes'
  end
end
