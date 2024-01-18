# spec/requests/bookmarks/create?spec.rb

require 'rails_helper'

describe 'Post /bookmarks' do
  # 'scenario' is similar to 'it', use which you see fit

  scenario 'valid bookmark attributes' do
    # send a POST request to /bookmarks, with these parameters
    # The controller will treat them as JSON
    post '/bookmarks', params: {
      bookmark: {
        url: 'https://www.quezadajulio.com',
        title: 'the best one'
      }
    }

    # response should have HTTP Status 201 Created
    expect(response.status).to eq(201)
    json = JSON.parse(response.body).deep_symbolize_keys

    # check the value of the returned response hash
    expect(json[:url]).to eq('https://www.quezadajulio.com')
    expect(json[:title]).to eq('the best one')

    # 1 new bookmark record is created
    expect(Bookmark.count).to eq(1)

    # Optionally, you can check the latest record data
    expect(Bookmark.last.title).to eq('the best one')
  end

  scenario 'invalid bookmark attributes' do
    post '/bookmarks', params: {
      bookmark: {
        url: '',
        title: 'the best one'
      }
    }

    # response should have HTTP Status 402
    expect(response.status).to eq(422)

    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq(["can't be blank"])

    # no new bookmark record is created
    expect(Bookmark.count).to eq(0)
  end
end
