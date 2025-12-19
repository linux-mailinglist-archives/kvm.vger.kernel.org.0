Return-Path: <kvm+bounces-66414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C3074CD1F0D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 22:13:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 223B83019342
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 21:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B98C342C9E;
	Fri, 19 Dec 2025 21:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I/hYr4i5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329D72DE6E6;
	Fri, 19 Dec 2025 21:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766178789; cv=fail; b=gjMZ8yZURzRqe+qTpnkzUHdP2z/x7hoad4OzEOGVifNQ8kdKoqxN1KRF0AcKEpuQnu2iewPu7Fo09RoIgDgsDN0iqd2lg1nPEh4DVq1RfeA3jTKz2FoiUhD/vE+4muBU4gGheVs5/iL1uefbHcjNUP/X54aDXq1rM0epZDqEMLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766178789; c=relaxed/simple;
	bh=SQHI3qfVjWXS6jeQ6yiPUZk2JQnKBebZE+1iKjHqhW8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nOpAxOMz2LM8PAU4g5NgB9R9fT6fUaz+pfCXJnOl05v1/LkouGSCOaU8FMI9pszHceEYZr56vTMcjaXKPRAXRDQkWAO04e0NF3tXqqBjqrY12VVoLP/aVO4gX/VQqXvQ+kCKnSK2Hxc0QADkzxxZgHqNE/uwXryHLseESqXzJjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I/hYr4i5; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766178788; x=1797714788;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SQHI3qfVjWXS6jeQ6yiPUZk2JQnKBebZE+1iKjHqhW8=;
  b=I/hYr4i5kK5jx13NDrtHJR5pGN+bYtZHZ5IiCj9vlY4MPnsleMqBiqTf
   muxSr/4gOS57nRJtQGBGI8a0Q8pUxBeQLqyyO+Jvcc7wfLvtxMJHjRoUD
   rCcC3E7N3XiCTh2lmSxiC14EgZVvXQDNYu9Emjw00dB62za3wFJ+IrDzN
   hpz/GPXHq4I8Ve7CBNJYdLEv7WSz2Q66Qq/EBZOeHRUwSEdf6oO9Ne3k4
   UZk1uvyfITDhF0euIrJZhtM2d6zk2rH3rrWtoZ5al7rScSRHgMG9N2BTQ
   FzBjRG11NfDW+Hvrje7Azc0KpNwDlJxOwR2U/1DOMOXI9IN6+WdrFrpjm
   g==;
