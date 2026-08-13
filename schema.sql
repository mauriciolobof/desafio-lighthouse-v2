-- schema.sql gerado automaticamente em 2026-08-13T15:26:23
-- Fonte: 24 arquivos CSV em data/raw


CREATE TABLE "addresses" (
    "id" INTEGER PRIMARY KEY,
    "customer_id" INTEGER NOT NULL,
    "address_type" VARCHAR(50) NOT NULL,
    "postal_code" VARCHAR(50) NOT NULL,
    "street" VARCHAR(52) NOT NULL,
    "number" INTEGER NOT NULL,
    "complement" VARCHAR(50),
    "district" VARCHAR(50) NOT NULL,
    "city" VARCHAR(50) NOT NULL,
    "state" VARCHAR(50) NOT NULL,
    "country" VARCHAR(50) NOT NULL,
    "is_primary" BOOLEAN NOT NULL
);

CREATE TABLE "attributes" (
    "id" INTEGER PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    "data_type" VARCHAR(50) NOT NULL
);

CREATE TABLE "brands" (
    "id" INTEGER PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    "country" VARCHAR(50),
    "is_active" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "categories" (
    "id" INTEGER PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    "slug" VARCHAR(50) NOT NULL,
    "parent_category_id" INTEGER,
    "is_active" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "customers" (
    "id" INTEGER PRIMARY KEY,
    "person_type" VARCHAR(50) NOT NULL,
    "legal_name" VARCHAR(50) NOT NULL,
    "trade_name" VARCHAR(50),
    "tax_id" BIGINT NOT NULL,
    "state_registration" VARCHAR(50),
    "email" VARCHAR(73),
    "phone" VARCHAR(50),
    "is_active" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "employees" (
    "id" INTEGER PRIMARY KEY,
    "full_name" VARCHAR(50) NOT NULL,
    "cpf" BIGINT NOT NULL,
    "email" VARCHAR(69) NOT NULL,
    "role" VARCHAR(50) NOT NULL,
    "primary_location_id" INTEGER NOT NULL,
    "hire_date" DATE NOT NULL,
    "termination_date" DATE,
    "is_active" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "fiscal_invoices" (
    "id" INTEGER PRIMARY KEY,
    "order_id" INTEGER NOT NULL,
    "nfe_number" VARCHAR(50) NOT NULL,
    "nfe_access_key" VARCHAR(66) NOT NULL,
    "series" INTEGER NOT NULL,
    "issued_at" TIMESTAMP NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "total_amount" NUMERIC(14,2) NOT NULL,
    "xml_storage_uri" VARCHAR(103) NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "goods_receipt_items" (
    "id" INTEGER PRIMARY KEY,
    "goods_receipt_id" INTEGER NOT NULL,
    "purchase_order_item_id" INTEGER NOT NULL,
    "quantity_received" NUMERIC(14,2) NOT NULL
);

CREATE TABLE "goods_receipts" (
    "id" INTEGER PRIMARY KEY,
    "purchase_order_id" INTEGER NOT NULL,
    "received_by_employee_id" INTEGER NOT NULL,
    "received_at" TIMESTAMP NOT NULL,
    "notes" VARCHAR(50),
    "created_at" TIMESTAMP NOT NULL
);

CREATE TABLE "locations" (
    "id" INTEGER PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    "location_type" VARCHAR(50) NOT NULL,
    "postal_code" VARCHAR(50) NOT NULL,
    "street" VARCHAR(50) NOT NULL,
    "number" INTEGER NOT NULL,
    "complement" VARCHAR(50),
    "district" VARCHAR(50) NOT NULL,
    "city" VARCHAR(50) NOT NULL,
    "state" VARCHAR(50) NOT NULL,
    "country" VARCHAR(50) NOT NULL,
    "is_active" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "order_items" (
    "id" INTEGER PRIMARY KEY,
    "order_id" INTEGER NOT NULL,
    "product_variant_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unit_price" NUMERIC(14,2) NOT NULL,
    "icms_rate" NUMERIC(14,2) NOT NULL,
    "ipi_rate" NUMERIC(14,2) NOT NULL,
    "line_total" NUMERIC(14,2) NOT NULL
);

CREATE TABLE "orders" (
    "id" INTEGER PRIMARY KEY,
    "order_number" VARCHAR(50) NOT NULL,
    "channel" VARCHAR(50) NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "salesperson_id" INTEGER,
    "location_id" INTEGER NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "subtotal" NUMERIC(14,2) NOT NULL,
    "discount_amount" NUMERIC(14,2) NOT NULL,
    "total" NUMERIC(14,2) NOT NULL,
    "placed_at" TIMESTAMP NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "payments" (
    "id" INTEGER PRIMARY KEY,
    "order_id" INTEGER NOT NULL,
    "method" VARCHAR(50) NOT NULL,
    "installments" INTEGER NOT NULL,
    "amount" NUMERIC(14,2) NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "paid_at" TIMESTAMP,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "product_suppliers" (
    "product_variant_id" INTEGER NOT NULL,
    "supplier_id" INTEGER NOT NULL,
    "supplier_sku" VARCHAR(50),
    "last_quoted_cost" NUMERIC(14,2) NOT NULL,
    "lead_time_days" INTEGER NOT NULL,
    "is_preferred" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "product_variants" (
    "id" INTEGER PRIMARY KEY,
    "product_id" INTEGER NOT NULL,
    "sku" VARCHAR(50) NOT NULL,
    "barcode_ean" BIGINT,
    "sale_price" NUMERIC(14,2) NOT NULL,
    "cost_price" NUMERIC(14,2) NOT NULL,
    "weight_kg" NUMERIC(14,2) NOT NULL,
    "icms_rate" NUMERIC(14,2) NOT NULL,
    "ipi_rate" NUMERIC(14,2) NOT NULL,
    "is_active" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "products" (
    "id" INTEGER PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    "description" VARCHAR(72),
    "brand_id" INTEGER NOT NULL,
    "category_id" INTEGER NOT NULL,
    "ncm_code" INTEGER NOT NULL,
    "unit_of_measure" VARCHAR(50) NOT NULL,
    "is_active" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "purchase_order_items" (
    "id" INTEGER PRIMARY KEY,
    "purchase_order_id" INTEGER NOT NULL,
    "product_variant_id" INTEGER NOT NULL,
    "quantity_ordered" INTEGER NOT NULL,
    "unit_cost" NUMERIC(14,2) NOT NULL,
    "line_total" NUMERIC(14,2) NOT NULL
);

CREATE TABLE "purchase_orders" (
    "id" INTEGER PRIMARY KEY,
    "po_number" VARCHAR(50) NOT NULL,
    "supplier_id" INTEGER NOT NULL,
    "buyer_id" INTEGER NOT NULL,
    "destination_location_id" INTEGER NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "currency" VARCHAR(50) NOT NULL,
    "subtotal" NUMERIC(14,2) NOT NULL,
    "total" NUMERIC(14,2) NOT NULL,
    "placed_at" TIMESTAMP NOT NULL,
    "expected_delivery_at" DATE,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "return_items" (
    "id" INTEGER PRIMARY KEY,
    "return_id" INTEGER NOT NULL,
    "order_item_id" INTEGER NOT NULL,
    "quantity" NUMERIC(14,2) NOT NULL,
    "action" VARCHAR(50) NOT NULL,
    "exchange_variant_id" INTEGER,
    "unit_refund_amount" NUMERIC(14,2) NOT NULL
);

CREATE TABLE "returns" (
    "id" INTEGER PRIMARY KEY,
    "return_number" VARCHAR(50) NOT NULL,
    "order_id" INTEGER NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "received_at_location_id" INTEGER NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "reason" VARCHAR(50),
    "total_refund_amount" NUMERIC(14,2) NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "stock_levels" (
    "product_variant_id" INTEGER NOT NULL,
    "location_id" INTEGER NOT NULL,
    "quantity_on_hand" NUMERIC(14,2) NOT NULL,
    "reorder_point" VARCHAR(255),
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "stock_movements" (
    "id" INTEGER PRIMARY KEY,
    "product_variant_id" INTEGER NOT NULL,
    "location_id" INTEGER NOT NULL,
    "movement_type" VARCHAR(50) NOT NULL,
    "quantity" NUMERIC(14,2) NOT NULL,
    "reference_table" VARCHAR(50),
    "reference_id" INTEGER,
    "employee_id" INTEGER,
    "notes" VARCHAR(51),
    "occurred_at" TIMESTAMP NOT NULL,
    "created_at" TIMESTAMP NOT NULL
);

CREATE TABLE "suppliers" (
    "id" INTEGER PRIMARY KEY,
    "legal_name" VARCHAR(50) NOT NULL,
    "trade_name" VARCHAR(50),
    "country" VARCHAR(50) NOT NULL,
    "tax_id" VARCHAR(50) NOT NULL,
    "tax_id_type" VARCHAR(50) NOT NULL,
    "email" VARCHAR(50) NOT NULL,
    "phone" BIGINT NOT NULL,
    "contact_name" VARCHAR(50) NOT NULL,
    "is_active" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP NOT NULL
);

CREATE TABLE "variant_attribute_values" (
    "product_variant_id" INTEGER NOT NULL,
    "attribute_id" INTEGER NOT NULL,
    "value" VARCHAR(50) NOT NULL
);
