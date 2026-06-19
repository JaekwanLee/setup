# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- 
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
function db() {
  service='base-api'

  if ! [ -z $1 ]; then
    service=$1
  fi

  # substitute hipen to underscore
  service=${service//-/_}
  # capitalize
  service=${service:u}

  # Get Db config by name
  eval host=$(echo $"${service}_DB_HOST")
  if [[ $1 == "aiq_push" ]]; then
    eval username=$(echo $"${service}_DB_USER")
  else
    eval username=$(echo $"${service}_DB_USERNAME")
  fi

  eval dbname=$(echo $"${service}_DB_NAME")
  eval password=$(echo $"${service}_DB_PASSWORD")

  echo db=$host, user=$username, dbname=$dbname

  if [ -z "$2" ]; then
    echo PGPASSWORD=$password psql -h $host -U $username $dbname
    PGPASSWORD=$password psql -h $host -U $username $dbname
  else
    PGPASSWORD=$password psql -h $host -U $username $dbname -c "$2"
  fi
}

# DB setup
function db_setup() {
  service='base-api'

  # substitute hipen to underscore
  service=${service//-/_}
  # capitalize
  service=${service:u}

  # Get Db config by name
  eval host=$(echo $"${service}_DB_HOST")
  eval username=$(echo $"${service}_DB_USERNAME")
  eval dbname=$(echo $"${service}_DB_NAME")
  eval password=$(echo $"${service}_DB_PASSWORD")
}

# Test
function runsql() {
  db_setup 

  #echo db=$host, user=$username, dbname=$dbname
  PGPASSWORD=$password psql -h $host -U $username $dbname -f $1
}

# Explain
function runsql_formatted() {
  db_setup 

  #echo db=$host, user=$username, dbname=$dbname
  PGPASSWORD=$password psql -h $host -U $username $dbname -qAt -f $1
}

function runsqlAll() {
  for env in $envs; do
    source ~/.agentiq/$env.env
    echo $ENVIRONMENT
    runsql $1
  done
}

function go() {
  env_name='demo4'

  if ! [ -z $1 ]; then
    env_name=$1
  fi

 
  env_file=~/.agentiq/$env_name.env
  if [[ -f "$env_file" ]]; then
    source $env_file
    echo Set environment to $ENVIRONMENT
  else
    echo $env_file does not exist. 
    return 1
  fi
}

function csv() {
  service='base-api'

  if ! [ -z $1 ]; then
    service=$1
  fi

  # substitute hipen to underscore
  service=${service//-/_}
  # capitalize
  service=${service:u}

  # Get Db config by name
  eval host=$(echo $"${service}_DB_HOST")
  eval username=$(echo $"${service}_DB_USERNAME")
  eval dbname=$(echo $"${service}_DB_NAME")
  eval password=$(echo $"${service}_DB_PASSWORD")

  PGPASSWORD=$password psql -h $host -U $username $dbname -t -A -F"," -c "$2" > $3
}

function connectredis() {
  redis-cli -h $REDIS_HOST
}

function syncenv() {
  aws s3 sync s3://agentiq-developer-secrets/env ~/.agentiq
}

function download_robot() {
  echo "Fetching the most recent robot test"
  s3_dir_name=$(aws s3 ls s3://agentiq-jenkins-builds/TestAutomationSuite/demo4/ \
    | awk '{print $2 " " $3}' \
    | grep -P "\d\d-\d\d-\d\d\d\d*" --color=never \
    | sort -k 1.7,1.10 -k 1,1 -k 2,2 -r \
    | head -n 1)

  if [ -z $1 ]; then
    downloading_path="."
  else
    downloading_path=$1
  fi
  downloading_path=$downloading_path/$s3_dir_name

  echo "Downloading s3://agentiq-jenkins-builds/TestAutomationSuite/demo4/$s3_dir_name to $downloading_path"
  aws s3 sync "s3://agentiq-jenkins-builds/TestAutomationSuite/demo4/$s3_dir_name" $downloading_path
}

function login_docker() {
  aws ecr get-login-password | docker login --username AWS --password-stdin http://036978135238.dkr.ecr.us-east-1.amazonaws.com/
  #aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 036978135238.dkr.ecr.us-east-1.amazonaws.com
}

function activate() {
  # added export due to M2 chip
  # https://github.com/pyenchant/pyenchant/issues/265
  export PYENCHANT_LIBRARY_PATH=/opt/homebrew/lib/libenchant-2.dylib
  source .venv/bin/activate
}

function speed() {
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
}

# temp sdk generater
function sdk() {
  # mac
  find . -name \*.html | sed 's/.html$//g' | xargs -n1 -IX wkhtmltopdf  --enable-local-file-access X.html X.pdf

  # Ubuntu
  #find . -name \*.html | sed 's/.html$//g' | xargs -n 1 --replace=X wkhtmltopdf X.html X.pdf
  #pdftk index.pdf WebchatSDK.pdf WebchatEvent.pdf global.pdf cat output webchat_sdk.pdf
}

function getEnvs() {
  # do staging
  aws ssm get-parameters --name "/aiq/environments/master" --query "Parameters[0].Value" --output text| tr _ -
}

function testAIengine() {
  # dispatch
  #payload1='{ "conversation_id": 191876, "payload": { "flow": { "name": "init_customer_dispatch", "unit_type": "workflow" } }, "conversation": { "id": 191876, "customer": { "id": 2209, "profile": { "last_name": "", "first_name": "" }, "primaryAgent": null }, "locked_by": null } }'
  payload1='{"id":400283,"conversation_id":212732,"sender_id":192250,"sender_type":"customers","payload":{"ref":1718228209790,"reply":{"content":"Something Else","postback":{"payload":"{\"index\": 5, \"value\": \"Something Else\"}","reply_to":400279}},"doNotRespond":false,"message_type":"reply"},"created_at":"2024-06-12T21:36:49.862Z","updated_at":"2024-06-12T21:36:49.862Z","metadata":{"user_agent":"Mozilla5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit605.1.15 (KHTML, like Gecko) Mobile15E148","customer_origin":"174.85.136.218"},"channel":"webchat","event":false,"obfuscated":false,"customer_id":192250,"bot":false,"deleted_at":null,"deleted_by":null,"conversation":{"id":212732,"customer_id":192250,"status":"active","importance":null,"sentiment":null,"entities":null,"bot_status":"enabled","created_at":"2024-06-12T21:36:41.987Z","updated_at":"2024-06-12T21:36:43.425Z","used_by":null,"channel":"webchat","ai_state":{"debug":null,"entities":[{"name":"customer.ssn","resolved_value":"422516742"},{"name":"customer.email","resolved_value":"NITIRAHG@ICLOUD.COM"},{"name":"customer_email","resolved_value":"NITIRAHG@ICLOUD.COM"},{"name":"customer.phone","resolved_value":"3342029988"},{"name":"customer.locale","resolved_value":"en-US"},{"name":"customer.group_id","resolved_value":"1"},{"name":"customer.user_cif","resolved_value":"572333"},{"name":"customer.container","resolved_value":"app"},{"name":"customer.last_name","resolved_value":"GLASCO"},{"name":"customer.first_name","resolved_value":"NITIRAH"},{"name":"customer.group_desc","resolved_value":"Retail Consumer Users"},{"name":"customer.is_company","resolved_value":"N"},{"name":"customer.external_id","resolved_value":"251541"},{"name":"customer.primary_cif","resolved_value":"572333"},{"name":"customer.language_code","resolved_value":"en"},{"name":"customer.customer_segment","resolved_value":"{1},{authenticated}"},{"name":"customer.full_name","resolved_value":"NITIRAH GLASCO"},{"name":"customer_name","resolved_value":"NITIRAH GLASCO"},{"name":"conversation.id","resolved_value":"212732"},{"name":"conversation_id","resolved_value":"212732"}],"dialog_id":64,"ai_history":{"events":[{"flow_run":[["workflow","init_customer_dispatch","MAIN",null],["dialog","aiq_init_dispatch_customer_segment","SUCCESS","[]"],["dialog","auth_topic_flow","ASK_ENTITY",null]],"dialog_run":[["aiq_init_dispatch_customer_segment","SUCCESS"],["auth_topic_flow","ASK_ENTITY"]],"message_id":null,"matched_type":null,"workflow_run":[["init_customer_dispatch","MAIN"]],"matched_intent":null,"spacy_entities":[]}],"obsolete_entities":[{"name":"customer_segment","extras":{"model":"tagger"},"resolved_value":"{1},{authenticated}"}]},"dialog_state":3,"post_actions":[{"id":9,"name":"init_customer_dispatch","payload":null,"unit_type":"internal_workflow_end"}],"dialog_skipped":null,"current_workflow_stack":[9],"entity_idx_to_be_updated":null,"number_of_alternative_asks":0},"payload":{},"closed_at":null,"queued":false,"resolved_status":null,"metadata":{},"customer":{"id":192250,"identities":{"uuids":[{"uuid":"3caf8d6d-7893-4c03-a88c-809e96523cc1"}],"external_id":"251541"},"profile":{"dob":"","ssn":"422516742","email":"NITIRAHG@ICLOUD.COM","phone":"3342029988","locale":"en-US","accounts":["S0001, Primary Share(DVW)","S0010, Explore Checking(DVW)"],"group_id":"1","user_cif":"572333","container":"app","last_name":"GLASCO","member_id":"","first_name":"NITIRAH","group_desc":"Retail Consumer Users","is_company":"N","customer_id":239566,"external_id":"251541","primary_cif":"572333","customer_name":"","language_code":"en","member_number":"","customer_segment":"{1},{authenticated}"},"channels":[],"created_at":"2024-06-12T21:36:41.912Z","updated_at":"2024-06-12T21:36:49.833Z","muted":false,"connected":true,"connected_updated_at":"2024-06-12T21:36:42.521Z","primary_agent":null,"history":{"onboard":[]},"primaryAgent":null,"fullName":"NITIRAH GLASCO","identified":true},"locked_by":{"id":2,"email":"bot@agentiq.com","profile":{"location":"","last_name":"Assistant","first_name":"Virtual","external_id":""},"created_at":"2024-02-16T15:18:08.139Z","updated_at":"2024-02-21T23:34:11.504Z","available":"away","connected":false,"connected_at":null,"disconnected_at":null,"max_load":0,"deleted_at":null,"auth0_user_id":null,"busy_status":{"status":"","vacation":{"message_to_customer":""}},"disclaimers":{"default":""},"concurrent_capacity":0,"inactivity":{"enabled":false,"duration":0},"hidden":false,"fullName":"Virtual Assistant","canLock":true,"maxLock":-1}},"sender":{"id":192250,"identities":{"uuids":[{"uuid":"3caf8d6d-7893-4c03-a88c-809e96523cc1"}],"external_id":"251541"},"profile":{"dob":"","ssn":"422516742","email":"NITIRAHG@ICLOUD.COM","phone":"3342029988","locale":"en-US","accounts":["S0001, Primary Share(DVW)","S0010, Explore Checking(DVW)"],"group_id":"1","user_cif":"572333","container":"app","last_name":"GLASCO","member_id":"","first_name":"NITIRAH","group_desc":"Retail Consumer Users","is_company":"N","customer_id":239566,"external_id":"251541","primary_cif":"572333","customer_name":"","language_code":"en","member_number":"","customer_segment":"{1},{authenticated}"},"channels":[],"created_at":"2024-06-12T21:36:41.912Z","updated_at":"2024-06-12T21:36:49.833Z","muted":false,"connected":true,"connected_updated_at":"2024-06-12T21:36:42.521Z","primary_agent":null,"history":{"onboard":[]},"fullName":"NITIRAH GLASCO","identified":true}}'

  # message
  payload2='{ "conversation_id": 2959, "payload": { "flow": { "name": "init_customer_dispatch", "unit_type": "workflow" } }, "conversation": { "id": 2959, "customer": { "id": 2209, "profile": { "last_name": "", "first_name": "" }, "primaryAgent": null }, "locked_by": null } }'

  autocannon -m POST --header 'Content-Type: application/json' -b $payload1 http://127.0.0.1:5000/conversation -d 360 -w 1 -c 5
  #autocannon --debug -m POST --header 'Content-Type: application/json' -b $payload1 https://127.0.0.1:500/conversation -a 100
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# TODO: Fetch from online
# aws ssm get-parameters --name "/aiq/environments/master" --query "Parameters[0].Value" --output text| tr _ -
#envs=("bac-uat" "bil-uat" "bmo-uat" "bankfirst-uat" "bankofutah-uat" "commerce-uat" "comsavings-uat" "cusol-uat" "decorah-uat" "dreamfirst-uat" "extraco-uat" "fab-uat" "fabandt-uat" "freedomfcu-uat" "imcu-uat" "legacyar-uat" "merc-uat" "mymax-uat" "nicolet-uat" "omb-uat" "pcfcu-uat" "pbc-uat" "pfbancorp-uat" "pnb-uat" "rockland-uat" "sfcu-uat" "texasfirst-uat" "demo1-uat")
envs=("bac" "bil" "bmo" "bankfirst" "bankofutah" "commerce" "comsavings" "cusol" "decorah" "dreamfirst" "extraco" "fab" "fabandt" "freedomfcu" "imcu" "legacyar" "merc" "mymax" "nicolet" "omb" "partner" "pcfcu" "pbc" "pfbancorp" "pnb" "rockland" "sfcu" "texasfirst" "demo1")

# ai-engine
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENCHANT_LIBRARY_PATH=/opt/homebrew/Cellar/enchant/2.8.6/lib/libenchant-2.dylib
export PYENCHANT_LIBRARY_PATH=/opt/homebrew/lib/libenchant-2.dylib

# postgres
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Alias
alias timeout=gtimeout
#alias python3=python3.12
#alias python=python3.12
export PYTHON=/Library/Frameworks/Python.framework/Versions/3.12/bin/python3.12

export ABE_SECRET=U28XCj47cwmsABGu
export FONTAWESOME_NPM_AUTH_TOKEN=F1924DED-3380-430D-B790-5E21452EADA1
alias v=nvim

# AI Keys
#
alias vi="nvim"
# use python 3.12 by default to use sgpt
pyenv activate py12
alias ai="sgpt"
alias claude="/Users/jaekwanlee/.claude/local/claude"

# Added by Antigravity
export PATH="/Users/jaekwanlee/.antigravity/antigravity/bin:$PATH"

. "$HOME/.local/bin/env"
