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
