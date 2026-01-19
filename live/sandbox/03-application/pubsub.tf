# ------------------------------------------------------------------------------
# TOPICS (The Pipes)
# ------------------------------------------------------------------------------

resource "google_pubsub_topic" "batch" {
  name = "batch"
}

resource "google_pubsub_topic" "priority" {
  name = "priority"
}

resource "google_pubsub_topic" "webhooks" {
  name = "webhooks"
}

# ------------------------------------------------------------------------------
# SUBSCRIPTIONS (The Inboxes - Consumed by Cloud Run)
# ------------------------------------------------------------------------------

# 1. Batch Subscription (Bulk Traffic)
# Configuration: Long Ack Deadline (5 mins) for heavy processing
resource "google_pubsub_subscription" "batch_sub" {
  name  = "batch-sub"
  topic = google_pubsub_topic.batch.name

  ack_deadline_seconds = 300

  message_retention_duration = "604800s" # 7 Days

  expiration_policy {
    ttl = "2678400s" # 31 Days
  }
  
  # Optional: Dead Letter Policy could be added here later
}

# 2. Priority Subscription (OTP / Alerts)
# Configuration: Short Ack Deadline (10s) for fast processing
resource "google_pubsub_subscription" "priority_sub" {
  name  = "priority-sub"
  topic = google_pubsub_topic.priority.name

  ack_deadline_seconds = 10

  message_retention_duration = "604800s"

  expiration_policy {
    ttl = "2678400s"
  }
}

# 3. Webhooks Subscription (Delivery Receipts / DLRs)
# Configuration: Short Ack Deadline (10s)
resource "google_pubsub_subscription" "webhooks_sub" {
  name  = "webhooks-sub"
  topic = google_pubsub_topic.webhooks.name

  ack_deadline_seconds = 10

  message_retention_duration = "604800s"

  expiration_policy {
    ttl = "2678400s"
  }
}