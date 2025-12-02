Table silver_transaction {
  transaction_id uuid [pk]
  account_id uuid [ref: > silver_account.account_id]
  customer_id uuid [ref: > silver_customer.customer_id]

  amount_local numeric(18,2)
  currency_code varchar(3) // ex: BRL, MXN, COP
  amount_usd numeric(18,2)
  in_or_out varchar        // 'in' | 'out'
  event_type varchar //pix_request, transfer_reques, chargeback
  status varchar 
  requested_at timestampz 
  completed_at timestampz 

  channel varchar
  country_code char(3) [ref: > silver_country.country_code]

  product_id uuid [ref: <> bronze_product_country_availability.product_id]
  product_description varchar(128)
  product_category varchar(128)

  transaction_metadata json     // escalável para atributos por produto
  source_system varchar
  created_at_utc timestamp
}

Table silver_customer {
  customer_id uuid [pk]
  first_name varchar(128)
  last_name varchar(128)
  document_type varchar(128)
  document_number varchar(128)
  created_at timestampz 
  location_id uuid [ref: > silver_location.location_id]
}

Table silver_location {
  location_id uuid [pk]
  city varchar(128)
  state varchar(128)
  country_code char(3) [ref: > silver_country.country_code] // ISO 3166-1 alpha-3
}

Table silver_account {
  account_id uuid [pk]
  customer_id uuid [ref: > silver_customer.customer_id]
  created_at_utc datetime
  status varchar(128)
  account_metadata json
}

Table silver_country  {
  country_code char(3) [pk]           // ex: BRA, MEX, COL
  country_name varchar(128)           // ex: Brazil, Mexico, Colombia
  region varchar(64)                  // ex: LATAM, EU, APAC
}

Table bronze_product_country_availability {
  product_id varchar(64) 
  country_code char(3) //[ref: > silver_country.country_code]
  availability_start date
  availability_end date
  regulatory_flags json               // ex: {"mask_pii":true,"kyc_required":true}
  is_active boolean


  // chave composta
  Note: 'Primary key is (product_id, country_code)'
}




Ref: "silver_transaction"."country_code" <> "bronze_product_country_availability"."country_code"
