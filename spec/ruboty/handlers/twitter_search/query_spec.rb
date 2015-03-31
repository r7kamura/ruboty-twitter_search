RSpec.describe Ruboty::Handlers::TwitterSearch::Query do
  let(:query) do
    described_class.new(original_string)
  end

  describe "#minimum_favorite_count" do
    subject do
      query.minimum_favorite_count
    end

    context "with favorite count filter" do
      let(:original_string) do
        "a fav:10"
      end

      it { is_expected.to eq 10 }
    end

    context "without favorite count filter" do
      let(:original_string) do
        "a"
      end

      it { is_expected.to eq 0 }
    end
  end

  describe "#minimum_retweet_count" do
    subject do
      query.minimum_retweet_count
    end

    context "with retweet count filter" do
      let(:original_string) do
        "a retweet:10"
      end

      it { is_expected.to eq 10 }
    end

    context "without retweet count filter" do
      let(:original_string) do
        "a"
      end

      it { is_expected.to eq 0 }
    end
  end

  describe "#query_string" do
    subject do
      query.query_string
    end

    context "with simple string" do
      let(:original_string) do
        "a"
      end

      it { is_expected.to eq "a" }
    end

    context "with empty string" do
      let(:original_string) do
        ""
      end

      it { is_expected.to eq "" }
    end

    context "with space-separated string" do
      let(:original_string) do
        "a b"
      end

      it { is_expected.to eq "a b" }
    end

    context "with spaces-separated string" do
      let(:original_string) do
        "a  b"
      end

      it { is_expected.to eq "a b" }
    end

    context "with tab-separated string" do
      let(:original_string) do
        "a\tb"
      end

      it { is_expected.to eq "a b" }
    end

    context "with favorite count filter" do
      let(:original_string) do
        "a fav:10"
      end

      it { is_expected.to eq "a" }
    end

    context "with invalid favorite count filter" do
      let(:original_string) do
        "a fav:b"
      end

      it { is_expected.to eq "a fav:b" }
    end

    context "with retweet count filter" do
      let(:original_string) do
        "a retweet:10"
      end

      it { is_expected.to eq "a" }
    end

    context "with invalid retweet count filter" do
      let(:original_string) do
        "a retweet:b"
      end

      it { is_expected.to eq "a retweet:b" }
    end

    context "with result type filter" do
      let(:original_string) do
        "a result_type:popular"
      end

      it { is_expected.to eq "a" }
    end

    context "with invalid retweet count filter" do
      let(:original_string) do
        "a result_type:b-c"
      end

      it { is_expected.to eq "a result_type:b-c" }
    end
  end

  describe "#result_type" do
    subject do
      query.result_type
    end

    context "with result type filter" do
      let(:original_string) do
        "a result_type:popular"
      end

      it { is_expected.to eq "popular" }
    end

    context "without result type filter" do
      let(:original_string) do
        "a"
      end

      it { is_expected.to be_nil }
    end
  end
end
