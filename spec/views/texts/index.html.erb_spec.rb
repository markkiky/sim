require 'rails_helper'

RSpec.describe "texts/index", type: :view do
  before(:each) do
    assign(:texts, [
      Text.create!(
        id: "",
        message: "Message",
        message_hash: "Message Hash",
        is_processed: false
      ),
      Text.create!(
        id: "",
        message: "Message",
        message_hash: "Message Hash",
        is_processed: false
      )
    ])
  end

  it "renders a list of texts" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Message".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Message Hash".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
