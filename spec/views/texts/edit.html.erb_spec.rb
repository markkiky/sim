require 'rails_helper'

RSpec.describe "texts/edit", type: :view do
  let(:text) {
    Text.create!(
      id: "",
      message: "MyString",
      message_hash: "MyString",
      is_processed: false
    )
  }

  before(:each) do
    assign(:text, text)
  end

  it "renders the edit text form" do
    render

    assert_select "form[action=?][method=?]", text_path(text), "post" do

      assert_select "input[name=?]", "text[id]"

      assert_select "input[name=?]", "text[message]"

      assert_select "input[name=?]", "text[message_hash]"

      assert_select "input[name=?]", "text[is_processed]"
    end
  end
end
