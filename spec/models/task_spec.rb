require 'rails_helper'

RSpec.describe 'バリデーション確認', type: :model do
  describe 'validation' do
    let(:task){ FactoryBot.create(:task, title: 'title1', status: 'todo')}

    it 'バリデーションが通っていること' do
      expect(task).to  be_valid
    end

    it 'タイトルが入力されていること' do
      task.title = nil
      expect(task).to_not be_valid
      expect(task.errors.messages[:title]).to be_present
    end

    it 'ステータスが入力されていること' do
      task.status = nil
      expect(task).to_not be_valid
      expect(task.errors.messages[:status]).to be_present
    end
  end
end
