class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :show, :index]
  before_action :is_matching_login_users_post, only: [:edit, :update]
  
  def index
    @book = Book.new
    @books = Book.all
    @user = current_user
  end
  
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      render :index
    end
  end

  def show
    @book = Book.find(params[:id])
    @books = Book.all
    @new_book = Book.new
    @user = @book.user
  end

  def edit
    @book =Book.find(params[:id])
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to @book
    else
      render :edit
    end
  end
  
  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end
  
  private
  
  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def is_matching_login_users_post
    post = Book.find(params[:id])
    unless post.user_id == current_user.id
      redirect_to books_path
    end
  end
end

