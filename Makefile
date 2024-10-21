
.PHONY: format

format:
	@command -v prettier >/dev/null 2>&1 || { echo >&2 "prettier is not installed. Please install it."; exit 1; }
	@command -v latexindent >/dev/null 2>&1 || { echo >&2 "latexindent.pl is not installed. Please install it."; exit 1; }
	@echo "Formatting all Markdown and latex files."
	@find . -type f -iname "*.md" -exec prettier --write {} \;
	@find . -type f -iname "*.tex" -exec latexindent -w {} \;
	@echo "Removing generated backup files"
	@find . -type f -iname "*bak*" -exec rm {} \;


