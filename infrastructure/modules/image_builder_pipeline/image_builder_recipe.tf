locals {
  recipe_version = "1.1.0"
}


resource "aws_imagebuilder_image_recipe" "image_builder" {
  component {
    component_arn = aws_imagebuilder_component.update_dependencies.arn
  }

  component {
    component_arn = aws_imagebuilder_component.install_docker.arn
  }

  name         = "${var.project_name}-${var.environment}"
  parent_image = "arn:aws:imagebuilder:${data.aws_region.current.name}:aws:image/${var.base_image}/x.x.x"
  version      = local.recipe_version

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_imagebuilder_component" "update_dependencies" {
  #checkov:skip=CKV_AWS_180:Ensure Image Builder component is encrypted by KMS using a customer managed Key (CMK)
  name     = "UpdateDeps"
  platform = "Linux"
  version  = local.recipe_version

  data = yamlencode({
    name          = "UpdateDeps"
    schemaVersion = "1.0"
    phases = [
      {
        name = "build"
        steps = [{
          name   = "UpdateDeps"
          action = "ExecuteBash"
          inputs = {
            commands = [
              "sudo apt update",
              "sudo apt upgrade --yes",
              "sudo apt install --yes bash git ca-certificates"
            ]
          }
        }]
      },
      {
        name = "validate"
        steps = [{
          name   = "ValidateGitVersion"
          action = "ExecuteBash"
          inputs = {
            commands = [
              "git --version"
            ]
          }
        }]
      }
    ]
  })
}

resource "aws_imagebuilder_component" "install_docker" {
  #checkov:skip=CKV_AWS_180:Ensure Image Builder component is encrypted by KMS using a customer managed Key (CMK)
  name     = "InstallDocker"
  platform = "Linux"
  version  = local.recipe_version

  data = yamlencode({
    name          = "InstallDocker"
    schemaVersion = "1.0"
    phases = [
      {
        name = "build"
        steps = [
          {
            name   = "InstallDocker"
            action = "ExecuteBash"
            inputs = {
              commands = [
                "sudo apt-get update",
                "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",
                "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
                "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
                "sudo apt-get update",
                "sudo apt-get install --yes docker-ce docker-ce-cli containerd.io"
              ]
            }
          },
          {
            name   = "PostInstallDocker"
            action = "ExecuteBash"
            inputs = {
              commands = [
                "sudo usermod -aG docker ubuntu",
                "sudo systemctl enable docker",
                "sudo systemctl start docker"
              ]
            }
          }
        ]
      },
      {
        name = "validate"
        steps = [{
          name   = "ValidateGitVersion"
          action = "ExecuteBash"
          inputs = {
            commands = [
              "docker --version"
            ]
          }
        }]
      },
      {
        name = "test"
        steps = [
          {
            name   = "TestDockerHelloWorld"
            action = "ExecuteBash"
            inputs = {
              commands = [
                "docker run hello-world"
              ]
            }
          }
        ]
      }
    ]
  })
}
