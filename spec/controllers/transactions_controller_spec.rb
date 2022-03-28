describe TransactionsController, type: :controller do

    before(:each) do
        @valid_transaction = Transaction.new({
            carrier: "vivo",
            area_code: "11",
            cell_phone_number: "994145350",
            amount: 1000
        })
    end
    
    it "returns correct app using uuid as unique identifier" do 
        @valid_transaction.save!
        get '/transactions/:transaction_id', transaction_id: @valid_transaction.uuid
        expect(response.status).to eq 200
        pp response.body
        @valid_transaction.delete
    end

    it "returns uuid value in the id attribute" do
        @valid_transaction.save!

        get '/transactions/:transaction_id', transaction_id: @valid_transaction.uuid
        expect(response.status).to eq 200

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq @valid_transaction.uuid

        @valid_transaction.delete
    end

    it "allow to send the transaction fields directly in the root node of json" do
        post '/transactions', {
            :carrier => "vivo",
            :area_code => "11",
            :cell_phone_number => "9951556350",
            :amount => 1000
        }

        expect(response.status).to eq 201
        pp response.body

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to_not be_empty
    end

    it "capture the transaction when status = authorized" do
        @valid_transaction.authorize!

        post '/transactions/:transaction_id/capture', :transaction_id => @valid_transaction.uuid
        expect(response.status).to eq 200

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['status']).to eq('captured')
    end

    it "will create a status_history when status change to authorized" do
        @valid_transaction.authorize!
        expect(@valid_transaction.status_history.first.status).to eq('authorized')
        @valid_transaction.destroy
    end

    it "will create a status_history when status change to denied" do
        @valid_transaction.amount = 30000
        @valid_transaction.authorize!
        expect(@valid_transaction.status_history.first.status).to eq('denied')
        @valid_transaction.destroy
    end

    it "will create a status_history when status change to captured" do
        @valid_transaction.authorize!
        @valid_transaction.capture!
        expect(@valid_transaction.status_history.first.status).to eq('authorized')
        expect(@valid_transaction.status_history.last.status).to eq('captured')
        @valid_transaction.destroy
    end

    # it "will create a status_history when status change to refunded" do
    #     @valid_transaction.authorize!
    #     @valid_transaction.refund!
    #     expect(@valid_transaction.status_history.first.status).to eq('authorized')
    #     expect(@valid_transaction.status_history.first.status).to eq('refunded')
    #     @valid_transaction.destroy
    # end
    

end