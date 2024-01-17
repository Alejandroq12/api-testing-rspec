require 'rails_helper'

RSpec.describe BookmarksController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/bookmarks').to route_to('bookmarks#index')
    end

    it 'routes to #show' do
      expect(get: '/bookmarks/1').to route_to('bookmarks#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/bookmarks').to route_to('bookmarks#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/bookmarks/1').to route_to('bookmarks#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/bookmarks/1').to route_to('bookmarks#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/bookmarks/1').to route_to('bookmarks#destroy', id: '1')
    end
  end
end
