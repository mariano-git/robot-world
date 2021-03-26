describe 'Pos API' do

  path '/api/v1/pos' do

    post 'Robo Buyer will place their whishes here by model id and operation' do
      tags 'Pos'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          type: { type: 'string', enum: ['PURCHASE', 'REQUISITION', 'REVENUE'] },
          modelId: { type: 'integer' },
          buyer: { type: 'string' },
        },
        required: ['type', 'modelId', 'buyer']
      }
      response '201', 'element created' do
        schema type: :object,
               properties: {
                 carId: { type: 'integer' },
                 carSerial: { type: 'string' },
                 modelId: { type: 'integer' },
                 modelName: { type: 'string' },
                 status: { type: 'string', enum: ['SOLD', 'FAIL', 'RESERVED'] },
                 purchaseId: { type: 'integer' },
                 requisitionId: { type: 'integer' }
               }
        let(:pos) { {
          carId: 20,
          carSerial: '16392f2f-a70e-4beb-83fc-05d6063f17c1',
          modelId: 11,
          modelName: 'Súper Perrari',
          status: 'SOlD',
          purchaseId: 25,
          requisitionId: 73
        } }
        run_test!
      end
      response '404', 'not in stock' do
        schema type: :object,
               properties: {
                 modelId: { type: 'integer' },
                 status: { type: 'string', enum: ['SOLD', 'FAIL', 'RESERVED'] },
                 requisitionId: { type: 'integer' }
               }
        let(:pos) { {
          modelId: 11,
          modelName: 'Súper Perrari',
          status: 'FAIL',
          requisitionId: 73
        } }
        run_test!
      end
    end
  end
end

