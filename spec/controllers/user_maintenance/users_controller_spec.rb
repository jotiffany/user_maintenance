require 'rails_helper'

module UserMaintenance
  RSpec.describe UsersController, :type => :controller do

    describe 'GET #index' do
      before do
        sign_in_as_admin
        5.times { create :user }
        get :index, :use_route => :user_maintenance
      end

      it { expect(response).to render_template(:index) }
      it { expect(:users).not_to be_nil }
      it { expect(:users).not_to be_eql 0 }
    end

    describe 'GET #show' do
      before do
        sign_in_as_admin
        @user = create :user
        get :show, :id => @user.id, :use_route => :user_maintenance
      end

      it { expect(:user).not_to be_nil }
      it { expect(response).to render_template(:show) }
    end

    describe 'POST #create' do
      before do
        sign_in_as_admin
        post :create, :user => attributes_for(:user), :use_route => :user_maintenance
      end

      it { expect(response).to redirect_to User.last }
    end

    describe 'PUT #update' do
      before do
        sign_in_as_admin
        @user = User.first
        @new_attributes = {
          :last_name => 'Last name',
          :first_name => 'First name',
          :email => 'newuser@csi.com'
        }

        put :update, :id => @user, :user => @new_attributes, :use_route => :user_maintenance

        @user.reload
      end
      it { expect(@user.last_name).to be_eql(@new_attributes[:last_name]) }
      it { expect(@user.first_name).to be_eql(@new_attributes[:first_name]) }
      it { expect(@user.email).to be_eql(@new_attributes[:email]) }
      it { expect(response).to redirect_to profile_path }
    end

    describe 'PATCH #update_password' do
      before do
        sign_in_as_admin
        @user = create :user
        @new_credentials = {
          :current_password => 'password',
          :password => 'new_password',
          :password_confirmation => 'new_password'
        }

        patch :update_password, :id => @user, :user => @new_attributes, :use_route => :user_maintenance
      end

      it { expect(response).to redirect_to root_path }
    end
  end
end
