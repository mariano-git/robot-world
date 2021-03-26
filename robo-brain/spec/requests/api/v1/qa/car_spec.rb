describe 'Inventory API' do

  path '/api/v1/qa/car/{carSerial}' do
    get 'RoboGuard will check car computer for defects and get the results' do
      tags 'QA'
      produces 'application/json'

      parameter name: :carSerial, in: :path, type: :string, required: true
      #parameter name: :status, in: :query, type: :string, required: false
      #parameter name: :stage, in: :query, type: :string, required: false

      response '200', 'elements found' do
        schema type: :object,
               properties: {
                 id: { type: 'integer' },
                 serial: { type: 'string' },
                 modelName: { type: 'string' },
                 defect: {
                   type: 'object',
                   properties: {
                     computerName: { type: 'string' },
                     diagnostic: { type: 'string', enum: ['ok', 'fail'] },
                     failedComponent: {
                       type: 'object',
                       properties: {
                         name: { type: 'string' },
                         type: { type: 'string' },
                         assemblyId:{ type: 'integer' },
                         serial:{ type: 'string' }
                       }
                     }
                   }
                 }
               }

        let(:defects) {
          [{
             id: 20,
             serial: '16392f2f-a70e-4beb-83fc-05d6063f17c1',
             modelid: 11,
             modelname: 'Súper Perrari',
             warehousename: 'Factory Warehouse',
             warehouselocation: 'FACTORY',
             status: 'READY_TO_INSPECT',
             stage: 'BUILD_END'
           }, {
             id: 19,
             serial: '712ac626-0a91-4162-aa53-bbd4ae6d1583',
             modelid: 10,
             modelname: 'Súper Chatarra Special',
             warehousename: 'Factory Warehouse',
             warehouselocation: 'FACTORY',
             status: 'READY_TO_INSPECT',
             stage: 'BUILD_END'
           }]
        }
        run_test!
      end
    end
  end
end
