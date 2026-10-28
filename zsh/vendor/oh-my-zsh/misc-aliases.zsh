alias _='sudo '

## more intelligent acking for ubuntu users and no alias for users without ack
if (( $+commands[ack-grep] )); then
  alias afind='ack-grep -il'
elif (( $+commands[ack] )); then
  alias afind='ack -il'
fi
