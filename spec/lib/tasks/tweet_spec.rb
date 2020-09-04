# frozen_string_literal: true

describe 'tweet:post' do
  include_context 'rake'
  include_context 'tweet'

  it 'posts tweet with media' do
    expect_any_instance_of(Twitter::REST::Client)
      .to receive(:update_with_media).with(/102,800 USD invested/, anything)
    expect_any_instance_of(Discordrb::Bot)
      .to receive(:send_message).with(String, @tweet_url)
    task.invoke
  end
end

describe 'tweet:post_managers' do
  include_context 'rake'
  include_context 'tweet'

  it 'posts tweet with media' do
    expect_any_instance_of(Twitter::REST::Client)
      .to receive(:update_with_media)
      .with(/\$45,649 total AUM in programs/, anything)
    expect_any_instance_of(Discordrb::Bot)
      .to receive(:send_message).with(String, @tweet_url)
    task.invoke
  end
end

