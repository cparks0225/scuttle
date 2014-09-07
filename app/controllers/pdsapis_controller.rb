require 'httpclient'
require 'json'

class PdsSerializer
  include ActiveModel::Serializers::JSON

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def attributes
    instance_values
  end
end

# class PdsModel < PdsSerializer
#   attr_accessor :name, :description, :notes, :paramType, :defaultValue, :allowableValues, :required, :allowMultiple, :paramAccess, :internalDescription, :wrapperMenu, :dataType
# end

# class PdsParameter < PdsSerializer
#   attr_accessor :name, :description, :notes, :paramType, :defaultValue, :allowableValues, :required, :allowMultiple, :paramAccess, :internalDescription, :wrapperMenu, :dataType
# end

# class PdsOperation < PdsSerializer
#   attr_accessor :httpMethod, :summary, :notes, :deprecated, :responseClass, :nickname #, :parameters
# end

# class PdsApi < PdsSerializer
#   attr_accessor :swaggerVersion, :path, :description #, :operations
# end

class PdsApis < PdsSerializer
  attr_accessor :swaggerVersion, :basePath, :resourcePath, :apis, :models
end

class PdsService < PdsSerializer
  attr_accessor :path, :description, :apis, :models
end

def FetchApi(api)
  proxy = ENV['HTTP_PROXY']
  clnt = HTTPClient.new(proxy)
  clnt.set_cookie_store("cookie.dat")

  api_url_base = "http://pds-dev.debesys.net/api/1/api-docs/1/"
  api_url = api_url_base + api.path
  api_result = clnt.get(api_url)
  raw_api_json = JSON.parse(api_result.body)

  api_obj = PdsApis.new
  api_obj.from_json(JSON.generate(raw_api_json))

  api.apis = api_obj.apis
  api.models = api_obj.models
end

def StoreApis(apis)
  File.open('stored_apis.yaml', 'w') {|f| f.write(YAML.dump(apis)) }
end

def LoadApis()
  apis = YAML.load(File.read('stored_apis.yaml'))
  return apis
end

class PdsapisController < ApplicationController
  respond_to :json

  def index
    if File.exists?('stored_apis.yaml')
      @pds_apis = LoadApis()
    else
      proxy = ENV['HTTP_PROXY']
      clnt = HTTPClient.new(proxy)
      clnt.set_cookie_store("cookie.dat")

      service_url = "http://pds-dev.debesys.net/api/1/api-docs"
      result = clnt.get(service_url)
      raw_json = JSON.parse(result.body)["apis"]
      
      api_url_base = "http://pds-dev.debesys.net/api/1/api-docs/1/"

      @pds_apis = []
      for service in raw_json
        Rails.logger.debug( service )
        new_pds = PdsService.new
        new_pds.from_json(JSON.generate(service))

        new_pds.path = new_pds.path.split("\/")[4]
        # new_pds.apis = FetchApi(new_pds.path)
        FetchApi(new_pds)
        Rails.logger.debug( new_pds )
        @pds_apis.push(new_pds)
      end
      StoreApis(@pds_apis)
    end
  end

  def show

    @pds_api = api_obj
  end
end
