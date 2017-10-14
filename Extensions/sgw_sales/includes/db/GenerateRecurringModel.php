<?php
namespace SGW_Sales\db;

require_once(__DIR__ . '/../common/DataMapper.php');

use SGW\common\DataMapper;

class GenerateRecurringModel {

	public function __construct() {
		$this->_mapper = DataMapper::createByClass(TB_PREF, $this);
	}
	
	/**
	 * @var DataMapper
	 */
	public $_mapper;
	
	public $orderNo;
	public $reference;
	public $name;
	public $brName;
	
	public $dtStart;
	public $dtEnd;
	public $dtLast;
	public $dtNext;
	public $auto;
	public $repeats;
	public $every;
	public $occur;
	
}
