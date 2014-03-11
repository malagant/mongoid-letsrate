require 'spec_helper'

require 'mongoid-letsrate'

describe Mongoid::Letsrate do
  let(:first_user) { User.create }
  let(:second_user) { User.create }
  let(:third_user) { User.create }
  let(:product) { Product.create }

  it 'first_user should not be nil' do
    first_user.should_not be_nil
  end

  it 'second_user should not be nil' do
    second_user.should_not be_nil
  end

  it 'third_user should not be nil' do
    third_user.should_not be_nil
  end

  it 'user should not have any ratings done' do
    first_user.ratings_given.count.should eql 0
  end

  it 'product should not be nil' do
    product.should_not be_nil
  end

  describe 'User with letsrate' do
    it 'should have relation to rateable' do
      first_user.should have_many_related :ratings_given
    end
    it 'should have relation to rateable' do
      first_user.should belong_to :rateable
    end
  end

  describe 'Product rated by user' do
    it 'rates should be of type Mongoid::Relations::Targets::Enumerable' do
      product.rates.class.should eql Mongoid::Relations::Targets::Enumerable
    end

    it 'rates should be empty' do
      product.rates.should be_empty
    end

    it 'rates should be 1 after rating with 5 stars' do
      product.rate 5, first_user
      product.rates.count.should eql 1
    end

    it 'rates should be 2 after rating with 5 stars' do
      product.rate 5, first_user
      product.rate 5, second_user
      product.rates.count.should eql 2
    end

    it 'average rating create' do
      rating_cache = product.rate 2, first_user
      rating_cache.should_not be_nil
    end

    it 'average rating create' do
      rating_cache = product.rate 2, first_user
      rating_cache.avg.should eql 2.0
    end

    it 'average rating should be 2.5 after rating with 2 and 3 stars' do
      cacheable = product.rate(2, first_user).cacheable
      cacheable.rate 3, second_user
      cacheable.rating.should eql 2.5
    end
   end
end