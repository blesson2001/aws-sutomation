aws iam create-user --user-name kimo --permissions-boundary arn:aws:iam::aws:policy/AdministratorAccess --tags Key=Name,Value=kimo

aws iam create-access-key --user-name kimo

aws iam create-login-profile --user-name kimo --password '&0Zflkuwzy' --no-password-reset-required
