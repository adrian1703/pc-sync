# Deepseek Ollama setup 

## Intended install 
- have llm and llm-ollama installed 
- run ollama docker
- install model using `deepseekcode.bash`

## rootless mode 
Have not yet figured out rootless mode in podman
so the compose file **does not work**
```
alias ollama-up='\
  sudo podman podman run -d \
  --name ollama \
  -p 11434:11434 \
  --gpus all \
  -v ollama_data:/root/.ollama \
  ollama/ollama'
alias ollama-down='sudo podman rm -f ollama'
alias ollama-logs='sudo podman logs -f ollama'
```


## deepseekcode.bash 
Issues a curl request to install deepseek-code model 
from Ollama Library.
