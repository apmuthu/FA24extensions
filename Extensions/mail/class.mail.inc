<?php
// Replacement class.mail.inc for FA 2.4.x
// https://github.com/PHPMailer/PHPMailer/releases/tag/v5.2.28
// https://github.com/serbanconstantinescu/fa_mail_phpmailer

include_once($path_to_root . "/modules/mail/includes/PHPMailer/class.smtp.php");
include_once($path_to_root . "/modules/mail/includes/PHPMailer/class.phpmailer.php");

class email {
	public $phpmailer = null;
	public $charset = 'ISO-8859-1';

	public function __construct($name, $email) {
		//create phpmailer object
		$this->phpmailer = new PHPMailer;

		//set from
		$this->phpmailer->setFrom($email, $name);

		//setup bcc if one is set
		$bcc = get_company_pref('bcc_email');
		if ($bcc)
			$this->phpmailer->addBCC($bcc);


		//Tell PHPMailer what to use: php's mail or smtp
		$_mail_type = get_company_pref('mail_type');
		switch($_mail_type) {
			case 'SMTP':
				$this->phpmailer->isSMTP();
				break;
			case 'MAIL':
			default:
				$this->phpmailer->isMail();
				break;
		}
		//if we are sending via SMTP, make specific settings
		if ($_mail_type == 'SMTP') {
			//Set the hostname of the mail server
			$this->phpmailer->Host = get_company_pref('smtp_host');

			//Set the SMTP port number - 587 for authenticated TLS, a.k.a. RFC4409 SMTP submission
			$this->phpmailer->Port = get_company_pref('smtp_port');

			//Whether to use SMTP authentication
			$_smtp_username = get_company_pref('smtp_username');
			$_smtp_password = get_company_pref('smtp_password');
			if (!empty($_smtp_password) && !empty($_smtp_username)) {
				$this->phpmailer->SMTPAuth = true;
				$this->phpmailer->Username = $_smtp_username;
				$this->phpmailer->Password = $_smtp_password;
			}

			//Set the encryption system to use - ssl (deprecated) or tls
			$_smtp_secure = get_company_pref('smtp_secure');
			switch($_smtp_secure) {
				case 'ssl':
				case 'tls':
					$this->phpmailer->SMTPSecure = $_smtp_secure;
				case 'none':
				default:
					//just do nothing
					//$this->phpmailer->SMTPSecure = $_smtp_secure;
					break;
			}

			//Enable SMTP debugging
			// 0 = off (for production use)
			// 1 = client messages
			// 2 = client and server messages
			$this->phpmailer->SMTPDebug = 0;

			//Ask for HTML-friendly debug output
			$this->phpmailer->Debugoutput = function($str, $level) {
				error_log("DEBUG: class.mail.inc: PHPMailerdebug: $level: $str");
			};
		}
	}

	private function mailparse_rfc822($rfc822_email_string) {
		$data = array();
		// match all words and whitespace, will be terminated by '<'
		$name = preg_match('/[\w\s]+/', $rfc822_email_string, $matches);
		$data['name'] = trim($matches[0]);

		// extract parts between the two parentheses
		$address = preg_match('/(?:<)(.+)(?:>)$/', $rfc822_email_string, $matches);
		$data['email'] = $matches[1];

		return $data;
	}

	public function to($mail) {
		error_log("DEBUG: sending mail to: $mail");
		$data = $this->mailparse_rfc822($mail);

		error_log("DEBUG: parsed mail:" . print_r($data, true));

		$this->phpmailer->addAddress($data['email'], $data['name']);
	}

	public function cc($mail) {
		$data = $this->mailparse_rfc822($mail);
		$this->phpmailer->addCC($data['email'], $data['name']);
	}

	public function bcc($mail) {
		$data = $this->mailparse_rfc822($mail);
		$this->phpmailer->addBCC($data['email'], $data['name']);
	}

	public function subject($subject) {
		$this->phpmailer->Subject = $subject;
	}

	public function attachment($file, $filename=null) {
		if (!isset($filename))
			$filename = basename($file);
		$this->phpmailer->addAttachment($file);
	}

	public function text($text) {
		$this->phpmailer->Body = $text;
	}

	public function html($html) {
		$this->phpmailer->msgHTML($html);
	}

	public function send() {
		$this->phpmailerCharSet = $this->charset;

		//send the message, check for errors
		if (!$this->phpmailer->send()) {
			error_log('Mailer error:' . $this->phpmailer->ErrorInfo);
			//echo "Mailer Error: " . $this->phpmailer->ErrorInfo;
			return 0;
		} else {
			return 1;
		}
	}
}
