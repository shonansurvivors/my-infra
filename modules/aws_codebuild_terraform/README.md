## Before you create aws_codebuild_webhook,

Connect using OAuth or with a GitHub personal access token.

See https://docs.aws.amazon.com/ja_jp/codebuild/latest/userguide/access-tokens.html

### 1. OAuth

- Edit the CodeBuild project source
- Choosing `Connect using OAuth`, Enter `Coonect to GitHub` button

```
aws codebuild --profile your_profile list-source-credentials
```

```json
{
  "sourceCredentialsInfos": [
    {
      "arn": "arn:aws:codebuild:region:account_id:token/github",
      "serverType": "GITHUB",
      "authType": "OAuth"
    }
  ]
}
```

- Choose `Repository in my GitHub account`
- Choose your GitHub repository 

```
./terraform.sh env dir apply
```

### 2. GitHub personal access token

```
aws codebuild import-source-credentials --generate-cli-skeleton > ~/import-source-credentials.json
```

Edit `~/import-source-credentials.json`.

- username: Ignore.
- authType: Only `PERSONAL_ACCESS_TOKEN` with CLI. `OAUTH` can be select with console.

```json
{
    "username": "foobar",
    "token": "your github personal access token",
    "serverType": "GITHUB",
    "authType": "PERSONAL_ACCESS_TOKEN",
    "shouldOverwrite": true
}
```

```
aws codebuild --profile your_profile import-source-credentials --cli-input-json file://~/import-source-credentials.json
```

```json
{
    "arn": "arn:aws:codebuild:region:account_id:token/github"
}
```

```
aws codebuild --profile your_profile list-source-credentials
```

```json
{
  "sourceCredentialsInfos": [
    {
      "arn": "arn:aws:codebuild:region:account_id:token/github",
      "serverType": "GITHUB",
      "authType": "PERSONAL_ACCESS_TOKEN"
    }
  ]
}
```

```
rm ~/import-source-credentials.json
```

## Before run aws_codebuild_webhook,

Set GitHub personal access token for [tfnotify](https://github.com/mercari/tfnotify).

```
aws ssm --profile your_profile put-parameter \
  --name /github/your_github_user_name/personal_access_token \
  --type "SecureString" \
  --value your_pesonal_access_token
```
