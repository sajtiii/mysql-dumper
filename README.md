# MySQL Dumper

## Usage:
With cosmer compose file:
```yaml
dumper:
  build:
    context: .
  environment:
    - DB_HOST=mysql
    - DB_PORT=3306
    - DB_USERNAME=root
    - DB_PASSWORD=root
  volumes:
    - ./dumps:/dumps
```

Optionally you can scecify the `ONCE=true` environment variable to run the dump only once and disable the cronjob.

If you'd like to run the container on schedule, you can specify it with the `SCHEDULE` environment variable ex.: `SCHEDULE=0 4 * * *` runs the dumper every day at 04:00.