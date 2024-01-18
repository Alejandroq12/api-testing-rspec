# spec/requests/bookmarks/create?spec.rb

require 'rails_helper'

describe 'Post /bookmarks' do
  # group scenarios with authenticated user into this context block
  context 'authenticated user' do
    # create a user before the test scenarios are run
    let!(:user) { User.create(username: 'user', authentication_token: 'token') }

    # pass the user username and authentication to the header
    # 'scenario' is similar to 'it', use which you see fit
    scenario 'valid bookmark attributes' do
      # send a POST request to /bookmarks, with these parameters
      # The controller will treat them as JSON
      post '/bookmarks', params: {
        bookmark: {
          url: 'https://www.quezadajulio.com',
          title: 'the best one'
        }
      }, headers: { 'X-Username': user.username, 'X-Token': user.authentication_token }

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
      }, headers: { 'X-Username': user.username, 'X-Token': user.authentication_token }

      # response should have HTTP Status 402
      expect(response.status).to eq(422)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:url]).to eq(["can't be blank"])

      # no new bookmark record is created
      expect(Bookmark.count).to eq(0)
    end
  end

  # scenario with unauthenticated user
  context 'unauthenticated user' do
    it 'should return forbidden error' do
      post '/bookmarks', params: {
        bookmark: {
          url: 'https://rubyyagi.com',
          title: 'RubyYagi blog'
        }
      }

      # response should have HTTP Status 403 Forbidden
      expect(response.status).to eq(403)

      # response contain error message
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:message]).to eq('Invalid User')
    end
  end
end
