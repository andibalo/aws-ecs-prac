# Variables
AWS_ACCOUNT_ID ?= ""
AWS_REGION     ?= ""
IMAGE_NAME     ?= ""
IMAGE_TAG      ?= ""

# Calculated variables
ECR_REPO = $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME)

.PHONY: ecr-push

ecr-push:
	@echo "Logging in to AWS ECR..."
	@aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

	@echo "Tagging image for ECR..."
	@docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(ECR_REPO):$(IMAGE_TAG)

	@echo "Pushing image to ECR..."
	@docker push $(ECR_REPO):$(IMAGE_TAG)

	@echo "ECR push complete: $(ECR_REPO):$(IMAGE_TAG)"