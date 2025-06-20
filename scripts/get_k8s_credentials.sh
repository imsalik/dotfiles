#!/bin/bash

# List all clusters with their proper location type (zone or region)
echo "Listing available clusters..."
gcloud container clusters list --format="table[no-heading](name, location, locationtype)"

# Get credentials for each available cluster
for CLUSTER_INFO in $(gcloud container clusters list --format="csv[no-heading](name,location,locationtype)")
do
  IFS=',' read -r CLUSTER_NAME LOCATION LOCATION_TYPE <<< "$CLUSTER_INFO"
  echo "Getting credentials for cluster: $CLUSTER_NAME in $LOCATION_TYPE: $LOCATION"
  
  if [ "$LOCATION_TYPE" == "zone" ]; then
    gcloud container clusters get-credentials "$CLUSTER_NAME" --zone "$LOCATION" --project "$(gcloud config get-value project)"
  else
    gcloud container clusters get-credentials "$CLUSTER_NAME" --region "$LOCATION" --project "$(gcloud config get-value project)"
  fi
done

echo "Available contexts:"
kubectl config get-contexts
