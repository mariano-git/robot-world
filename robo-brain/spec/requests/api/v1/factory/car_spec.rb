require 'rails_helper'

describe 'Car API' do

  path '/api/v1/factory/car' do

    post 'Creates a Car from BOM specs' do
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

    path '/api/v1/factory/car/{carSerial}' do
      put 'Robo Builder will update the Car with parts on this endpoint' do
        tags 'Car'
        consumes 'application/json'
        parameter name: :carSerial, in: :path, schema: {type: 'string'}
        parameter name: :assembly,
                  in: :body,
                  schema: {
                    type: 'object',
                    properties: {
                      stage: { type: 'string' },
                      assemblies: {
                        type: 'array',
                        items: {
                          type: 'object',
                          properties: {
                            name: { type: 'string' },
                            component_id: { type: 'integer' },
                            component_serial: { type: 'string' }
                          }
                        }
                      }
                    }
                  }
        # - in: path
        #             name: carSerial
        #             required: true
        #             description: Car serial number
        #             schema:
        #               type: string
        response '200', 'car updated' do
          let(:assembly) { { serial: 'b89810d9-661a-4311-9c05-8166036699f8', modelId: 1, status: 'INITIAL' } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:car) { { serial: 'b89810d9-661a-4311-9c05-8166036699f8', modelId: 1 } }
          run_test!
        end
      end
    end
  end
end
