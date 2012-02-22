class PiecesController < ApplicationController
  def diff
    @problem = Problem.find(params[:problem_id])
    @piece = @problem.pieces.find(params[:piece_id])
    if @piece.result.file?
      my_result = File.read(@piece.result.path)
      pieces = @problem.pieces.where('id != :piece_id', piece_id: params[:piece_id])
      @diffs = pieces.map do |piece|
        {
          target: piece,
          result: my_result == File.read(piece.result.path)
        }
      end
    end

    respond_to do |format|
      format.html # diff.html.erb
      format.json { render json: @diffs }
    end
  end

  def index
    @problem = Problem.find(params[:problem_id])
    @pieces = @problem.pieces.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pieces }
    end
  end

  def show
    @problem = Problem.find(params[:problem_id])
    @piece = @problem.pieces.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @piece }
    end
  end

  def new
    @problem = Problem.find(params[:problem_id])
    @piece = @problem.pieces.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @piece }
    end
  end

  # GET /pieces/1/edit
  def edit
    @problem = Problem.find(params[:problem_id])
    @piece = @problem.pieces.find(params[:id])
  end

  def create
    @problem = Problem.find(params[:problem_id])
    @piece = @problem.pieces.build(params[:piece])

    respond_to do |format|
      if @piece.save
        format.html { redirect_to problem_piece_diff_path(@problem, @piece), notice: 'Piece was successfully created.' }
        format.json { render json: nil, status: :created, location: @piece }
      else
        format.html { render action: "new" }
        format.json { render json: @piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pieces/1
  # PUT /pieces/1.json
  def update
    @problem = Problem.find(params[:problem_id])
    @piece = @problem.pieces.find(params[:id])

    respond_to do |format|
      if @piece.update_attributes(params[:piece])
        format.html { redirect_to [@problem, @piece], notice: 'Piece was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pieces/1
  # DELETE /pieces/1.json
  def destroy
    @problem = Problem.find(params[:problem_id])
    @piece = @problem.pieces.find(params[:id])
    @piece.destroy

    respond_to do |format|
      format.html { redirect_to problem_pieces_url(@problem) }
      format.json { head :no_content }
    end
  end
end
