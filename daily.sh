#!/bin/bash

CONFIG_DIR="${HOME}/.daily"
CONFIG_FILE_PATH="${CONFIG_DIR}/config"
KEY_SAVE_DIR="key_save_dir"

# function related to open file

function start_edit() {
    local save_dir=$(get_save_dir)
    local file_path="${save_dir}/$(date +"%Y%m%d").md"

    validate_save_dir ${save_dir}

    make_file_if_not_exist ${file_path}

    # Open file 
    # If EDITOR is not set, vim is used as the default editor
    ${EDITOR:-vim} ${file_path}
}

function get_save_dir() {
  # Get the save directory from config file
  echo $(cat ${CONFIG_FILE_PATH} | grep ${KEY_SAVE_DIR} | cut -d'=' -f2)
}

function validate_save_dir() {
    if [ ! -d $1 ]; then
      echo "Please set the save directory."
      exit 1
    fi
}

function make_file_if_not_exist() {
  if [ ! -e $1 ]; then
    touch $1
  fi
}

# function related to set directory

function set_save_dir_if_valid() {
  if [ $# -eq 0 ]; then
    echo "Please enter the directory path."
    exit 1
  elif [ ! -d $1 ]; then
    echo "Invalid directory path. Please enter the exsiting directory path."
    exit 1
  else
    set_save_dir $1
  fi
}

function set_save_dir() {
  # Set the save directory in config file
  sed -i '' "s|^${KEY_SAVE_DIR}=.*|${KEY_SAVE_DIR}=$1|" "${CONFIG_FILE_PATH}"
}

# function related to initialize

function make_config_file() {
  # Make config file in /.daily
  if [ ! -e ${CONFIG_FILE_PATH} ]; then
    mkdir ${CONFIG_DIR}
    touch "${CONFIG_FILE_PATH}"
    echo "${KEY_SAVE_DIR}=" >> "${CONFIG_FILE_PATH}"
  else
    echo "Already initialized. ${CONFIG_FILE_PATH} exists."
  fi
}


if [ $# -eq 0 ]; then
   start_edit
elif [ "$1" = "init" ]; then
    make_config_file
elif [ "$1" = "set_dir" ]; then
    set_save_dir_if_valid $2
else
    echo "Invalid argument"
    exit 1
fi

