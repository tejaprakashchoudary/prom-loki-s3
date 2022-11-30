# Monitoring

## Start up

Run the provided scripts in `/monitoring` (to be moved to ansible soon) `cd monitoring && source scripts/create_env.sh prod && source scripts/deploy.sh`

## Accounts

- Dev   = `274274389940`
- QA    = `122441943963`
- Demo  = `476378927390`
- Prod  = `032372454047`
- Sandbox = `311084895497`

## Permissions

The EC2 instances needs a role that allows for the ability to write to the `production` prometheus workspace. Lower environments will need a shared roles between accounts

- EC2 Role - AmazonPrometheusRemoteWriteAccess
- Trust roles - for cross account relationships

Assume Roles

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": [
                "arn:aws:iam::476378927390:role/MRP-AMP-Central-Role",
                "arn:aws:iam::476378927390:role/service-role/AmazonGrafanaServiceRole-Za7rg6gZB"
            ]
        }
    ]
}
```

## AWS Prometheus

## AWS Grafana
