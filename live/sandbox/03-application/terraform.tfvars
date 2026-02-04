project    = "mvn-sandbox-smsgw-yzhan"
region     = "northamerica-northeast2"
run_region = "northamerica-northeast2"
# vpc_name   = "yichen-vpc"

otel_collector_url = "https://otel-collector-618425665876.northamerica-northeast2.run.app"

# Redefine the env vars to include the new one
cloudrun_env = [
  { name = "DB_HOST", value = "10.53.96.5" },
  { name = "DATASOURCE_PSQL_URL", secret = "DATASOURCE_PSQL_URL" },
  { name = "DATASOURCE_PSQL_DATABASE_NAME", secret = "DATASOURCE_PSQL_DATABASE_NAME" },
  { name = "DATASOURCE_PSQL_USERNAME", secret = "DATASOURCE_PSQL_USERNAME" },
  { name = "DATASOURCE_PSQL_PASSWORD", secret = "DATASOURCE_PSQL_PASSWORD" },
  # NEW: The OTel Endpoint
  { name = "OTEL_EXPORTER_OTLP_ENDPOINT", value = "https://otel-collector-618425665876.northamerica-northeast2.run.app" },
  # --- NEW: Redis Connection Info ---
  { name = "REDIS_HOST", value = "10.75.36.3" },
  { name = "REDIS_PORT", value = "6379" }
]