SHELL := /bin/bash

# Usage:
# 1. Copy this Makefile to the root directory of the project
# 2. Run 'make setup' to create the Conda environment and install the development package
# 3. (Optional) Run 'sudo make install_fonts' to install Microsoft TrueType core fonts if needed

# Pick an enviroment name and python verison
ENV_NAME := quad_mag
PYTHON_VERSION := 3.12.0
PYTHON_VERSION_TRUNCATED := $(shell echo $(PYTHON_VERSION) | cut -d. -f1,2)
# --------------------------------------------------

CONDAROOT ?= /home/$(USER)/anaconda3
MATPLOTLIBRC_URL := https://archive.org/download/matplotlibrc/matplotlibrc
MATPLOTLIBRC_DIR := $(CONDAROOT)/envs/$(ENV_NAME)/lib/python$(PYTHON_VERSION_TRUNCATED)/site-packages/matplotlib/mpl-data/

.PHONY: setup init install message update_matplotlibrc

setup: init install message update_matplotlibrc

init: 
	@echo "Initializing..."
	@chmod -R 755 src/
	@echo "Using python=$(PYTHON_VERSION) and environment name=$(ENV_NAME)"

	# Add dependencies as desired
	@echo "name: $(ENV_NAME)" > environment.yml
	@echo "channels:" >> environment.yml
	@echo "- anaconda" >> environment.yml
	@echo "- defaults" >> environment.yml
	@echo "dependencies:" >> environment.yml
	@echo "- ipython" >> environment.yml
	@echo "- matplotlib" >> environment.yml
	@echo "- pandas" >> environment.yml
	@echo "- python=$(PYTHON_VERSION)" >> environment.yml

install:
	@echo "Creating and setting up the Conda environment..."
	@source $(CONDAROOT)/bin/activate && conda env create -n $(ENV_NAME) -f environment.yml -y
	@echo "Installing development package..."
	@source $(CONDAROOT)/bin/activate $(ENV_NAME) && conda develop .

update_matplotlibrc:
	@echo "Updating matplotlibrc configuration..."
	@wget -O matplotlibrc $(MATPLOTLIBRC_URL)
	@cp $(MATPLOTLIBRC_DIR)/matplotlibrc $(MATPLOTLIBRC_DIR)/matplotlibrc.backup
	@mv matplotlibrc $(MATPLOTLIBRC_DIR)/
	@echo "Matplotlibrc updated."

message:
	@echo "=================================================="
	@echo "Setup completed. Activate the environment with 'conda activate $(ENV_NAME)'"
	@echo "=================================================="


install_fonts: download_ttcf clean_matplotlib_cache

download_ttcf:
	@echo "Installing Microsoft TrueType core fonts. This requires administrative privileges:"
	@echo "Running 'sudo apt install msttcorefonts -qq'"
	@sudo apt install msttcorefonts -qq

clean_matplotlib_cache:
	@echo "Cleaning Matplotlib cache..."
	@rm -rf ~/.cache/matplotlib