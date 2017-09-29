<?php
namespace SGW_Sales\db;

require_once(__DIR__ . '/../common/DataMapper.php');

use SGW\common\DataMapper;

class SalesRecurringModel {

	public function __construct() {
		$this->_mapper = DataMapper::createByClass(TB_PREF, $this);
	}
	
	/**
	 * @var DataMapper
	 */
	public $_mapper;
	
	const REPEAT_YEARLY  = 'year';
	const REPEAT_MONTHLY = 'month';
	
	public $id;
	public $transNo;
	
	public $dtStart;
	public $dtEnd;
	public $dtNext;
	public $auto;
	public $repeats;
	public $every;
	public $occur;
	
// 	public function write() {
// 		$this->mapper->write($this);
// 	}

}

// $m = new RecurringModel();
// $d = DataMapper::createByClass('0_', $m);
// $d->write($m);