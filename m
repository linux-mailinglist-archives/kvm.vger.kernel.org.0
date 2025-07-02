Return-Path: <kvm+bounces-51246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DADDAF0911
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:12:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CE5F4E2EBE
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A1B1D88D7;
	Wed,  2 Jul 2025 03:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LCQPnU5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A3D2A1AA;
	Wed,  2 Jul 2025 03:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751425959; cv=fail; b=j7+7e8LUJUYDvp3i1csIoAH26N3Ja/KlPCEMhIpv5Bv440f5vFJLMfsga9ZHe+Yyk139qMPW65WqFdSMjCYt8C7OtAIuKsdeaPYs92OdX0GZ0y0f6zbpqwS5OPxqILqPJ9ybLYxPNAQPcjnyq07zMKHMGi7z20MS8qnqsXn/C+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751425959; c=relaxed/simple;
	bh=K92lI5c5AtvBV3t3YwYPZN7/U2yH+t6cLxj19BVlYCc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TOcbdxfSoRAC+fa1tVS0HW2QrZvYR//EU+GL24mMuPr46vyAWonLzqtKwF/1stNsOK5fU8TqQcxWkVuL/WeCvNf4zHboGdNXtjJxsTUkZ0W5EwFQ7zbLEesRLHb4R1UQrzG4DEDfGRvmDzsjawAORcTlCvcEOrQO8c4aeEZZu0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LCQPnU5Y; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751425958; x=1782961958;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=K92lI5c5AtvBV3t3YwYPZN7/U2yH+t6cLxj19BVlYCc=;
  b=LCQPnU5Yw0zRtGvYd9OCNGD7j8LqABXdxuszBZQbbPZIIyEg8lltEoTC
   v5kQspOjTDfy/WtsZfNr4TqGvYIXOCS7EF69CFasngOwmzHCWpaMtiwhC
   sDfIFfPWfDZgEBMMziJxP4cDk+IR3weeu17n516sKJ4SvHuIDYM4W6tTC
   NMfQzchnjrokH486vBfdwv1yC7ZzG8kw9UJ4q0lgs5kEj4zPFzv8lP4Qt
   1h4ABHmbQ/9SODfIkJZZtwp5lEHidYSR1r7J16eHeK9a13/BaeyIbwmDf
   ri4Ct4BDebN6PfsJsR6jqKvkv/5QCxavxPP4NPJZRJRXnNptZlCAHMa7E
   Q==;
