# MSBotProject

This is a project to demo how to build an MVP of a Bot for power users with slight dev experience. The bot will named [Just A Rather Very Intelligent System (J.A.R.V.I.S.)](https://ironman.fandom.com/wiki/J.A.R.V.I.S.).

## Folder structure

- Root
  - devops
    - IaC : Arm templates and scripts to deploy Azure resource
    - pipelines: Azure DevOps pipelines to deploy bots (if you want to do in Github, use .github/workflows/)
  - src  
    - Jarvis : Botcomposer main project
    - Channels
      - WebHostingApp
      - MobileHostApp
      - TeamsHostApp
  - tests

## Instruction

- Install
  - Bot Composer (https://github.com/microsoft/BotFramework-Composer/releases/tag/v2.0.0) which also needs [node.js](https://nodejs.org/en/download/) and [.NET Core SDK](https://dotnet.microsoft.com/download/dotnet/3.1)
  - Bot Emulator (https://github.com/Microsoft/BotFramework-Emulator/releases/tag/v4.13.0)
  - Visual Studio Code (https://code.visualstudio.com/Download) and [Git](https://git-scm.com/)


## Cloning repo

If this is the first time you install git you will need to configure your commit identity on git using the following commands:
```dotnetcli
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
```

> Tip: Use your github email to avoid being spammed which is handle@users.noreply.github.com

In VSCode hit `cntl+shift+P` to open command palette and type `clone` to select the git clone command.

## Bot composer learning links

- 

## Resources
- [Floating button](https://github.com/n01d/BotFramework-FloatingWebChat/blob/master/index.html)
