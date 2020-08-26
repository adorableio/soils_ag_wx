require 'test_helper'

class SubscriptionMailerTest < ActionMailer::TestCase
  RICKS_EMAIL = 'fewayne@gmail.com'
  SENDER_EMAIL = 'cals-it-admin@cals.wisc.edu'
  RICK = 'Rick Me Bucko'
  LATITUDE = 42.0
  LONGITUDE = -89.0
  ETS = [0.05,0.10,0.15,0.20,0.25,0.30,0.35]
  AGO_ET = 0.9
  AGO_REGEXP = /,0\.9<br\/>/
  DAYS_AGO = 10

  def setup
    @etgrid = Product.create! name: 'ET', data_table_name: 'wi_mn_dets', type: 'GridProduct', subscribable: true
    @rick = Subscriber.create! name: RICK, email: RICKS_EMAIL, confirmation_token: Subscriber.confirmation_number
    @rick_subs = Subscription.create! latitude: LATITUDE, longitude: LONGITUDE,
      product_id: GridProduct.first[:id], doy_start: 1, doy_end: 365, subscriber: @rick
    ETS.each_with_index { |et,ii| WiMnDet.create! date: days_back(ii), latitude: LATITUDE, w892: et }
    WiMnDet.create! date: days_back(DAYS_AGO), latitude: LATITUDE, w892: AGO_ET
    @rick.subscriptions << @rick_subs; @rick.save!
  end

  def days_back(ii)
    Date.today - (ii+1)
  end

  test "confirm" do
    mail = SubscriptionMailer.confirm(@rick)
    assert_equal 'Please confirm your email address for UWEX Ag Weather subscription', mail.subject
    assert_equal [RICKS_EMAIL], mail.to
    assert_equal [RICKS_EMAIL], mail.to
    assert_equal [SENDER_EMAIL], mail.from
    assert_equal true,  mail.body.encoded.present?
  end

  test "special" do
    mail = SubscriptionMailer.special(@rick,"Hi Rick Wayne,\r\n\r\n")
    assert_equal "Update: Your UWEX Ag Weather automated product subscription", mail.subject
    assert_equal [RICKS_EMAIL], mail.to
    assert_equal [SENDER_EMAIL], mail.from
    assert_match "Hi Rick Wayne,\r\n\r\n", mail.body.encoded
  end

end
