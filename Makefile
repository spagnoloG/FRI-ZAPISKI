
.PHONY: format

format:
	@echo "Formatting all Markdown and latex files."
	@find . -type f -iname "*.md" -exec prettier --write {} \;
	@find . -type f -iname "*.tex" -exec latexindent.pl -w {} \;
	@echo "Removing generated backup files"
	@find . -type f -iname "*bak*" -exec rm {} \;


