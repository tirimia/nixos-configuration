{inputs, ...}: {
  flake.modules.homeManager.emacs = {...}: {
    imports = [
      inputs.self.modules.homeManager.emacs-core
      inputs.self.modules.homeManager.emacs-tree-sitter-grammars
      inputs.self.modules.homeManager.emacs-typescript
      inputs.self.modules.homeManager.emacs-rust
      inputs.self.modules.homeManager.emacs-elixir
      inputs.self.modules.homeManager.emacs-go
      inputs.self.modules.homeManager.emacs-yaml
      inputs.self.modules.homeManager.emacs-haskell
      inputs.self.modules.homeManager.emacs-nushell
    ];
  };
}