X-CSE-ConnectionGUID: kTEmT5WKSriULeg3lxtqzg==
X-CSE-MsgGUID: +MHSNdhWQ0OmTHoIt+3OgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="64307236"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="64307236"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:12:37 -0700
X-CSE-ConnectionGUID: /W/yjh+KQ7KxKbaBeu7xjg==
X-CSE-MsgGUID: 8GRlJqseSt6DwX3FBlFrLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="154676027"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:12:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 20:12:36 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 20:12:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.80) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 20:12:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEbHQ8E/LXbtts+odribqsy1LhikE3fsnkZm1Ndlqzl0+z6+Hsv20sUfcKLjU/GNmaneZjmBCdyczN2oxvy5EOutoujdWhhktCUvXv14JFhoYgy0PvGcrRfkVq0maULwtbqD+x6myiZf8QYtNwZ2DDoswb8ogGn2KXSeGFWcCCeqxZzWuvA8NqbSI2+YsBiua4neUpZX+rxNoDerHse7KmmkkiirlMMH+kCy1J03kqMYDXctQvwANjBHlwLbfYKLKIKEtzuLIjmp36R8yGp7arg1utlAyrX2xnmtBjz9aj9NhmwB/iHwecrojRwLFybxuM3xiU/26tYaZWDjWtPDFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K92lI5c5AtvBV3t3YwYPZN7/U2yH+t6cLxj19BVlYCc=;
 b=b98NMF6/YYjkYspszgT2TseB0a1XUj6Jaj6CqJemUKcHsBuOE3OxuMPa+ITBfQjLf90MTke4AiQVruFU/Pgea2K7N2IGtU+pSa4o6uGCS0wFFrbQyt7NgOf0l8yeC2xPdPsW6vGix+naA6BA4ujo911YB+FvuJtdSW23oxDxFFGDmdAzQ2N0YncELgKABgshz2fJosar2fxEH7eJDFv+06k8wUQVEQZxB0fyhcWn0h1QuOVgcOW7yoXJpaP8l6l5ZtUCkZgetPJNqSRxC1TOVNIXMOS6eV1AxqjhkogWUnQtScHTHvhQBqAf/4xroD5Mw2nc+frYQcGBKdWIyKJntQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB6999.namprd11.prod.outlook.com (2603:10b6:510:221::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Wed, 2 Jul
 2025 03:12:06 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8880.029; Wed, 2 Jul 2025
 03:12:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "sagis@google.com"
	<sagis@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Chen, Farrah" <farrah.chen@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
Thread-Topic: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
Thread-Index: AQHb5ob0RE0br3XqzESRONxJOkYqpLQcx2yAgAFpsIA=
Date: Wed, 2 Jul 2025 03:12:06 +0000
Message-ID: <4ca0db300edead0bfc09e81e43895ac20dce521e.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
	 <8a9924d8-7d73-48a4-9ed8-a031df7098e7@linux.intel.com>
In-Reply-To: <8a9924d8-7d73-48a4-9ed8-a031df7098e7@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB6999:EE_
x-ms-office365-filtering-correlation-id: 0262decc-2095-48de-ce2a-08ddb916397b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eGRjS096QTNtQy9RSE9nMUR4engzZjd1THFtL1JBNURnbG1iTDdaRVRWa2hI?=
 =?utf-8?B?UWU5K2MrOFNnUmk1VnN6V3lib0NyMjhJR0N5bDZ0QlE5MEtSelVOMVd3cVI2?=
 =?utf-8?B?RVFsOHg3WUE4YzlDK3ltazRGT2drM2g2WGRJb2JiK0NWYm5pWWdyZTVockYx?=
 =?utf-8?B?MVA1QWw1dmxvbVRDa3BPbFAzUUtCY05MY1hMM2o1T3U0LzdPU3RmTCtFbnJC?=
 =?utf-8?B?b2ZmQlpCWTUxNkJxTzY0Q0s4bFJyVWFZWFZCeERrOEFOUEVCRjFqUTAzWUxj?=
 =?utf-8?B?SUc5UFB4bXFOOHVYbkM1ZDRjVXI5T1pDL2VzdUdWTFg3aDhDOWVpc0NRS0N3?=
 =?utf-8?B?alJWdmhVcVEzY3g1YWdXVHVBdGo0Vk1wUSt0MGdxRkxGKzFzWUc1MDk3YlJw?=
 =?utf-8?B?N08rcVZPWERwS01PbDRNemFhQys0NDRjTUd6bm9xMnpkUENmaVlwYjJub1p4?=
 =?utf-8?B?ZkNTSEFVS2Y4WHJkTE9uNXRYa05wakhSRWk0ckhQMUdpZXg3VStEZ0grSjlw?=
 =?utf-8?B?UWUvSm9ETG41aUkrWWhCaXNDaWh3SGdhTkh6RjljUzRBNGtuWlhreWJQbVlH?=
 =?utf-8?B?ZVFKdVhQSThLaEFZU2oyTnFiSExtdVhhMnlCUFYvbUhVMmE2MW9kakFVaG41?=
 =?utf-8?B?VTNhL0dCRmIyRmcxV2pKZU5qMHdSZGRKU290UjgrQllnbStmSys4aVNwK2tm?=
 =?utf-8?B?anFFdmJFUTNEOGdTaTFjekM3d1JiUUlZRVV5K0E5Y0FhUU5ZZVUremFCQ3NG?=
 =?utf-8?B?d2w5eWJiRHAwNnQyaE1hRm9WWmRFeTdpZzZxZGxWSklCOHRXa2NEMy80cVF5?=
 =?utf-8?B?RnRsTGxucFMwTVNLelpuaW50Q3p5U2xmRlNTYk5NMS9oNHNNRzNKNms3b0xS?=
 =?utf-8?B?bnNPOVlsT1J4OWxLUzBhekJXY3FBRU4xYTNuT0tSVzN1M3FzTFNRdXJlZUNk?=
 =?utf-8?B?czYyWjR6QUxReGRIZWU5QXZlRDFhZ3dpbGlkYWNxTEp3Y1dmVHJDTHkzVXQ3?=
 =?utf-8?B?eWlCMEROSnM2dmw3UVVYdHlmTzZ3N0tHN2VTSlZnMGlqQndqbTZBUE1qT05O?=
 =?utf-8?B?RzR2ZXZIZVB0UFlCelZ0UThudXdIdlduRTlEU2xWZnZyU2xsdU5hZUFwRVRJ?=
 =?utf-8?B?aVliU05sUWNnSjdYTTI4WHN5RW53akR3bmk3YzdtRHR5ekdPWFgzNGVQL2Rr?=
 =?utf-8?B?YUdmaUljMVdndURPL3JEcFBrUGRNcFVLL0lpREdiMGZGd3FxNEhRV3hFVkFm?=
 =?utf-8?B?aVBBamxTTzFQQmQ3SWg4ZVhCcmpWQ2IyU3FpSC91SHpJTStPMGtRcWxFZnFC?=
 =?utf-8?B?WU1Rc1lwd0ZpNDBCR0prK055Y253emRHRDhtbndEUDVCRW15bmR3ZWh6aGJ3?=
 =?utf-8?B?NXo4Rno1UVJZM29Gd2lsTnlpbnB0TzdyaVJYdm5nNFd5QkpYM0U1OXVYSFdu?=
 =?utf-8?B?eC92ZkNMU0NhTGZZVHh3WDlsUnZPbHFTUkhHYkdxbk5HLy9KVzkyRlNzbTFm?=
 =?utf-8?B?WlI5THJMTG1rajErL1A2clZxbmtJSjhNbHY1SzRBQWJRai9sL0JqMythbHNQ?=
 =?utf-8?B?R2JlOE9QR2NZWlhSL2xTdVQvY2ZUSzZNZTJObGV2S2NrV3VWR2YvbCtmYXBn?=
 =?utf-8?B?VUdEZEVpTmh4NG9CWm9XdFlpaUFpYlNkYk81K245aDY0cGdMYVczQW81eTA0?=
 =?utf-8?B?eFh5aFlqc1UvbEFSeEwzMElWZDNETElWNDFnZkJtNGw1dkNBbUMvNnlFZE5M?=
 =?utf-8?B?MEFITGtBdlhvOGJBc3lrRmZOL3Y0MVl1bVQwSHZsTVlpRTQreWsyUDd4VDk3?=
 =?utf-8?B?c0tsK1A3bVpUdHN1eERvOHRLYngxWXMyT2FsTmYxOWU5Y1diL1hxYk8rRW0x?=
 =?utf-8?B?TTRXd3N0K05wNHdOUEUwMDRZNzBNcTZzWXBkdmhWcjVVSWhiTm82eFQ0N1Jo?=
 =?utf-8?B?ZEFyNkZqVWFuMEFZR2d3SGd3UVgvbzFPaVlQOVZrS3FjVjlHNEt4b2Q5YVpF?=
 =?utf-8?B?Y0hpZzJsR3N3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkMwR3hlTUw1L3hhOHlaZnhrQllsMU1MTlErNmVyLzN4bStWcmJ6dUF3L0Va?=
 =?utf-8?B?V1NidWFvOFJBVkNBRTk3NUJKYXBXbGZUdlZoUlkzYjc0OGwrblUrd3JRT2lm?=
 =?utf-8?B?RGxweEtIa1huTXp1ckxQa2JqQjVpQzE3Tm1WQ1g2bC8ydVJMeVg2MHpDM1hu?=
 =?utf-8?B?bDZJMUhEV0tpZjh2bWJxRUhtT1hFV1FFanRrbGoybUk5d2F5QU1pY1FRbEtZ?=
 =?utf-8?B?NU40TEErbFg2WVBnd2c2SnhkSDlCQjVlZDVpNFROZENlR1F1U1N6cVNablhs?=
 =?utf-8?B?WThyeDcwTjZqWGFxcE1JZ0dBTnFBKyt4MGNpTlJyWDBQQXhHS0t6U2VaRjBB?=
 =?utf-8?B?S3VnYUh2Y3ZVOTVhMUJDbmVaLzd6bDNVZjVGYjkwa1ZsYnVpQVRTZU9KYXBO?=
 =?utf-8?B?WHA2MksxcS9kdlB3c2pvK25iR3g0dWJ2aFFFNlNEalV2cTMvQStadzh5YXlq?=
 =?utf-8?B?dVZ2Q1ZCOFR3SWJFc3BFYTU2RXRUYlNYUFgxZGsrN2ZGVEM0eUExSUZ1Z0xw?=
 =?utf-8?B?QXlqZzlQYlNudkQwcW5TZTY4N3Q0TzJIM08rNVJKY2xiOER1WkJrb1hlQlNT?=
 =?utf-8?B?RE5rNmduTG40T0dhcCtIWjgwWm1WdysyeXFxb2tQejE5VTdaZHBpZTdBT3Mr?=
 =?utf-8?B?R0hheWdXR2lxeFhnOUR0WU00ZlVFbksrb0hBWEhkMVdEMmxUV3FVT1pjSVM0?=
 =?utf-8?B?d1dJaHd5VnVaMk9lLzlSd3ZRTytRNkwvRllNdFFWNTltdFp2am56MERCTm81?=
 =?utf-8?B?djEydkNoT2poYlYvU3R4ajFGMmdBam8zQmZqL3BjWmZUcFU3VVNKd1pFSWhu?=
 =?utf-8?B?RE1zb0tZVE12NFh2bFJUNVU5bnRPd1dla0oxQ2dSeDhoRmpxcXJMdEpjTTNR?=
 =?utf-8?B?WGlzQmVBK1Q1Y3lKK3ppUGd6bFFJcGNPRWlHNWt3Znp3emlTL3kxbWNKdzZn?=
 =?utf-8?B?aFEwTklNZ0hVK3hiUDRFVTJIVnVYdDBYMHNvcTJ1VGdBWHJBRDJOaTM3UnZN?=
 =?utf-8?B?WVVXY3h3L0hBTGtzbmdQbFVBTEhLbEU2Z1RzWWxmMjZtWmpOUDc0RE1RLzZB?=
 =?utf-8?B?UnByWm5GY0FpdTVtWjhTRzlmNkZ3SW5YOFhyUzNzSkJxLzd6TWI4bDFGSGM2?=
 =?utf-8?B?RWtzT3ZMS0VYMmZ3YjhiRmx5MnNYWlNEWDZvNjVUU1B0czc4VkhCakdUR3do?=
 =?utf-8?B?ekFUUDJiMmwrMm5lVFBtSUdCdnQwODBMM3UvVVRqcThDQXJGTUJreUJ4QTJm?=
 =?utf-8?B?VmErS2c0UUsxdVZOU2NkS0xTWFBnaG9hV2c1TTZvQVE3WlRhOFBvbnlPWVVO?=
 =?utf-8?B?NW1iWmRRMURsODcraE1VOWcxVkJVd2YxYm1laFBmZDVjaXQ1czdSMHJLT0Rq?=
 =?utf-8?B?akdXOFozSlA4SkRwWGhsenhBM0FKOUxNcjVyd28xclpjc1ZUM1BaaGozT1NG?=
 =?utf-8?B?RWhhT0hmV2haRy8wdXdkUmN1TlVmUEdtRmRrRnNRQ1paUFZ3dTF3M0U4aDRC?=
 =?utf-8?B?TXhxdzR1bWdrUzdncXdFdytxdWxmcWhUL0RUUkFnVHZXMUp5VEpybTBpYkh4?=
 =?utf-8?B?eFRUYU53cU16SVNXTlRuWlhDU1FLQWJ1TEVFaW5CYldYUzVYam1LMHhzUkwz?=
 =?utf-8?B?UHRRVDQyTTlKWHNHaUpERHpYay9ReityT2tkUStXcmw4bmxRN0VWMTNaYi9P?=
 =?utf-8?B?R2JOdGpnMFBtdEE3bnM4ajlJVFNkaDdlczMvNW5BUmVRRjNyT3l6NUhvaTR1?=
 =?utf-8?B?U2VZUGl4VzlocmZIQU5CcXNSN28zbGdXYitGekNNamFQbjBwWXV1c0NmZFBV?=
 =?utf-8?B?bGo5cVVWbHJCRm1vYnBXTnBzckZLYXFYUUllNGRHUnZkTDFlaGlZZmNobWRs?=
 =?utf-8?B?VlpXeDZqRjFOaDlMRDVXSjFnb251b1JqdlhPREgzSXBUQ2JzRWdBVFZIM1g0?=
 =?utf-8?B?RjlKQU1DeWlIMlV0Z3Y3a2RGd3F6MGxadXlTSnFPV3VrWEJXUXhhZy9pYnRO?=
 =?utf-8?B?TDBXTWJwdE02ZCt2V3hNY1lvTFhBMXp0RlJoN0k0NUZ4bHVYcW5tcTFOaUJ4?=
 =?utf-8?B?Mm9IRlVLVWpPSUxQZDdBemJnY2NNaTBFZlRZTUtPb2dQaGsxUEJlZGd3TEE4?=
 =?utf-8?Q?lw0yFG2PfzzpZ7rjpfqrB9tBF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <487D7E093973C145AEE8A2460A157475@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0262decc-2095-48de-ce2a-08ddb916397b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 03:12:06.0636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V+v0LMen2PXbhb9ypHWdVGZkx2rZilqMiizTt5mbtQG7KaP6cr+qfmTa7rdKYIqgoWEM3r1M45K5xnrnHVq71g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6999
X-OriginatorOrg: intel.com

DQo+ID4gKwkvKg0KPiA+ICsJICogU29tZSBlYXJseSBURFgtY2FwYWJsZSBwbGF0Zm9ybXMgaGF2
ZSBhbiBlcnJhdHVtLiAgQSBrZXJuZWwNCj4gPiArCSAqIHBhcnRpYWwgd3JpdGUgKGEgd3JpdGUg
dHJhbnNhY3Rpb24gb2YgbGVzcyB0aGFuIGNhY2hlbGluZQ0KPiA+ICsJICogbGFuZHMgYXQgbWVt
b3J5IGNvbnRyb2xsZXIpIHRvIFREWCBwcml2YXRlIG1lbW9yeSBwb2lzb25zIHRoYXQNCj4gPiAr
CSAqIG1lbW9yeSwgYW5kIGEgc3Vic2VxdWVudCByZWFkIHRyaWdnZXJzIGEgbWFjaGluZSBjaGVj
ay4NCj4gPiArCSAqDQo+IE5pdDogQWJvdXQgdGhlIGRlc2NyaXB0aW9uIG9mIHRoZSBlcnJhdHVt
LCBtYXliZSBpdCdzIGJldHRlciB0byByZWZlciB0byB0aGUNCj4gY29tbWVudHMgb2YgY2hlY2tf
dGR4X2VycmF0dW0oKSB0byBhdm9pZCBkdXBsaWNhdGlvbi4gQWxzbyBpdCBnaXZlcyBhIGxpbmsg
dG8NCj4gaG93L3doZW4gdGhlIGJ1ZyBpcyBzZXQuDQoNCkkgYW0gbm90IHN1cmUgcG9pbnRpbmcg
dG8gdGhlIGNvbW1lbnQgYXQgYW5vdGhlciBwbGFjZSBpcyBkZXNpcmVkLA0KZXNwZWNpYWxseSBh
dCBhbm90aGVyIGZpbGUuICBJdCBjb3VsZCBiZSBkb25lIGluIHNvbWUgY2FzZXMgYnV0IElNSE8g
aW4NCmdlbmVyYWwgaXQncyBiZXR0ZXIgdG8gaGF2ZSBhICJzdGFuZGFsb25lIiBjb21tZW50IHNv
IHdlIGRvbid0IG5lZWQgdG8ganVtcA0KYmFjayBhbmQgZm9ydGgsIG9yIG5lZWQgdG8gY2FyZSBh
Ym91dCB0aGUgY2FzZSB0aGF0IHRoZSBvdGhlciBjb21tZW50IGNvdWxkDQpiZSB1cGRhdGVkIGV0
Yy4NCg0KPiANCj4gT3RoZXJ3aXNlLA0KPiBSZXZpZXdlZC1ieTogQmluYmluIFd1IDxiaW5iaW4u
d3VAbGludXguaW50ZWwuY29tPg0KDQpUaGFua3MuDQo=

