project_id = "mvn-sandbox-smsgw-yzhan"
region     = "northamerica-northeast2"

# 1. Project Owners
iam_owners = [
  "user:julien.chesnay@pluscompany.com",
  "user:yichen.zhan@munvo.ca"
]

# 2. Infra Admins (lead dev or DevOps person)
iam_admins = [
  "user:vishal.senewiratne@munvo.ca"
]

# 3. Developers (Can deploy code, can't delete DBs)
iam_developers = [
  "user:david.gilbert@munvo.ca",
  "user:adithya.murali@munvo.ca"
]

# 4. Data/Ops (Can read BigQuery & Dashboards, can't change code)
iam_data_viewers = [
  "user:guillaume.rochefort-mathieu@munvo.ca"
]