X-CSE-ConnectionGUID: CqPzvqYPRnaE5/XYaxXk8g==
X-CSE-MsgGUID: vggE/yI0TzGD8SCrroBhAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11647"; a="68021876"
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="68021876"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 13:12:55 -0800
X-CSE-ConnectionGUID: 5A7gWtrTRr6ApdtO9LdT0w==
X-CSE-MsgGUID: 8xcjDlF2TkeJ4mHBLHXrUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="222372060"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 13:12:55 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 13:12:54 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 19 Dec 2025 13:12:54 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.23) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 13:12:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Od0YVwnYV8+2Qs6LfEhlIstLZgnoAsOUVdbOlQnxpiRHbBjaZ5CIqcf3uzB4IbEDFpQI3cTiT07gH7U+Z/QypVtsKVM81sYnSSuy0nYavnz7OQnw4MX7EhqkBJtTL6fBDkkjJmAhcur79YQH+RfWKpDjFIouQKVKZAIQuYI4GRY523gEvidwjbwSoifRtwdbfVvYkusUzqlp1mjgPPpFPwT24BJO184fAnnozj/lQi/uoOrgEeI8PgbV5ZwbW65QIAl2Ltu9GXxlIHq9uYMw9b5sCGlgP9puVgaEbq/9XtJ3wOUUA/KcoCXb8kZ0GbDjLwDE9jjEcEqgDXYd5OGPpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQHI3qfVjWXS6jeQ6yiPUZk2JQnKBebZE+1iKjHqhW8=;
 b=RA/PYJgZ0NSDP5PUi1fr1hZS78BDXjZGu/l6fzag94/eTEbbTk9f8GJ9kyP8aXq9GG2jI8LIUu/oQIFbPJFhPlzQ01NiqeQpauvUzthldQVnLr8uCsatEHr8nIV+OGo0uX1k505nQtcW1IqoLlhRjOZNPTSFMNEnHZ7d16Ey7xBSsb9VE82fmj3LXQoAFpmd4yVlNL8UAU4O6hUr7Sdom6ROsBnPrHcVI9MpvvUza6J0VPoSQ01JfvVur8HrTBXSDblUEqem16KOS0TQMrO8U7CwJsuNWZAXvEuXTGd1lnChzTlXjDEVHRmgoIZ/V70k5CvSEDZu8n3eYF8xUy524A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA3PR11MB7527.namprd11.prod.outlook.com (2603:10b6:806:314::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 21:12:52 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 21:12:52 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Thread-Topic: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Thread-Index: AQHcZk1Sh80gUaCm8UmaHxQPoMR2x7UY0mOAgAyl64CAAMpUgIACCw2AgADhO4CAAFzwgA==
Date: Fri, 19 Dec 2025 21:12:52 +0000
Message-ID: <63935b64dea22cc7a1c938e5e9b6acaec2c10166.camel@intel.com>
References: <20251206011054.494190-1-seanjc@google.com>
	 <20251206011054.494190-3-seanjc@google.com> <aTe4QyE3h8LHOAMb@intel.com>
	 <aUJUbcyz2DXmphtU@yilunxu-OptiPlex-7050> <aUL-J-MvdCrCtDp4@google.com>
	 <aUS06wE6IvFti8Le@yilunxu-OptiPlex-7050> <aUVx20ZRjOzKgKqy@google.com>
In-Reply-To: <aUVx20ZRjOzKgKqy@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA3PR11MB7527:EE_
x-ms-office365-filtering-correlation-id: 575a7667-7553-44d3-1283-08de3f435f00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bk1rdjNNVVJwMTV4VEJ5L2FYaitSM1VyeTI0bEQ3VVlIK3kzYUczYUh6OUha?=
 =?utf-8?B?YmQ2OVcra1U0bVJCTEdzZFVKUDlBRmFTVzd5NXJEWXFCS0IxejFhRVRkVDdK?=
 =?utf-8?B?aW9ob2oyTWNRVCtpOVVURm1yMmIwMUlab0xRQy9qbzZpTmZuQTNWcGVKV2RY?=
 =?utf-8?B?UDhHV1NQRkhTMU0rcHlEc2w4Rm5laUlmcE9hUGdNSjJNY2xWNm9ZajJ6ZnJN?=
 =?utf-8?B?OTdhZHIzclNKOW1sM1ZzTFZaMzZIMStHb3RxMlZzamRaa2I3L2dXK1czdUZo?=
 =?utf-8?B?aU53RzRyWllKV0t3bXZ2a2ZLSmk3Y3liNS9zenZpWnVHSXlRQklSYTloZ3Ar?=
 =?utf-8?B?enMzR3g5VkJteWJWT2IvNkRlaDZDeXEwd1grRUVib2NZMzdhWnRnQ1F2QVVC?=
 =?utf-8?B?T0FyckhNV0pnMVFTRlgwTmNQejRLY2VLY25LUTFmclFPb2NaU2h0N0MwYkJh?=
 =?utf-8?B?eGh3QUVTOTVDUTNpdDlZb0hDaU8xUGFyNVBzdDkrc0xybEsyVDRtTE9VWE05?=
 =?utf-8?B?SFQ1cHptaVo4TUpJck90UzZBelVyRi9XdXhkeWhqUnFFYkE3bTZsUFhpS0Zr?=
 =?utf-8?B?bWZMdVlJUXdHNE95SUFId2M4L1ZKWUdYUFk2MS8zaHQySlUyclJCdlUxbXN1?=
 =?utf-8?B?bkd3ZTVlUzBOMStXR1VSdE1QNnNNQmc5b3lwYTVJUk1DaGUzZXBIMmY1UjBi?=
 =?utf-8?B?eHFZR3dwY1JmNndxMzNpUWR0VWZYeE9HWjdUUSt0OWxTQjZXd2txRVc2RUxW?=
 =?utf-8?B?YnVQMlBCS0VqWkNoVEpFNHUvTVp5T2RyU1c3YS8yV3RoR3J1azdQZlYwODUr?=
 =?utf-8?B?RmwzQjVRdG1HQkl5VVpKZ2dhTHNub2hjajZnWWw4ZmU3WkdKYzM4cG8xV3M5?=
 =?utf-8?B?Nm83ZWNNRzR6YkpYT3d5SDE3Q2tJK2RiTUFkT0NUZ3dmU3hMNDZ0L2F4Z3Zv?=
 =?utf-8?B?WGIrYUxmSFoxVnpPaFNVL3MyNndHWWlNTko1NlU1Mm1rNFFrdEU1R2N5MnlQ?=
 =?utf-8?B?ZVNQZ2dsRDJZT0psTEZaWXlTNUZZeGVHaWVSUkZYMlQzeFlZbjhEUmQ3Z24x?=
 =?utf-8?B?U29TcjVGL013UjJBRUJNcmRrc1dDaWdzc0QySEJwRXZobmQzdG1IZkZ1dWZ6?=
 =?utf-8?B?SXducGZsMkgzcmZ6N1RiUzk5N2Nrd2dKdk5CVHpNVkE0L2Vlb2JvV2JIVVB0?=
 =?utf-8?B?dEZOdUJIbkN5MVZLbnhsdjhYYU1VYS9IeUpTYVVBUlZJbCtVakU5Z042NTNh?=
 =?utf-8?B?bEd0ZVlYNmprc2FYN2F1MXRMVEFiek8vaWIrNHNVa0p0VTNXZ1RnTWxYSW1m?=
 =?utf-8?B?Nk1INVJLK3Nrb3R5Y2lkRTZMRE1KZms5ZzZxbXVKQTVWT1hVbVIxZmhwR3RM?=
 =?utf-8?B?cUpqM2JxTjlxYVhQNWk0aTFBaGtpZGtYNk1vbDZHRldNUFVJdnQ3Y3pMS01t?=
 =?utf-8?B?Rk1NQzU1ck56Y3ZZY3FHTlI3cnFwZE54YnZZcnV2UGtjQm1HYXhqa2haR2Ft?=
 =?utf-8?B?WlhjSVpyR0tMaUk4eHV1dlV1Q1hCTTNXUWNJVHJBbHJnTVd4UUFJTlZBdC9p?=
 =?utf-8?B?dVBFWUVWd1ZCMXZwckt5MlJDRS8vNVNPVk5pL3VvVFhPK05vUyt5MlpkaXJC?=
 =?utf-8?B?Q1JxMDh0ejVkQ2h6SEdaMEJVd1dTbzdpcmFpWUtQcUZMWTFDKzRCcGZCOURJ?=
 =?utf-8?B?bytValhZUVVlRFRiQmVsSWZXZmF6SGJKUjR1Tms1aUdSbzc4a0ZVYVRqZWZO?=
 =?utf-8?B?YWRydUl1UGZ4a3d5QmlwZGZwSm1zS2crMFcrV1hKUnI4NGRKMjZPVEZsTlpQ?=
 =?utf-8?B?dTV6TFIveEFQNjZMbis4YzN6K0MzUzM1V1VOeE5mc1JwKzhXVGNhVDFzYzRy?=
 =?utf-8?B?TkJSU1UydjN1bWh6NzlXZEZ2M292cnhGSUorZXlHVjNxYWkwMkdpZ2poOURr?=
 =?utf-8?B?aXBOVVgwNS9mZmxCL094c2didW9OOEMxT2swS2k3VmFBTFIvWFBKVWM1elY1?=
 =?utf-8?B?MDJHUXpFV2xkVWMraEh5aFFDbWtJdXVXaHRkcFlxSXdyczVaWFk4MENDTUph?=
 =?utf-8?Q?OQNaf0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmkwaURwaW5JQ2UyWlVrTjVlWlpUS0RHVTZmM1VzbXdtRWZRZjVzMmh0Y2VC?=
 =?utf-8?B?VW9qOVNic3dRYUI1azNIYnV4Um9LWDUzaElUUk11UXJhWnhvY0lJSENacWh2?=
 =?utf-8?B?RnNKNFdzRlUvOWtsdVlna3ozc0JQTjBtOTB5MVBodDdaeHQxb0NOSVFpMmZK?=
 =?utf-8?B?N2tkK0JkY0ZqSVFrb2ljaGZrelVqZE8ranQ1WGc5ZjdrWWxCaGNsaGl3Q0Z3?=
 =?utf-8?B?Q2ZTdDVaR1UxYzRwdzdYaGxHbzZVc2VZV0ZEY2VqZlNXYTRLQ3JDd0dZNlVZ?=
 =?utf-8?B?Qm5HZWtMT0xlK2ZlNm9kYlZNcXZwYUd0TXp4eGRrb0pnNHRWY1ljamxRazhy?=
 =?utf-8?B?YklyVVNLVC91K2hNZ2E4RC9xQy9qbUdSU0hOYUluTTVCblllQjhyZ2FrTHJB?=
 =?utf-8?B?UzNTWTRzZDdBK1prck5vYW5jSmdDb3dWZFc3NlBBb2xsRDI4eXlFR1M1YVJT?=
 =?utf-8?B?bHM4ZkxhMzIxUFFGVDB3Ry9rU3FpeHRXQmxKWkFRbXkrQ01DRXA4NG1PM2lR?=
 =?utf-8?B?ODVyaHpYQTZ3Z29GR1hEMzJLRlZadFB1dVJIclJZNVVjQUVzTUVSN2E2aTJQ?=
 =?utf-8?B?ck5tVGpNa01UcDRrQllEZlBJQnNUZ255aGl6OVVrTldhS1BOeStwYzVMdkxu?=
 =?utf-8?B?Rll6U3hBSEtsR0Q5MzZCTS9vWDdqMjdMLzhNdDdZODI0cXlCTHUrQnAyNjNm?=
 =?utf-8?B?Q3A2UkwwdzBTcWRLRldnTmNFZ3N2V3k2V2ZHbjczaDdKYmsxKzJ5bTArRi9T?=
 =?utf-8?B?b2owS1ZaUlMva2l2cDVjQS9Sb1hJbmlHUFQzY1phd1JSa2JUSGlFL3FNbzUy?=
 =?utf-8?B?eEdhamN6akdRTC9qZjJyY3QvR1d6RCt4TGRDWFFEMzc3MDJIbFNxV0I2dlVw?=
 =?utf-8?B?SlcvMjlwRW9UeUNjZmxqS1g2bm1XMEtCTEEvRVJVWXUrb2Z6cThYKzRNdlF1?=
 =?utf-8?B?NlpsbkszU0V6SC9FQ21ib3lMbmdNMXlsdlNISW5XR1paYUNoT1NpWDY1REpj?=
 =?utf-8?B?RFc2TXVXLzRPUDNHNUszc2JjcWF4Tkp1TExEQm1KTzZ3SUhSNHVRUjZxcWxt?=
 =?utf-8?B?MFZFOEowaWJOT0Q5WTBESjlvTUt6WVV5czFBdGIrcGhvMzRkVFBTU09zRTgx?=
 =?utf-8?B?MGxuNHJGNEJwSEFJK3FFTFlIeHNtSkczT2ZhR2lOcUNuWExsQzR4QWtRS2h5?=
 =?utf-8?B?WE1yaEJVUXpIWDl0RFhoOU9KdTBQMjZmSGlKTmUrMHRzcER6Z280QnU1RHFL?=
 =?utf-8?B?enBXek9CZkM4bVgyV2hzOWNYV2V5cFBURDFlMjBNVUJwd0dDcE1qUzA0eW00?=
 =?utf-8?B?bW01UzRqNGt2YWRRNUhtVXA4QmVGTytVRWEzanJ5SEJELy90OVUzVE9CK3Js?=
 =?utf-8?B?d0xiTXM2SmVqV1lMVzhzUzFqaW1aMEQwcktIN2h0M3k0b3VtK3RCVXg1NUhy?=
 =?utf-8?B?Yk1WVGtteXc5MlJRdnZhWFp0eTk0cVNtVmdJcyszUm5wTnVacU4xd0FaazFS?=
 =?utf-8?B?a25McHV3OG1mWmpyQkZPZWs4T0p2L25tVXhHdkpzbWQvQUUvVENVbTJwMDl3?=
 =?utf-8?B?dlhsdVpUVjA4WGROV3BTTGo0VzRDSHRLNnZVNkZ2VzlvNDcwdHlyaVhuQ3dy?=
 =?utf-8?B?c0lTMDFrVGZOaGc1WURaQW5ib0dSdURjTG5DVW5taHYydytIa3VpbHJIaWpL?=
 =?utf-8?B?a2NsUk1HN0xlQlVybFh3TXRCZFhzbUIzaWZYTHhDWVFiMmVVYjRXcDJ3aVBy?=
 =?utf-8?B?WERpbEZXTjh5bklpR09XU05tQS9qYzBaQmIzcnRwczhoTk9zK0QrZDBqNDVa?=
 =?utf-8?B?SHFleGpDNXJkTFVYeGRaODRrRzRkRGg4V3RRb2t4RlBmMk9NMnliaDBhU3hh?=
 =?utf-8?B?RkJYTzBLWHN3bm4zU1ZXL0dLMXFCNEYrbi81R2lMejI2S3RzdllNajBPMTRT?=
 =?utf-8?B?SUtFTGdVZXpCVHl0czVRWmwrVU1QdkYwU0o3eHhHczVuTklXY2pYV2Ftc1NS?=
 =?utf-8?B?RkFJalJQcmhkYm9aNzVxaTVSUFVNU04vcmpuNWs5Q0tDVW5xb1l6d0tWS2lZ?=
 =?utf-8?B?VktRRkFhTUIyb1lGYlIwaGt3VURscmd5RDdzUFphWUFaU0JCd2RqMkl1UnYw?=
 =?utf-8?B?ODZqakZNNE4xZVloQmVMQjlHQTlMRzBDV3ZTeThLeXcyeUp2ZlhoR3JEMWdC?=
 =?utf-8?B?TWVzZXViTm5OMTdHNzB1L05nRGJwV0JyekhmMTU3bjRKTU9RZC81aU1ZdHRy?=
 =?utf-8?B?bklWbmo3R045ZnBicndKbmc2ODNycnYwMDg0Y0svMGpuMDBJRHg4ZXVNWUhz?=
 =?utf-8?B?cDhLOGVUZ2ZBaUdnRmJQaStlcmdYRHpQcnJuNjZhOUE3N2ovcFhudz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DB6E05011795E4AB28C29D9DFBDB5C5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 575a7667-7553-44d3-1283-08de3f435f00
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2025 21:12:52.1777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DRuGQh7Ude8+qYQ3iKAk47KQv3If4EA6G7lr5UKBicxCjIXitCmNP/WtKEI8XXOdIbWJ3U9mj1p8GO9I2ppNNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7527
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTEyLTE5IGF0IDA3OjQwIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBLYWksIHF1ZXN0aW9uIGZvciB5b3UgKG9yIGFueW9uZSBlbHNlIHRoYXQgbWlnaHQg
a25vdyk6DQo+IA0KPiBJcyB0aGVyZSBhbnkgKipuZWVkKiogZm9yIHRkeF9jcHVfZW5hYmxlKCkg
YW5kIHRyeV9pbml0X21vZHVsZV9nbG9iYWwoKSB0byBydW4NCj4gd2l0aCBJUlFzIGRpc2FibGVk
P8KgIEFGQUlDVCwgdGhlIGxvY2tkZXBfYXNzZXJ0X2lycXNfZGlzYWJsZWQoKSBjaGVja3MgYWRk
ZWQgYnkNCj4gY29tbWl0IDYxNjJiMzEwYmMyMSAoIng4Ni92aXJ0L3RkeDogQWRkIHNrZWxldG9u
IHRvIGVuYWJsZSBURFggb24gZGVtYW5kIikgd2VyZQ0KPiBwdXJlbHkgYmVjYXVzZSwgX3doZW4g
dGhlIGNvZGUgd2FzIHdyaXR0ZW5fLCBLVk0gZW5hYmxlZCB2aXJ0dWFsaXphdGlvbiB2aWEgSVBJ
DQo+IGZ1bmN0aW9uIGNhbGxzLg0KPiANCj4gQnV0IGJ5IHRoZSB0aW1lIHRoZSBLVk0gY29kZSBs
YW5kZWQgdXBzdHJlYW0gaW4gY29tbWl0IGZjZGJkZjYzNDMxYyAoIktWTTogVk1YOg0KPiBJbml0
aWFsaXplIFREWCBkdXJpbmcgS1ZNIG1vZHVsZSBsb2FkIiksIHRoYXQgd2FzIG5vIGxvbmdlciB0
cnVlLCB0aGFua3MgdG8NCj4gY29tbWl0IDlhNzk4YjEzMzdhZiAoIktWTTogUmVnaXN0ZXIgY3B1
aHAgYW5kIHN5c2NvcmUgY2FsbGJhY2tzIHdoZW4gZW5hYmxpbmcNCj4gaGFyZHdhcmUiKSBzZXR0
aW5nIHRoZSBzdGFnZSBmb3IgZG9pbmcgZXZlcnl0aGluZyBmcm9tIHRhc2sgY29udGV4dC4NCg0K
VGhlIG90aGVyIGludGVudGlvbiB3YXMgdG8gbWFrZSB0ZHhfY3B1X2VuYWJsZSgpIGFzIElSUSBz
YWZlLCBzaW5jZSBpdCB3YXMNCnN1cHBvc2VkIHRvIGJlIGFibGUgdG8gYmUgY2FsbGVkIGJ5IG11
bHRpcGxlIGluLWtlcm5lbCB1c2VycyBidXQgbm90IGp1c3QNCktWTSAoaS5lLiwgYWxzbyBmb3Ig
VERYIGNvbm5lY3QpLg0KDQpCdXQgcmlnaHQgY3VycmVudGx5IHdlIGRvbid0IG5lZWQgdG8gY2Fs
bCB0aGVtIHdpdGggSVJRIGRpc2FibGVkLg0K

