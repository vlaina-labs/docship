只需一行命令就可以构建主流静态网站


放到 .github/workflows/deploy.yml 即可
```
name: Deploy

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  deploy:
    uses: NekoTick/docship/.github/workflows/docusaurus.yml@main

```


<img width="342" height="116" alt="image" src="https://github.com/user-attachments/assets/11c19407-73af-4375-95d0-c561924388b2" />
