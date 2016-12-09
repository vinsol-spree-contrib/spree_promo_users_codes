Deface::Override.new(
  virtual_path: 'spree/admin/promotions/edit',
  name: 'admin_add_promotion_code_button',
  insert_after: "#promotion-filters",
  text: '<%= render partial: "spree/admin/promotions/view_codes", locals: { promotion: @promotion } %>'
)
