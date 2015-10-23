require_relative '../models/registration_response'
require_relative '../models/identifier_dashboard'

module TrafficSpy
  class Server < Sinatra::Base

    get '/' do
      erb :index
    end

    get '/sources' do
      @sources = Source.all
      erb :sources_index
    end

    get '/sources/:identifier' do |identifier|
      @identifier = identifier
      binding.pry
      Dashboard.sort_urls_by_visit(identifier)
      erb :sources
    end

    not_found do
      erb :error
    end

    post '/sources' do
      source = Processor.source_process(params)
      status source[:status]
      body   source[:body]
    end

    post '/sources/:identifier/data' do
      process = Processor.payload_process(params)
      status process[:status]
      body   process[:body]
    end

    get '/sources/:identifier/events' do |identifier|
      @identifier = identifier
      erb :events
    end

    get '/sources/:identifier/events/:eventname' do
      source = Source.find_by(:identifier)
    end

    get '/sources/:identifier/urls/:relative_path' do
      erb :sources
    end

  end
end
