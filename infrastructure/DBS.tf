module "db" {
  snapshot_identifier = var.snapshotid == "" ? null : var.snapshotid

  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier            = var.dbname
  copy_tags_to_snapshot = true
  publicly_accessible   = false


  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.dbsize
  allocated_storage = var.storage

  name     = var.dbname
  username = var.dbuser
  password = var.dbpassword
  port     = "3306"

  iam_database_authentication_enabled = false

  vpc_security_group_ids = [aws_security_group.rds-sg.id]

  maintenance_window = "Sun:00:00-Sun:02:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = var.monint
  monitoring_role_name   = var.monrole
  create_monitoring_role = var.monitor_role

  tags = var.user_tags

  # DB subnet group
  subnet_ids = aws_subnet.private.*.id

  # DB parameter group
  family = "${var.engine}${var.maj_eng_ver}"

  # DB option group
  major_engine_version = var.maj_eng_ver

  #DB multi availability zone
  multi_az = var.multi_az

  # Snapshot name upon DB deletion
  final_snapshot_identifier = var.dbname

  # Database Deletion Protection
  deletion_protection = var.protect

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
