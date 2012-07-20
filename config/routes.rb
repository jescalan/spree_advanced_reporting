 Spree::Core::Engine.routes.prepend do
  #namespace :admin do
  #  resources :reports, :only => [:index, :show] do
  #    collection do
  #      get :sales_total
  #    end
  #  end
  #end
  match '/admin/reports/revenue' => 'admin/reports#revenue',  :via  => [:get, :post],
                                                              :as   => 'revenue_admin_reports'

  match '/admin/reports/count' => 'admin/reports#count',  :via  => [:get, :post],
                                                          :as   => 'count_admin_reports'

  match '/admin/reports/units' => 'admin/reports#units',  :via  => [:get, :post],
                                                          :as   => 'units_admin_reports'

  match '/admin/reports/profit' => 'admin/reports#profit',  :via => [:get, :post],
                                                            :as  => 'profit_admin_reports'


  match '/admin/reports/top_customers' => 'admin/reports#top_customers',  :via  => [:get, :post],
                                                                          :as   => 'top_customers_admin_reports'

  match '/admin/reports/top_products' => 'admin/reports#top_products',  :via  => [:get, :post],
                                                                        :as   =>  'top_products_admin_reports'

  match '/admin/reports/geo_revenue' => 'admin/reports#geo_revenue', :via => [:get, :post],
                                                                      :as => 'geo_revenue_admin_reports'

  match '/admin/reports/geo_units' => 'admin/reports#geo_units', :via => [:get, :post],
                                                                  :as => 'geo_units_admin_reports'

  match '/admin/reports/geo_profit' => 'admin/reports#geo_profit', :via => [:get, :post],
                                                                    :as => 'geo_profit_admin_reports'

  match '/admin/reports/transactions' => 'admin/reports#transactions', :via => [:get, :post],
                                                                       :as => 'transactions_admin_reports'

  # match "/admin" => "admin/advanced_report_overview#index", :as => :admin
end
