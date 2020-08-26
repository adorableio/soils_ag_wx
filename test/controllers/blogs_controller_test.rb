require 'test_helper'

class BlogsControllerTest < ActionController::TestCase
  setup do
    @blog = blogs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blog" do
    assert_difference('Blog.count') do
      post :create, params: { blog: { content: @blog.content, date: @blog.date, tags: @blog.tags } }
    end

    assert_redirected_to blog_path(assigns(:blog))
  end

  test "should show blog" do
    get :show, params: { id: @blog }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @blog }
    assert_response :success
  end

  test "should update blog" do
    patch :update, params: { id: @blog, blog: { content: @blog.content, date: @blog.date, tags: @blog.tags } }
    assert_redirected_to blog_path(assigns(:blog))
  end

  test "should destroy blog" do
    assert_difference('Blog.count', -1) do
      delete :destroy, params: { id: @blog }
    end

    assert_redirected_to blogs_path
  end
end
