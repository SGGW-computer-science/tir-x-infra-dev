.PHONY: update-submodules

update-submodules:
	git submodule sync --recursive
	git submodule update --init --recursive
	git submodule update --remote --merge tir-x-backend tir-x-frontend
	git submodule status
