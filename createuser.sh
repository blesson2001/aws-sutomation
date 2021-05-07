aws iam create-user --user-name kimo --permissions-boundary arn:aws:iam::aws:policy/AdministratorAccess --tags Key=Name,Value=kimo

aws iam create-access-key --user-name kimo

aws iam create-login-profile --generate-cli-skeleton > cat < create-login-profile.json  <<EOF
{
    "UserName": "kimo",
    "Password": "&0Zflkuwzy",
    "PasswordResetRequired": false
}
EOF
