require 'rails_helper'
require 'factory_girl'

feature 'answer question', %Q{
  As a user
  I want to answer another user's question
  So that I can help them solve their problem
} do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:question) { FactoryGirl.create(:question) }
  before :each do
     sign_in user
   end

   def create_answer(description)
    visit new_question_answer
    fill_in('Description', with: description)
    click_button('Create Answer')
   end

  scenario "visitor clicks button to post answer from the question detail page" do
    visit question_answers_path
    click_link('Post an Answer')

    expect(page).to have_button('Create Answer')
  end

  scenario "visitor provides valid answer" do
    description = "Valid test answer for information and stuff hooray yay yeah whoo tweet tweet tweet"
    create_answer(description)

    expect(page).to have_content('Answer added')
    expect(page).to have_content(answer.description)
  end

  scenario "visitor receives errors for invalid input" do
    description = "Really way too short"
    create_answer(description)
    expect(page).to have_content("Invalid entry")
  end
end


def sign_in(user)
  visit new_user_session_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_on "Log in"
end