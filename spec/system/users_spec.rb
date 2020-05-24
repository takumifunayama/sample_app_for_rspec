require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'CRUD確認' do
    describe 'ログイン前' do
      describe '新規登録' do
        context 'フォームの入力値が正常' do
          it 'ユーザーの新規作成ができる' do
            visit sign_up_path
            fill_in "Email",	with: "test@example.com"
            fill_in "Password",	with: "password"
            fill_in 'Password confirmation', with: 'password'
            click_button 'SignUp'
            expect(current_path).to eq login_path
            expect(page).to have_content 'User was successfully created.'
          end
        end
        context 'メールアドレス未入力' do
          it 'ユーザーの新規作成が失敗する' do
            visit sign_up_path
            fill_in "Email",	with: nil
            fill_in "Password",	with: "password"
            fill_in 'Password confirmation', with: 'password'
            click_button 'SignUp'
            expect(current_path).to eq users_path
            expect(page).to have_content "Email can't be blank"
          end
        end
        context '登録済メールアドレスを使用' do
          it 'ユーザーの新規作成が失敗する' do
            visit sign_up_path
            fill_in "Email",	with: user.email
            fill_in "Password",	with: "password"
            fill_in "Password confirmation", with: "password"
            click_button 'SignUp'
            expect(current_path).to eq users_path
            expect(page).to have_content "Email has already been taken"
          end
        end
        describe 'マイページ' do
          it 'ログインしていない状態' do
            visit user_path(user)
            expect(page).to have_content 'Login required'
            expect(current_path).to eq login_path
          end
        end
      end


    describe 'ログイン後' do
      before { login(user) }
        describe 'ユーザー編集' do
          context 'フォームの入力値が正常' do
            it 'ユーザー編集に成功する' do
              visit edit_user_path(user)
              fill_in "Email",	with: "test@example.com" 
              fill_in "Password",	with: "pass"
              fill_in "Password confirmation",	with: "pass"
              click_button 'Update'
              expect(current_path).to eq user_path(user)
              expect(page).to have_content 'User was successfully updated.'
            end
          end
          context 'メールアドレス未入力' do
            it 'ユーザー編集に失敗する' do
              visit edit_user_path(user)
              fill_in "Email",	with: nil 
              fill_in "Password",	with: "password"
              fill_in "Password confirmation",	with: "password"
              click_button 'Update'
              expect(current_path).to eq user_path(user)
              expect(page).to have_content "Email can't be blank"
            end
          end
          context '登録済メールアドレスを使用' do
            it 'ユーザー編集に失敗する' do
              visit edit_user_path(user)
              fill_in "Email",	with: other_user.email
              fill_in "Password",	with: "password"
              fill_in "Password confirmation", with: "password"
              click_button 'Update'
              expect(current_path).to eq user_path(user)
              expect(page).to have_content "Email has already been taken"
            end
          end
          context '他ユーザーが編集ページにアクセス' do
            it 'アクセスに失敗する' do
              visit edit_user_path(other_user)
              expect(page).to have_content 'Forbidden access.'
              expect(current_path).to eq user_path(user)
            end
          end
          describe 'マイページ' do
            context 'タスクを作成' do
              it '新規作成したタスクが表示される' do
                task = create(:task, user_id: user.id , title: 'test', status: :todo)
                visit user_path(user)
                expect(page).to have_content task.title
              end
            end
          end
        end
      end
    end
  end
end
