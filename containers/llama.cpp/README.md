# llama.cpp

llama.cpp is a pretty performant LLM runtime that various Ollama implementations are based on.

However, you may run into Arm64 issues with how it's built using older versions of the C toolchain.

The only good way to fix this...is to build your own llama.cpp container.  We can adapt their build process with minimal changes to include the newer packages needed and sourcing for the project to build in a different context.

Their Dockerfile emits different versions of the final image - a full image, slim CLI-only option, as well as a server-only option.  The different stages are emitted in this custom Dockerfile as well in case you were wanting to base a rebuild of something like Llama Swap on it.

> See [Dockerfile](./Dockerfile) for more info