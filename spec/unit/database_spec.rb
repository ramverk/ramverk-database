# frozen_string_literal: true

module Ramverk
  RSpec.describe Database do
    it "has a version file" do
      expect(File.expand_path("../../lib/ramverk/database/version.rb", __dir__)).to be_a_file
    end

    it "has a version number" do
      expect(Ramverk::Database::VERSION).to be_a(String)
    end
  end
end
