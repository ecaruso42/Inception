DATA_DIR = /home/$(USER)/data
WP_VOL = $(DATA_DIR)/wordpress
DB_VOL = $(DATA_DIR)/mariadb

GREEN = \033[0;32m
RED = \033[0;31m
RESET = \033[0m

all: setup build

setup:
	@printf "Creating data directories...\n"
	@sudo mkdir -p $(WP_VOL)
	@sudo mkdir -p $(DB_VOL)
	@sudo chmod 777 $(WP_VOL)
	@sudo chmod 777 $(DB_VOL)
	@printf "$(GREEN)Data directories created$(RESET)\n"

build:
	@printf "Building and starting containers...\n"
	docker compose -f ./srcs/docker-compose.yml up --build -d
	@printf "$(GREEN)Containers built$(RESET)\n"

start:
	@printf "$(GREEN)Starting containers...$(RESET)\n"
	@docker compose -f ./srcs/docker-compose.yml start

stop:
	@printf "$(RED)Stopping containers...$(RESET)\n"
	@docker compose -f ./srcs/docker-compose.yml stop

clean: stop
	@docker compose -f ./srcs/docker-compose.yml down -v
	@sudo rm -rf $(DATA_DIR)

fclean: clean
	@docker system prune -af

re: fclean all