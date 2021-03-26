require 'swagger_helper'

describe 'Boms API' do

  path '/api/v1/factory/bom' do

    get 'Retrieves a bom' do
      tags 'Bom'
      produces 'application/json'
      #parameter name: :id, :in => :path, :type => :string

      response '200', 'name found' do
        schema type: :object,
               properties: {
                 id: { type: :integer, },
                 name: { type: :string },
                 photo_url: { type: :string },
                 status: { type: :string }
               },
               required: ['id', 'name', 'status']

        let(:id) { Bom.create(name: 'foo', status: 'bar', photo_url: 'http://example.com/avatar.jpg').id }
        run_test!
      end

      response '404', 'bom not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/factory/car' do

    post 'Creates a Car' do
      tags 'Car'
      consumes 'application/json'
      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          serial: { type: 'string' },
          modelId: { type: 'integer', format: 'int32' },
          status: { type: 'string' },
          stage: { type: 'string' }
        },
        required: ['serial', 'modelId', 'status', 'stage']
      }

      response '201', 'car created' do
        let(:car) { { serial: 'b89810d9-661a-4311-9c05-8166036699f8', modelId: 1, status: 'INITIAL' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:car) { { serial: 'b89810d9-661a-4311-9c05-8166036699f8', modelId: 1 } }
        run_test!
      end
    end
  end
end
