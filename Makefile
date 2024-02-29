
.PHONY: format

format:
	@echo "Formatting all Markdown files."
	@find . -type f -iname "*.md" -exec prettier --write {} \;


