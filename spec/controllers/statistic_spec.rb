# frozen_string_literal: true

RSpec.describe Statistic do
  let(:statistic) { described_class.new }

  describe '#show_stats' do
    before { stub_const('Statistic::STORAGE_FILE', 'spec/fixtures/test_statistics.yml') }

    it 'returns statistics page' do
      expect(statistic).to receive(:statistics_page)
      statistic.show_stats
    end

    context 'when no results' do
      it 'sets String in stats' do
        statistic.show_stats
        expect(statistic.instance_variable_get(:@stats).class).to eq(Array)
      end
    end

    context 'with results' do
      it 'sets Array in stats' do
        statistic.show_stats
        expect(statistic.instance_variable_get(:@stats).class).to eq(Array)
      end
    end
  end
end
