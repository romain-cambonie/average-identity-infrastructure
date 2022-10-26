//data "aws_iam_role" "cognito_sns_publisher" {
//  name = "PublisherRoleForCognitoSns"
//}

//resource "aws_cognito_user_pool" "average_pool" {
//  name                       = "average-pool"
//  mfa_configuration          = "ON"
//  sms_authentication_message = "Votre code d'authentification est {####}"
//  sms_verification_message   = "Votre identifiant est {username} et votre code temporaire est {####}"
//  alias_attributes           = ["phone_number"]
//
//  auto_verified_attributes = ["phone_number"]
//
//  sms_configuration {
//    external_id    = "cognito-sns-publisher-role"
//    sns_caller_arn = data.aws_iam_role.cognito_sns_publisher.arn
//  }
//
//  admin_create_user_config {
//    allow_admin_create_user_only = true
//    invite_message_template {
//      email_subject = "Votre compte Average"
//      email_message = "Bienvenue chez Average {username} !<br><br> Votre code temporaire est le {####}.<br><a>Se connecter ici</a>"
//      sms_message   = "Bienvenue chez Average {username} ! Votre code temporaire est le {####}"
//    }
//  }
//
//  username_configuration {
//    case_sensitive = false
//  }
//
//  device_configuration {
//    challenge_required_on_new_device      = true
//    device_only_remembered_on_user_prompt = false
//  }
//
//  software_token_mfa_configuration {
//    enabled = true
//  }
//
//  password_policy {
//    minimum_length                   = 8
//    temporary_password_validity_days = 2
//  }
//
//  schema {
//    name                = "phone_number"
//    attribute_data_type = "String"
//    mutable             = true
//    required            = true
//    string_attribute_constraints {
//      min_length = 12
//      max_length = 12
//    }
//  }
//
//  tags = local.tags
//}

//resource "aws_cognito_user_pool_client" "client" {
//  name                                 = "user-pool-app-client"
//  user_pool_id                         = aws_cognito_user_pool.driver_pool.id
//  allowed_oauth_flows                  = ["code"]
//  allowed_oauth_scopes                 = ["phone", "openid"]
//  allowed_oauth_flows_user_pool_client = true
//  supported_identity_providers         = ["COGNITO"]
//  callback_urls                        = ["https://driver.${local.domainName}/"]
//  access_token_validity                = 5
//  id_token_validity                    = 5
//  refresh_token_validity               = 1
//  token_validity_units {
//    access_token  = "minutes"
//    id_token      = "minutes"
//    refresh_token = "days"
//  }
//  explicit_auth_flows = [
//    "ALLOW_REFRESH_TOKEN_AUTH",
//    "ALLOW_USER_PASSWORD_AUTH"
//  ]
//}

resource "aws_cognito_user_pool" "average_pool" {
  name = "average_pool"
  tags = local.tags
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                                 = "average-client"
  user_pool_id                         = aws_cognito_user_pool.average_pool.id
  callback_urls                        = ["https://average.thunder-arrow.cloud/account"]  //https://${join(".", [local.service.average.name, local.hostingZone.name])}
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["phone","email", "openid"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "average_domain" {
  domain       = "auth-average"
  user_pool_id = aws_cognito_user_pool.average_pool.id
}
