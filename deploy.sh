#! /usr/bin/bash

# Getting Started with Agent2Agent (A2A) Protocol: A Purchasing Concierge and Remote Seller Agent Interactions on Cloud Run and Agent Engine
# https://codelabs.developers.google.com/intro-a2a-purchasing-concierge

gcloud auth login

gcloud config set project gcs-mcp-server

export PROJECT_ID=$(gcloud config get-value project)
echo "$PROJECT_ID"

git clone https://github.com/alphinside/purchasing-concierge-intro-a2a-codelab-starter.git purchasing-concierge-a2a

cd purchasing-concierge-a2a
uv sync --frozen

gcloud services enable aiplatform.googleapis.com \
                       run.googleapis.com \
                       cloudbuild.googleapis.com \
                       cloudresourcemanager.googleapis.com

gcloud run deploy burger-agent \
    --source remote_seller_agents/burger_agent \
    --port=8080 \
    --allow-unauthenticated \
    --region us-central1 \
    --update-env-vars GOOGLE_CLOUD_LOCATION=us-central1 \
    --update-env-vars GOOGLE_CLOUD_PROJECT=$PROJECT_ID

# Open a new browser tab and go to 
# https://burger-agent-281483222353.us-central1.run.app/.well-known/agent.json

# Updating the Burger Agent URL Value on Agent Card via Environment Variable
# To add HOST_OVERRIDE to burger agent service
# Cloud Run
# burger-agent
# Edit and deploy new revision
# Variable & Secrets
# After that, click Add variable and set the HOST_OVERRIDE the value to the service URL ( the one with https://burger-agent-281483222353.us-central1.run.app
# deploy 

# When you access the burger-agent agent card again in the browser https://burger-agent-281483222353.us-central1.run.app/.well-known/agent.json , the url value will already be properly configured

gcloud run deploy pizza-agent \
    --source remote_seller_agents/pizza_agent \
    --port=8080 \
    --allow-unauthenticated \
    --region us-central1 \
    --update-env-vars GOOGLE_CLOUD_LOCATION=us-central1 \
    --update-env-vars GOOGLE_CLOUD_PROJECT=$PROJECT_ID

# Open a new browser tab and go to 
# https://pizza-agent-281483222353.us-central1.run.app/.well-known/agent.json

# Updating the Pizza Agent URL Value on Agent Card via Environment Variable
# To add HOST_OVERRIDE to pizza agent service
# Cloud Run
# pizza-agent
# Edit and deploy new revision
# Variable & Secrets
# After that, click Add variable and set the HOST_OVERRIDE the value to the service URL ( the one with https://pizza-agent-281483222353.us-central1.run.app
# deploy 

# When you access the pizza-agent agent card again in the browser https://pizza-agent-281483222353.us-central1.run.app/.well-known/agent.json , the url value will already be properly configured

gcloud storage buckets create gs://purchasing-concierge-$PROJECT_ID --location=us-central1

cp .env.example .env

uv run deploy_to_agent_engine.py

# Agent Engine resource name as
# projects/281483222353/locations/us-central1/reasoningEngines/6645988138487382016
# inspect it in agent engine dashboard

# Testing the Deployed Agent on Agent Engine
bash test_agent_engine.sh

# Integration Testing and Payload Inspection
uv run purchasing_concierge_ui.py

# Show me burger and pizza menu
# I want to order 1 bbq chicken pizza and 1 spicy cajun burger

# http://localhost:8081/

