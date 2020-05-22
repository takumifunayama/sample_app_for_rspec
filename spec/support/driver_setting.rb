RSpec.configure do |config|
  config.before(:each, type: :system) do

    # Spec実行時、ブラウザOFF
    driven_by(:selenium_chrome_headless)
  end
end