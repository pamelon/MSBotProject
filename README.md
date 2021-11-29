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



## Proactive messaging

> Note: Before reinventing the wheel, have a look at [Microsoft Viva](https://www.microsoft.com/en-us/microsoft-viva) an end-to-end employee experience offering. In [this adaptive card community call](https://techcommunity.microsoft.com/t5/microsoft-365-pnp-blog/adaptive-cards-community-call-june-2021/ba-p/2533826) the team is showing proactive notifications.

The general idea of the proactive bots is that you store a reference to the end user, usually during the original discussion initiation and then you use that dialog reference to get back to the user from an asynchronous process.
[This article](https://docs.microsoft.com/en-us/azure/bot-service/bot-builder-howto-proactive-message?view=azure-bot-service-4.0&tabs=csharp) gives the main points and there is a code sample for teams specifically which will be easier to implement compared to a stateless web chat. See [how to send a proactive message in teams](https://docs.microsoft.com/en-us/microsoftteams/platform/bots/how-to/conversations/send-proactive-messages?tabs=dotnet) for an overview and various code samples. Another great resource is [the github issue notification bot](https://github.com/microsoft/botframework-sdk/tree/main/dri/issueNotificationBot). In that code, you will see that the [“OnTeamsMembersAddedAsync” event is captured](https://github.com/microsoft/botframework-sdk/blob/main/dri/issueNotificationBot/Bot/Bots/IssueNotificationBot.cs). Then the [TurnContext is converted into ConversationReference](https://github.com/microsoft/botframework-sdk/blob/d1f42e8156a733d4ef4f626ffe0886eae155662c/dri/issueNotificationBot/Bot/Bots/SignInBot.cs#L220), which is then used to [start a new personal conversation](https://github.com/microsoft/botframework-sdk/blob/d1f42e8156a733d4ef4f626ffe0886eae155662c/dri/issueNotificationBot/Bot/Services/NotificationHelper.cs#L94). You can register that bot to everyone in the company [through a policy](https://github.com/OfficeDev/Microsoft-Teams-Samples/tree/main/samples/graph-proactive-installation/csharp) and your code will have to store the dialog reference for every user in a database.

## Resources
- [Floating button](https://github.com/n01d/BotFramework-FloatingWebChat/blob/master/index.html)
- [Power Virtual Agent, PVA](https://powervirtualagents.microsoft.com/en-us/)
- [Bot Framework Composer](https://docs.microsoft.com/en-us/composer/introduction)
- [Bot Framework Virtual Assistant](http://aka.ms/virtualassistant)
- [Microsoft Azure Virtual Training Day: AI Fundamentals](https://www.microsoft.com/en-ie/training-days/azure/ai-fundamentals) for free AI 100 exam voucher.
- [Teams bot - icebreaker](https://github.com/OfficeDev/microsoft-teams-apps-icebreaker)
