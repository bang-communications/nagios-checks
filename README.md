# nagios-checks
A few custom Nagios checks written by Bang


##  check_warn

A wrapper around other checks that turns errors into warnings.

```bash
/path/to/check_warn /path/to/check_something params
```


## check_regular

A wrapper around other checks that may take too long to run or be too
intensive to run every time. It stores the result of the test in /tmp,
and if necessary spawns that task in the background so its results can 
be picked up later.

```bash
/path/to/check_regular /path/to/check_something params
```


## check_wp_version

Read the file wp-includes/version.php to make sure WordPress is up to date.
This relies on your sites being stored in a regular location on disk.

```bash
/path/to/check_wp_version sitename
```

Configure this by setting the version variables and the site location variable.

```bash
WARNING_VERSION="4.2.2"
CRITICAL_VERSION="4.1.2"
HTDOCS=/var/www/"$SITE"/htdocs
```


## check_drupal_version

Read the file includes/bootstrap.inc to make sure Drupal is up to date.
This relies on your sites being stored in a regular location on disk.

```bash
/path/to/check_drupal_version sitename
```

Configure this by setting the version variables and the site location variable.

```bash
WARNING_VERSION="7.36"
CRITICAL_VERSION="7.0"
HTDOCS=/var/www/"$SITE"/htdocs
```


## check_permissions

Make sure there are no files anyway that are world writable
Saves the complete list into `/tmp/nagios-world-writable.log`.

```bash
/path/to/check_permissions
```

