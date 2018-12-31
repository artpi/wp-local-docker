<?php

class Airtable {
	private $token;
	function __construct( $token = "" ) {
		$this->token = $token;
	}

	function request( $url, $payload = array(), $method = 'GET' ) {
		$opts = array(
			'http'=>array(
				'method'=>$method,
				'header'=>"Authorization: Bearer {$this->token}\r\nContent-Type: application/json"
			)
		);
		if( $payload ) {
			$opts['http']['content'] = json_encode( $payload );
		}

		$context = stream_context_create($opts );
		$file = file_get_contents( $url, false, $context );
		return json_decode( $file );
	}

	function update( $url, $data ) {
		$result = $this->request( $url, array( 'fields'=>$data ), 'PATCH' );
		foreach ( $data as $key => $value ) {
			if ( $result->fields->{$key} !== $value ) {
				return false;
			}
		}
		return true;
	}

	function get_cached_data( $url ) {
		$name = 'airtable_' . md5( $url );
		$cache = get_transient( $name );
		if ( $cache ) {
			return $cache;
		}
		$data = $this->request( $url );
		set_transient( $name, $data, 60 * 10 );
		return $data;
	}
}
