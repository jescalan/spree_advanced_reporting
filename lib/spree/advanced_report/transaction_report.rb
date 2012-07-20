class Spree::AdvancedReport::TransactionReport < Spree::AdvancedReport
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::UrlHelper

  def name
    "Transaction Report"
  end

  def description
    "Top purchasing customers, calculated by revenue"
  end

  def initialize(params)
    super(params)

    self.ruportdata = Table(%w[date type id total state])

    card_listing = {}

    orders.each do |order|
      order.payments.each do |payment|
        # create a direct link for easy inspection
        gateway_link = payment.response_code

        if payment.payment_method.type == "Spree::Gateway::AuthorizeNetCim"
          gateway_link = link_to(payment.response_code, "https://account.authorize.net/UI/themes/anet/transaction/transactiondetail.aspx?transID=#{payment.response_code}", target: '_blank')
        end

        (card_listing[payment.source.cc_type] ||= []) << {
          "date" => payment.source.created_at,
          "type" => payment.source.cc_type.capitalize,
          "id" => gateway_link,
          "total" => payment.amount,
          "state" => payment.state,
        }
      end
    end

    @sales_total = 0

    card_listing.keys.sort.each do |card_name|
      card_total = card_listing[card_name].map { |c| c["total"] }.sum
      @sales_total += card_total

      ruportdata << {
        "date" => "<b>#{card_name.capitalize} (#{card_listing[card_name].count}): #{number_to_currency(card_total)}</b>"
      }

      card_listing[card_name].each do |transaction|
        transaction["total"] = number_to_currency(transaction["total"])
        ruportdata << transaction
      end
    end
    
    ruportdata << { "date" => "<b>Sales Total: #{number_to_currency(@sales_total)}</b>" }

    # spaces don't seem to work in column names (ruport is old...)
    ruportdata.rename_column("date", "Transaction Date")
    ruportdata.rename_column("type", "Card Type")
    ruportdata.rename_column("id", "Transaction ID")
    ruportdata.rename_column("total", "Payment Total")
    ruportdata.rename_column("state", "Payment State")
  end

  def sales_total
    @sales_total
  end
end
