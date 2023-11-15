
resource "aws_emr_cluster" "cluster" {
  name          = "${var.project_name}-emr-cluster"
  release_label = "emr-6.7.0"
  applications  = [ "Spark"]

  termination_protection            = false
  keep_job_flow_alive_when_no_steps = false
  log_uri                           = "s3://${var.bucket_emr}/logs/"

  service_role = var.iam_emr_arn

  ec2_attributes {
    instance_profile = var.iam_instance_profile_ec2
  }


  master_instance_group {
    instance_type = "m4.large"
  }

  core_instance_group {
    instance_type  = "m4.large"
    instance_count = 1
  }

  bootstrap_action {
    name = "Instala pacotes python adicionais"
    path = "s3://${var.bucket_emr}/config/bootstrap_actions.sh"
  }

  step = [
    {
      name              = "Copia arquivos de python para maquinas EC2"
      action_on_failure = "TERMINATE_CLUSTER"

      hadoop_jar_step = [
        {
          jar        = "command-runner.jar"
          args       = ["aws", "s3", "cp", "s3://${var.bucket_emr}", "/home/hadoop/python/", "--recursive"]
          main_class = ""
          properties = {}
        }
      ]
    },
    {
      name              = "Executa scripts python"
      action_on_failure = "TERMINATE_CLUSTER"

      hadoop_jar_step = [
        {
          jar        = "command-runner.jar"
          args       = ["spark-submit", "/home/hadoop/python/main.py"]
          main_class = ""
          properties = {}
        }
      ]
    }
  ]

  depends_on = [var.bucket-emr-python-file, var.bucket-emr-config-file-bucket-names, var.bucket-emr-config-file, var.bucket-emr-logs]

}