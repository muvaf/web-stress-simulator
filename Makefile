build:
	@echo "Building for linux/arm64"
	@docker buildx build --platform linux/arm64 -t muvaf/stress-simulator:v1.0.0 -f Dockerfile . --push