<?php
/**********************************************
Author: Andres Amaya
Name: REST API Utils
Free software under GNU GPL
***********************************************/

function api_login() {
	$app = \Slim\Slim::getInstance('SASYS');
	$app->hook('slim.before', function () use ($app) {
		$req = $app->request();
		$company = $req->headers('X-COMPANY');
		$user = $req->headers('X-USER');
		$password = $req->headers('X-PASSWORD');

		// TESTING
		/*$company = 0;
		$user = 'admin';
		$password = '123';*/

		$succeed = $_SESSION["wa_current_user"]->login($company,
					$user, $password);
		if(!$succeed) {
			$app->halt(403, 'Bad Login For Company: ' . $company . ' With User: ' . $user);
		}
	}, 1);
}

function api_response($code, $body) {
	$app = \Slim\Slim::getInstance('SASYS');
	$app->response()->status($code);
	$app->response()->body($body);
}

function api_success_response($body) {
	$app = \Slim\Slim::getInstance('SASYS');
	$app->response()->status(200);
	$app->response()->body($body);
	//$app->response()->['Content-Type'] = $content_type;
}

function api_create_response($body) {
	$app = \Slim\Slim::getInstance('SASYS');
	$app->response()->status(201);
	$app->response()->body($body);
	//$app->response()->['Content-Type'] = $content_type;
}

function api_error($code, $msg) {
	$app = \Slim\Slim::getInstance('SASYS');
	$app->halt($code, json_encode(array('success' => 0, 'msg' => $msg)));

}

function api_ensureAssociativeArray($a) {
	if (!$a) {
		$a = array();
	}
	foreach ($a as $key => $value) {
		if (is_int($key)) {
			unset($a[$key]);
		}
	}
	return $a;
}

?>