<?php if ( ! defined( 'KISS' ) ) exit;

$conf['index_page'] = 'index.php?';
$conf['sitename'] = 'Company - MunkiReport';
$conf['allow_migrations'] = FALSE;
$conf['debug'] = TRUE;
$conf['timezone'] = @date_default_timezone_get(America/Chicago);
$conf['vnc_link'] = "vnc://%s:5900";
$conf['ssh_link'] = "ssh://ladmin@%s";
ini_set('session.cookie_lifetime', 43200);
$conf['locale'] = 'en_US';
$conf['lang'] = 'en';
$conf['keep_previous_displays'] = TRUE;

/*
|===============================================
| Authorized Users of Munki Report
|===============================================
| Visit http://yourserver.example.com/report/index.php?/auth/generate to generate additional local values
*/
$auth_config['root'] = '$P$BUqxGuzR2VfbSvOtjxlwsHTLIMTmuw0'; // Password is root

/*
|===============================================
| PDO Datasource
|===============================================
*/
$conf['pdo_dsn'] = 'mysql:host=localhost;dbname=munkireport';
$conf['pdo_user'] = 'munki';
$conf['pdo_pass'] = 'munki';
$conf['pdo_opts'] = array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8');