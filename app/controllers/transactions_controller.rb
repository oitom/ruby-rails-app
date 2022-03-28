class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :delete, :capture]

  # GET /transactions
  def index
    @transactions = Transaction.all
    render json: @transactions.map {|tx| TransactionPresenter.new(tx).success }
  end

  # POST /transactions/:uuid/capture
  def capture
    @transaction.capture!
    presenter = TransactionPresenter.new(@transaction)
    render json: presenter.success
  end

  # GET /transactions/1
  def show
    # render json: @transaction
    presenter = TransactionPresenter.new(@transaction)
    render json: presenter.success
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.authorize!
      presenter = TransactionPresenter.new(@transaction)
      render json: presenter.success, status: :created
    else
      render json: presenter.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      # @transaction = Transaction.find(params[:id])
      @transaction = Transaction.find_by_uuid(params[:transaction_id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.permit(:carrier, :area_code, :cell_phone_number, :amount, :status)
    end
end
