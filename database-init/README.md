# Custom container init

In this `database-init` folder, you can add `.sh`, `.sql` and `.sql.gz` files. They will be executed by the container at the end of its init.

Files are executed in the **alphabetical** order.

`.sql` files will be executed and queries will be run against the database defined via `MYSQL_DATABASE`. If you run the `container-utils.sh` script, it's all already defined.