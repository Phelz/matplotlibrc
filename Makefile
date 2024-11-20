SHELL := /bin/bash

# Usage:
# 1. Copy this Makefile to the root directory of the project
# 2. Run 'make setup' to create the Conda environment and install the development package
# 3. (Optional) Run 'sudo make install_fonts' to install Microsoft TrueType core fonts if needed

# Pick an enviroment name and python verison
ENV_NAME := quadrupole_magnet
PYTHON_VERSION := 3.12
# --------------------------------------------------

CONDAROOT ?= /home/$(USER)/anaconda3
MATPLOTLIBRC_URL := https://archive.org/download/matplotlibrc/matplotlibrc
MATPLOTLIBRC_DIR := $(CONDAROOT)/envs/$(ENV_NAME)/lib/python$(PYTHON_VERSION)/site-packages/matplotlib/mpl-data/

.PHONY: setup init install message update_matplotlibrc

setup: init install message update_matplotlibrc

init: 
	@echo "Initializing..."
	@chmod -R 755 src/

install:
	@echo "Creating and setting up the Conda environment..."
	@source $(CONDAROOT)/bin/activate && conda env create -n $(ENV_NAME) python=$(PYTHON_VERSION) -y
	@echo "Installing development package..."
	@source $(CONDAROOT)/bin/activate $(ENV_NAME) && conda develop .

update_matplotlibrc:
	@echo "Updating matplotlibrc configuration..."
	@wget -O matplotlibrc $(MATPLOTLIBRC_URL)
	@cp $(MATPLOTLIBRC_DIR)/matplotlibrc $(MATPLOTLIBRC_DIR)/matplotlibrc.backup
	@mv matplotlibrc $(MATPLOTLIBRC_DIR)/

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