require 'rails_helper'

RSpec.describe "texts/new", type: :view do
  before(:each) do
    assign(:text, Text.new(
      id: "",
      message: "MyString",
      message_hash: "MyString",
      is_processed: false
    ))
  end

  it "renders new text form" do
    render

    assert_select "form[action=?][method=?]", texts_path, "post" do

      assert_select "input[name=?]", "text[id]"

      assert_select "input[name=?]", "text[message]"

      assert_select "input[name=?]", "text[message_hash]"

      assert_select "input[name=?]", "text[is_processed]"
    end
  end
end
