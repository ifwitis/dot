**Powerlevel10k with oh-my-zsh**
1. Download oh-my-zsh
```
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

2. Copy .p10k.zsh and .zshrc into home directory
3. Configure oh-my-zsh with Powerlevel10k theme
```
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```
4. Restart zsh
```
    exec zsh
```
