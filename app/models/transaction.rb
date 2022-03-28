class Transaction < ApplicationRecord
    validates :carrier, presence: true
    
    has_many :status_history, :class_name => "StatusHistory", :foreign_key => "transaction_id", :dependent=> :destroy
    
    before_create do
        self.uuid = UUID.new.generate
    end

    state_machine :status, initial: :processing do
        after_transition :to => :authorized,    :do => :after_all_transition
        after_transition :to => :denied,        :do => :after_all_transition
        after_transition :to => :captured,      :do => :after_all_transition

        event :authorize! do
            transition :processing => :authorized, :if => :authorize
            transition :processing => :denied
        end

        event :capture! do
            transition :authorized => :captured, :if => :capture
        end

    end

    def authorize
        puts "efetuando autorizacao no cellcard"
        return true if self.amount <= 10000
        return false
    end

    def capture
        puts "confirmando a transacao no cellcard"
        return true
    end

    def after_all_transition
        puts "salvando a transacao"
        self.status_history.build(:status => self.status)
        self.save!
    end

end
