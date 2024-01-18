require 'rails_helper'

describe 'PUT /bookmarks' do
  # this will create a 'bookmark' method, which return the created bookmark object,
  # before each scenario is ran
  let!(:bookmark) { Bookmark.create(url: 'https://www.quezadajulio.com', title: 'the best one') }

  scenario 'valid bookmark attributes' do
    # send put request to /bookmarks/:id
    put "/bookmarks/#{bookmark.id}", params: {
      bookmark: {
        url: 'https://www.linkedin.com/in/quezadajulio/',
        title: 'Julio developer'
      }
    }

    # response should have HTTP Status 200 OK
    expect(response.status).to eq(200)

    # response should contain JSON of the updated object
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq('https://www.linkedin.com/in/quezadajulio/')
    expect(json[:title]).to eq('Julio developer')

    # The bookmark title and url should be updated
    expect(bookmark.reload.title).to eq('Julio developer')
    expect(bookmark.reload.url).to eq('https://www.linkedin.com/in/quezadajulio/')
  end

  scenario 'invalid bookmark attributes' do
    # send put request to /bookmarks/:id
    put "/bookmarks/#{bookmark.id}", params: {
      bookmark: {
        url: '',
        title: 'Julio'
      }
    }

    # response should have HTTP Status 422 Unprocessable entity
    expect(response.status).to eq(422)

    # response should contain error message
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq(["can't be blank"])

    # The bookmark title and url remain unchanged
    expect(bookmark.reload.title).to eq('the best one')
    expect(bookmark.reload.url).to eq('https://www.quezadajulio.com')
  end
end
