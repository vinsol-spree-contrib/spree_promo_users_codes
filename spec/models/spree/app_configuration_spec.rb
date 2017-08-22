require 'spec_helper'

describe Spree::AppConfiguration, type: :model do

  describe 'codes_per_page' do
    it { expect(Spree::Config).to have_preference(:codes_per_page) }
    it { expect(Spree::Config.preferred_codes_per_page_type).to eq(:integer) }
    it { expect(Spree::Config.preferred_codes_per_page_default).to eq(15) }
  end
end
