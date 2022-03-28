describe Transaction, type: :model do
    before(:each) do
        @valid_transaction = Transaction.new({
            carrier: "vivo",
            area_code: "11",
            cell_phone_number: "994145350",
            amount: 1000
        })
    end

    it "is not valid whithout a valid carrier" do 
        @valid_transaction.carrier = nil
        expect(@valid_transaction).to_not be_valid
    end

    it "generate an UUID when create the instance of Transaction" do
        @valid_transaction.save!
        expect(UUID.validate(@valid_transaction.uuid)).to_not be_nil
        @valid_transaction.destroy
    end

    it "will authorize transaction when amount <= 10000" do 
        @valid_transaction.authorize!
        expect(@valid_transaction.status).to eq('authorized')    
        expect(@valid_transaction.uuid).to_not be_empty
        @valid_transaction.destroy    
    end

    it "will deny transaction when amount > 10000" do 
        @valid_transaction.amount = 30000
        @valid_transaction.authorize!
        expect(@valid_transaction.status).to eq('denied')    
        expect(@valid_transaction.uuid).to_not be_empty
        @valid_transaction.destroy    
    end

    it "will capture the transaction" do
        @valid_transaction.authorize!
        @valid_transaction.capture!
        expect(@valid_transaction.status).to eq('captured')
        expect(@valid_transaction.uuid).to_not be_empty
        @valid_transaction.destroy
    end

    it "will not capture the transaction" do
        captured = @valid_transaction.capture!
        expect(captured).to be_falsey
        @valid_transaction.destroy
    end
end