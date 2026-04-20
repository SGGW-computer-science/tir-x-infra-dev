.PHONY: update-submodules seed-db

update-submodules:
	git submodule sync --recursive
	git submodule update --init --recursive
	git submodule update --remote --merge tir-x-backend tir-x-frontend
	git submodule status

seed-db:
	./scripts/seed-db.sh
