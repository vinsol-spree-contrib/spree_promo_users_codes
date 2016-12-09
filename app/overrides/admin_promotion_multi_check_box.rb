Deface::Override.new(
  virtual_path: 'spree/admin/promotions/_form',
  name: 'admin_promotion_multi_check_box',
  insert_bottom: '#general_fields',
  text: '<%= render partial: "spree/admin/promotions/multi_coupon", locals: { f: f } %>'
)
