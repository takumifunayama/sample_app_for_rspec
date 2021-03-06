require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }
  describe 'ログイン前' do
    before { visit login_path }
    context "フォーム入力値が正常" do
      it 'ログインが成功する' do
        fill_in "Email",	with: user.email
        fill_in "Password",	with: "password"
        click_button 'Login'
        expect(page).to have_content 'Login successful'
        expect(current_path).to eq root_path
      end
    end
    context "フォームが未入力" do
      it 'ログインが失敗する' do
        fill_in "Email",	with: nil
        fill_in "Password",	with: nil
        click_button 'Login'
        expect(page).to have_content 'Login failed'
        expect(current_path).to eq login_path
      end
    end
  end
  describe 'ログイン後' do
    context "ログアウトボタンをクリック" do
      it 'ログアウト処理が成功する' do
        login(user)
        click_link 'Logout'
        expect(page).to have_content 'Logged out'
        expect(current_path).to eq root_path
      end
    end
  end
end