require 'rails_helper'

RSpec.describe "texts/show", type: :view do
  before(:each) do
    assign(:text, Text.create!(
      id: "",
      message: "Message",
      message_hash: "Message Hash",
      is_processed: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Message/)
    expect(rendered).to match(/Message Hash/)
    expect(rendered).to match(/false/)
  end
end
