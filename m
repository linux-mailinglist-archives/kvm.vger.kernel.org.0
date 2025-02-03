Return-Path: <kvm+bounces-37143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B34A26204
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 19:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E945D166F9F
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 18:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E31520E001;
	Mon,  3 Feb 2025 18:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZlSarLkH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA88E20B7E9;
	Mon,  3 Feb 2025 18:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738606498; cv=fail; b=D2PqlMflQaBVeUbtmOA4pfn2FdCAyQf6DNtiOxTu1uB4xOJyFkhPtR8W3sW6tbOg4N2DfPlYpxzrtC4HS3zg8qBa5GV1zTy+eBUVrsB7WoOzyH8kxK99U0yoyFUmckWlK/QADuRl421Li5WQ/1/jVQx/zoYUn6hlOfHta3tqL7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738606498; c=relaxed/simple;
	bh=luqCMIyJIQatGNbCkcH5bLWCxByY8hm/jUf+VMQp3f4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fgPIxGbYTaqgiK/ll7SYCalkq8kvm3h1QNlYm5BsBqLMpnb+vYGO5/aB6aTkek6rnn2nJyK0jagRRxrED9RSdHCzs2y5H7R1daaMpp2ofuOvgGpGONyA4FYtuYFvv8bogNvSr1f3EmMSrrcURESsWiVU8iDNGegSWkchzMbSQYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZlSarLkH; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738606497; x=1770142497;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=luqCMIyJIQatGNbCkcH5bLWCxByY8hm/jUf+VMQp3f4=;
  b=ZlSarLkHoAgHgAaJlerSoaNXHRdINZkJFTScMsGOiRH7GshPm7rkoWwD
   +ZX+w6AD21Tk3N2vvjQm9UFQzJZ2zGBam9/D5iPd+jT1xs+Gif07S/hfN
   u/pwa5uJlcD2ItfgSyPNuMQe5PKAQ3a2X2T1CcharkcosE6zMap4+WKC6
   16i3y8P0ga7jUfL7HPayA+yJ6UaPdz/kCFjoCexozwa3ogPkuKwe4ehGP
   UFxGVsOHvZ8IkWazp79oE+oA6IbE+LHsHUBTeP5KWUXnLwy4gm327UWZp
   dDgrSNXzRQZurh+aU5prFMubW5cRjCqI6zguB7G9FTLw/Nl2NkE9MGTs5
   w==;
X-CSE-ConnectionGUID: 9vCvRab2SPaYge2jnN1FGQ==
X-CSE-MsgGUID: j6vZhOvGQNSFYrCoA/a1mQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11335"; a="38818877"
X-IronPort-AV: E=Sophos;i="6.13,256,1732608000"; 
   d="scan'208";a="38818877"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2025 10:14:57 -0800
X-CSE-ConnectionGUID: B3/auy7bTpeskGqfSqmURg==
X-CSE-MsgGUID: hlFxcK2uSsqw/XfpsFrB7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="114395231"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Feb 2025 10:14:50 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 3 Feb 2025 10:14:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 3 Feb 2025 10:14:49 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 3 Feb 2025 10:14:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R4Lm7bBVrROrX4SJYcp2J3yU63w7FulJ2lNJMr3M4Hof+mvh1XVX9auMnS1ITn9krDkWaXnutEpTIT7MALLOj1izlS1wiHRy5E9Qh+O9kPUUKtvs6PHA8MlTCD9CaeYLmaWBtJmn9BPO1jA7wEGffsECV5ZexToK9oNRSeISbZSq6DH6rW0JThv8JgXLdzEbqSwhzG/fEKi80I8Eq/5kS66Rp4m2YL9zsY337Wp8qJIWEFF05Wyci5x7AJ20FG7jAz0gX1UCXbCb5Pl6pqXiW1E/CLHsZa3KHMtf4/JqIvFPPljGdg8l7//BNZFy+mwOeNPKOS9IRImRtBKCjT7CxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=luqCMIyJIQatGNbCkcH5bLWCxByY8hm/jUf+VMQp3f4=;
 b=U/dAPbA3FF1RQl19zgYBSpqjv0lafXS1+A6oj2ftWmPIpl5nEXFa6dIMLg8gOn7p2f3Kh3GeXtskLxxg6+/jTz/O3T4b0MoDzRTrCKoanzjMyN6g7Jzyu1O88Obz21OjDCDxl2UYqBSPblUhy4aYIGzPpCkYexUVBkfrtPk50rbKvt6iXNHokJB73WjwTqvpgFwxlPJN3Eoquphx86egjpTYJYCWmFvu1W4CnAXXbjD+P4WGoXqIlDIr3uAJNx4OtMrwd0Jh10feBh07TDdkk161rddXDQ1R0Amv8xtnWQz07tBk1fpfbd1to60rFiLWJgam02PlMVA7Ed6zn3qI0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7116.namprd11.prod.outlook.com (2603:10b6:806:29b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Mon, 3 Feb
 2025 18:14:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 18:14:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "pgonda@google.com" <pgonda@google.com>, "jgross@suse.com"
	<jgross@suse.com>, "Wu, Binbin" <binbin.wu@intel.com>, "vkuznets@redhat.com"
	<vkuznets@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
Thread-Topic: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
Thread-Index: AQHbdeRiwegNjOp2EEirKtkE9yTgJLM14ykA
Date: Mon, 3 Feb 2025 18:14:33 +0000
Message-ID: <dbbfa3f1d16a3ab60523f5c21d857e0fcbc65e52.camel@intel.com>
References: <20250201005048.657470-1-seanjc@google.com>
In-Reply-To: <20250201005048.657470-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7116:EE_
x-ms-office365-filtering-correlation-id: 6e71afa4-57b9-4c69-8f52-08dd447e9c0a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NDZES1BPUEZraXBwMnpMcEQ3aWZ4OHNPMFdQd2szWHdPWWhxek92S25JOEdt?=
 =?utf-8?B?UTAyMWFlQlE0MGFoODNMOFJSM0JabjlEbkZNTDRhT29xN2l6OGhBRlg0SFdm?=
 =?utf-8?B?QlIyWTYwMGRPZkZqU0VNUmNvTFBhWkZoMXRJM1FiMmxVcnJrQnlTbmN4NG40?=
 =?utf-8?B?RHdDQ3FWRnd6dlhIcGUyWjh3VG1mNWxNd3V5RzBWWGxXQjRqY21qVnZhcnp3?=
 =?utf-8?B?R0puVm0yZHovbG82WktZWnZiTnkxQ1hKUHRlVFFiYW5BbE1COGJVK2c0SWR5?=
 =?utf-8?B?VGF1QndkWnlYR0lqeUd6cEIybFBoYmRFRmxBekNnbGRZREQzeENlWFJzcVFE?=
 =?utf-8?B?amlWZWFiTkNuMjR4bEk1MlEvUlRMK25mRXhZWTRJV05tNVh1cDVNQjJkdERq?=
 =?utf-8?B?a3Uycnh3RjloM3l3Um1ueHZEZlBUeDNJWGlBRENzR2NWV0RURkxaOXZDZWZm?=
 =?utf-8?B?NnowR2pkM291Zm14UHpJYTh4b2MyV3dRR3R5dkNwVFYwdUZGVkN2Sk00MTNM?=
 =?utf-8?B?eEh6OWhaVmZaeHhLMEpkRDUzamtNVlZ0Tk1hT2VpRHdjbDZGMW5qd0tuL0Zq?=
 =?utf-8?B?SW55MnNVVlVWN0x6aEt5ams0TlFJMHVTazBhTGZTd2wra2NUMVJ3S3BONldL?=
 =?utf-8?B?US8zbHRqN2x2ZTRmSGNOMUZVRzFkNmtrNWVxdW8wTHV5UElzZk1hTDM3WTlv?=
 =?utf-8?B?WFNnSWhVVE0yTXU1aStTaUxGaEQ4WENlb2xJaXJtMHU1ZW1TL3JjR3hQY29V?=
 =?utf-8?B?c3Q3eTk5VnozV0t2aUlpR2FTOVN6Skp3QzhtZW9qdUxNaUlNQ1FMSk1jUkts?=
 =?utf-8?B?eHdEdVJxT2VhY1R0aTZWWUhiK0NtZ1pWYmprWWdCdTRkTTNZS21ldDhFNmFH?=
 =?utf-8?B?ZGQ3NWMvam0welR2M3RJM0hRY1JxWjYyeXRTSE1jckRUMTRhMW9LWXF2VHVE?=
 =?utf-8?B?SFk1YUJqTkpaQVlhNUxYWWJZUDk2blU2MmR1OFgwaVpTWklqSTl3dUdzamVW?=
 =?utf-8?B?R3JkZUF2YjVWc05BdmpUaHpuYlJGQWdTU3hrdThjMzBDVWZ4WTRGbmt5TUlx?=
 =?utf-8?B?N0t6S0xRZXF0SGpqNWFuQ282bWJlanJvWUx5NUdJWjNlUFNGR3N4MUhUaVVl?=
 =?utf-8?B?UEh5UDJpM2pLOG9CMlNCaUx6MUZxRkRxL2ZqM1RDaGIxalBkZTJ6aTFhNlJa?=
 =?utf-8?B?SklLMHNiWmkvdWsxVk5YdSt3ZFBxdldEd2QrcmliUGExWTcwZlNZcGJRbW9N?=
 =?utf-8?B?S2lRSzJmeG9BWG93d3RtY0dvaXUvVjVpUGxnUGdWWTArRUNOVThLMW4yNGdI?=
 =?utf-8?B?V2VSTkRUTE1aQTJ4VlRjSGZwS0RUWHRHVGhwSm1lZHMyM21aUnpaVzhSODIz?=
 =?utf-8?B?YWtLVy82L1F6VGY3WWFSelRydHpSQnF1RmljR0tGdUg4dnVpQ3c5RjhldGlS?=
 =?utf-8?B?SXdnSVRpYkFLdDRlVzlxcUFFa3J6T2xMZ1dEcHZ6N0VvMlM0NTJ1UGhJQW9Q?=
 =?utf-8?B?dGtIRnQzSlpwQ0sveHFIVVZJanB0T0drK1ArbVhzc2dBQmh2SG1Fd09LL1Vk?=
 =?utf-8?B?T084K0Y2Unp4SHdSZ3pUdTlnSElaMy9WMTE0cTNpOEFEbTRPTnpKc3NtSENH?=
 =?utf-8?B?K2o4T0UvbThya243b21Hd2htMmxoN0s2VGlzZmJka05oYlJ0dWg0cmNKS01i?=
 =?utf-8?B?SGdWdUNWRHR4U1ZXNDRtcXNScFhXUkpHZWVUOWRVci9YMXJlYkJ6R3FGTTJ6?=
 =?utf-8?B?bDhyZTZvdkVCWWJhYkIxZmFNWGpTZkhBVDQ0cnJwdkovUDh5M2RMK1lVbzhI?=
 =?utf-8?B?b1paanlWekNWS0RtZWxlK2h5QzhuTEdlamVCSjhiMDgyMWtZaWtnNENQU0c4?=
 =?utf-8?B?VFlLak1FY2lRU082aXhZNEUvSzBOblYydGRENEJ4Ymo4cnBrZ1kxOVFMQjZW?=
 =?utf-8?Q?hlmoMRPePCIiiSVxqnMVLaz6pwvC6AMJ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkpQc3M5Qnlqc041cnR0alMzTEhIRUJxNXZxMUEwUEV4L3R4NnQyaU0zL0E4?=
 =?utf-8?B?VXVmUXV3Wk1PcU42M283bzFLRE5LNkkzZnpqd0pOdjZFUUtaSVB0eUtoUWQz?=
 =?utf-8?B?UzJUb3FSUXRrRnFHb1NnN0llb1lRaTR3Z3k4cUh1ZStWQ0lRWEt6QVdkS3d2?=
 =?utf-8?B?NmtUd1RjZ3VaVjZrU0NYa2ZOZGdqelcrREpDUndsS0hKaGRSd3FJTjVsYjg3?=
 =?utf-8?B?ODk0dGluVUxHOHB5czZES1Evb2pyR1pHUGtRRW8rU0dRd2dTMVhpVWNQRTIx?=
 =?utf-8?B?SzFiSmVubnVVYjFscjR2TlJqMGNtbVhEaG03bmNmQUxhRlN2ZGcybndPV3Rm?=
 =?utf-8?B?bWd6VFJWTWgxTmc3OGUxcDlPQUZWSnJLOXFMckZxS2tOdDNRdnVCOHcxSW1k?=
 =?utf-8?B?M1N1dXhNUHRXQUpHY3gxaWpRV3JZV09CRE5XTWRjN2JMVTllMU12WU5lQlVy?=
 =?utf-8?B?S0ZZakZZVTNod1ZCa0xkQ1ZrQWp2aWQvTEIxSjlOZENKMFpFbDJQOGhuZ0ts?=
 =?utf-8?B?M3g0dnBhbnlMQktZSzV1MFB4bk1nWDVHZW1YWkNPd05SZlU4RGxHMnFkbFVB?=
 =?utf-8?B?NEFrcS9YRDVXaHM5aUlMaFNIWS9NVHBGZkxKTXZhNlAzVEVCdVNRemozc2gw?=
 =?utf-8?B?RXZ0Q2dNTTc1dlpxSG40RGpnU3NkRHF6N3l1RGkzczdOZEp5ZFpmSm9Pa2F2?=
 =?utf-8?B?Nmxmd29rNmttc21rcTZyOWJ3OStxb3VhRld1MFY1a0lIa0lrYUJGTHhYcXhU?=
 =?utf-8?B?dW1HdHAwMnVyWU90NXlwV014SG0yQUVYd2l0eEErOWQyRXRpS0JHeVpYTGFY?=
 =?utf-8?B?MmlxNXFoakUzSXlpKzNUblZya3RDYm5oRW10djhDUGdWT0hTSytCUFRPWHhX?=
 =?utf-8?B?NGFpd2YwNG1YdkNWQ1F0M3YvRFRWemx3Y0Y1MTViOWxIWHVhWTNpYW5oZ3g5?=
 =?utf-8?B?andGTUlySDJ2bUYzT3QrdDdUR242eEhMOEt6TDVCbkY1VHF1ejJCbGIvc2pY?=
 =?utf-8?B?dklXVkNyTTVLS1Z2UU9salRQQS9WSWtPN0Y2WFpnRVVMRnY4WTNuOEdwNnA3?=
 =?utf-8?B?WmFYYW95RFdqRFROemZxNXlsci9PN3orOU5sTnk3UzE2RUUyL00xa1MxRURp?=
 =?utf-8?B?ZzczUFF0UUZDK1ZLY3plYVhJWWRQNXkwOVZJOXNFVXFQTWF5cm1IUlFSOTZN?=
 =?utf-8?B?dDhjWHVWbWwwQSttQnI3UGF0Um1FRHJpeWlEM2o3ekRrcnNGcTFwWk0zZFRJ?=
 =?utf-8?B?aXlBQlpmdkwyR3NzSzErVjJSdE5PT1p0NFRjZ1hmZDBHcW40ZkI0WFhibTE3?=
 =?utf-8?B?bDBMNzVlOUdjaXRwZTRaYTZTWGJEcHd3U3hGckgvanNwd0dvT2Z0S2J5alhW?=
 =?utf-8?B?V29qRHMrdCsxM1RCZkErclAwK3lsclBnUDRYa1pSVW5KendZcklkK0U0SHgv?=
 =?utf-8?B?Nys3ajMvQy9rSVpaVDhQcFRjVEFkeW5PSTNHeHdiUkhvLzRuYVZHSlgxRlhC?=
 =?utf-8?B?Nml6cndxb2NjNy9Wb05Cb1lrT2JBVmJoa0dSR1NmblNKUVJRcVBHQ1ZyN0xY?=
 =?utf-8?B?YkNCSFF3V21PVmRzRzVPMkJMT3VMNFYzVENnRjBTY1I5aXF3MGkzeUlsa0Rt?=
 =?utf-8?B?N1laZEc3cjkzVzdKeWFaTzBZY3R2bXlYeWwwN0lyM2ozY2tPMFRCTU45SFgv?=
 =?utf-8?B?TEl0V0ZZTUxqOW1KdG9GZytHVDRBY1dZUVFaVGlBTlExcW9oRGRjQXl2MmJJ?=
 =?utf-8?B?ZVlMaDZ3d3NWekF4cysxVnd0ekRHZVFRQXNETCtpTldHTTczYzdNaVRrZFEz?=
 =?utf-8?B?UExydlVZbXoyQVhVeWw4NFZRZDhMdmZQVEhSL1YxNW4wbEdHd1VVOWpRSkRM?=
 =?utf-8?B?MUVsWkhvUWt4K0ZlUjdQTkY5dnR2Nis3MFJudkFlR0k2bEdmNlF4bTFLczFF?=
 =?utf-8?B?QURuU1FrOHFta3hNbXRWZFZuN013R2VaQVJmRklaT3lVK3h1MDVycmQyYlZX?=
 =?utf-8?B?S2tpYmFHaWt2Rm1Ram5YMDRnS1RWWVQwbGc3dlR0d1VSMklTZGlSZjdHeU9l?=
 =?utf-8?B?QkNLVERXY1JzandmYis2K3FGSVZUSWxxVkdDK3ZjdXczWjJkQW9YRHlGSFll?=
 =?utf-8?B?akhHUHZwbHd6aW5PdmV1aWtJMm1VcnVtZnlIaFFlOFpFSkYwNk5jazBNK0lO?=
 =?utf-8?B?aHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <769319071B7DFF4FA31FD22AA2FF526F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e71afa4-57b9-4c69-8f52-08dd447e9c0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2025 18:14:33.0401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JTLyzcMRO5/TrWwssBoZhKF+8DrcJ7ipoYqqjsqolp7CsfvAIsCBhGUd6CLKvvQwOIrQ47FZ05JffRlfgfoWeQGHfrMBMF98yL2FvBoyiGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7116
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTAxLTMxIGF0IDE2OjUwIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBdHRlbXB0IHRvIGhhY2sgYXJvdW5kIHRoZSBTTlAvVERYIGd1ZXN0IE1UUlIgZGlz
YXN0ZXIgYnkgaGlqYWNraW5nDQo+IHg4Nl9wbGF0Zm9ybS5pc191bnRyYWNrZWRfcGF0X3Jhbmdl
KCkgdG8gZm9yY2UgdGhlIGxlZ2FjeSBQQ0kgaG9sZSwgaS5lLg0KPiBtZW1vcnkgZnJvbSBUT0xV
RCA9PiA0R2lCLCBhcyB1bmNvbmRpdGlvbmFsbHkgd3JpdGViYWNrLg0KPiANCj4gVERYIGluIHBh
cnRpY3VsYXIgaGFzIGNyZWF0ZWQgYW4gaW1wb3NzaWJsZSBzaXR1YXRpb24gd2l0aCBNVFJScy7C
oCBCZWNhdXNlDQo+IFREWCBkaXNhbGxvd3MgdG9nZ2xpbmcgQ1IwLkNELCBURFggZW5hYmxpbmcg
ZGVjaWRlZCB0aGUgZWFzaWVzdCBzb2x1dGlvbg0KPiB3YXMgdG8gaWdub3JlIE1UUlJzIGVudGly
ZWx5IChiZWNhdXNlIG9taXR0aW5nIENSMC5DRCB3cml0ZSBpcyBvYnZpb3VzbHkNCj4gdG9vIHNp
bXBsZSkuDQo+IA0KPiBVbmZvcnR1bmF0ZWx5LCB1bmRlciBLVk0gYXQgbGVhc3QsIHRoZSBrZXJu
ZWwgc3VidGx5IHJlbGllcyBvbiBNVFJScyB0bw0KPiBtYWtlIEFDUEkgcGxheSBuaWNlIHdpdGgg
ZGV2aWNlIGRyaXZlcnMuwqAgQUNQSSB0cmllcyB0byBtYXAgcmFuZ2VzIGl0IGZpbmRzDQo+IGFz
IFdCLCB3aGljaCBpbiB0dXJuIHByZXZlbnRzIGRldmljZSBkcml2ZXJzIGZyb20gbWFwcGluZyBk
ZXZpY2UgbWVtb3J5IGFzDQo+IFdDL1VDLS4NCj4gDQo+IEZvciB0aGUgcmVjb3JkLCBJIGhhdGUg
dGhpcyBoYWNrLsKgIEJ1dCBpdCdzIHRoZSBzYWZlc3QgYXBwcm9hY2ggSSBjYW4gY29tZQ0KPiB1
cCB3aXRoLsKgIEUuZy4gZm9yY2luZyBpb3JlbWFwKCkgdG8gYWx3YXlzIHVzZSBXQiBzY2FyZXMg
bWUgYmVjYXVzZSBpdCdzDQo+IHBvc3NpYmxlLCBob3dldmVyIHVubGlrZWx5LCB0aGF0IHRoZSBr
ZXJuZWwgY291bGQgdHJ5IHRvIG1hcCBub24tZW11bGF0ZWQNCj4gbWVtb3J5ICh0aGF0IGlzIHBy
ZXNlbnRlZCBhcyBNTUlPIHRvIHRoZSBndWVzdCkgYXMgV0MvVUMtLCBhbmQgc2lsZW50bHkNCj4g
Zm9yY2luZyB0aG9zZSBtYXBwaW5ncyB0byBXQiBjb3VsZCBkbyB3ZWlyZCB0aGluZ3MuDQo+IA0K
PiBNeSBpbml0aWFsIHRob3VnaHQgd2FzIHRvIGVmZmVjdGl2ZWx5IHJldmVydCB0aGUgb2ZmZW5k
aW5nIGNvbW1pdCBhbmQNCj4gc2tpcCB0aGUgY2FjaGUgZGlzYWJsaW5nL2VuYWJsaW5nLCBpLmUu
IHRoZSBwcm9ibGVtYXRpYyBDUjAuQ0QgdG9nZ2xpbmcsDQo+IGJ1dCB1bmZvcnR1bmF0ZWx5IE9W
TUYvRURLSUkgaGFzIGFsc28gYWRkZWQgY29kZSB0byBza2lwIE1UUlIgc2V0dXAuIDotKA0KDQpP
b2YuIFRoZSBtaXNzaW5nIGNvbnRleHQgaW4gOGU2OTBiODE3ZTM4ICgieDg2L2t2bTogT3ZlcnJp
ZGUgZGVmYXVsdCBjYWNoaW5nDQptb2RlIGZvciBTRVYtU05QIGFuZCBURFgiKSwgaXMgdGhhdCBz
aW5jZSBpdCBpcyBpbXBvc3NpYmxlIHRvIHZpcnR1YWxpemUgTVRSUnMNCm9uIFREWCBwcml2YXRl
IG1lbW9yeSAoaW4gdGhlIG9sZCB3YXkgS1ZNIHVzZWQgdG8gZG8gaXQpIGFuZCB0aGVyZSB3YXMg
bm8NCnVwc3RyZWFtIHN1cHBvcnQgeWV0LCB0aGVyZSBsb29rZWQgbGlrZSBhbiBvcHBvcnR1bml0
eSB0byBhdm9pZCBzdHJhbmdlICJoYXBwZW5zDQp0byB3b3JrIiBzdXBwb3J0IHRoYXQgbm9ybWFs
IFZNcyBlbmRlZCB1cCB3aXRoLiBJbnN0ZWFkIEtWTSBjb3VsZCBqdXN0IG5vdA0Kc3VwcG9ydCBU
RFggS1ZNIE1UUlJzIGZyb20gdGhlIGJlZ2lubmluZy4gU28gcGFydCBvZiB0aGUgdGhpbmtpbmcg
d2FzIHRoYXQgd2UNCmNvdWxkIGRyb3AgYWxsIFREWCBLVk0gTVRSUiBoYWNrcy4gKHdoaWNoIEkg
Z3Vlc3MgdHVybmVkIG91dCB0byBiZSB3cm9uZykuDQoNClNpbmNlIHRoZXJlIGlzIG5vIHVwc3Ry
ZWFtIEtWTSBURFggc3VwcG9ydCB5ZXQsIHdoeSBpc24ndCBpdCBhbiBvcHRpb24gdG8gc3RpbGwN
CnJldmVydCB0aGUgRURLSUkgY29tbWl0IHRvbz8gSXQgd2FzIGEgcmVsYXRpdmVseSByZWNlbnQg
Y2hhbmdlLg0KDQoNClRvIG1lIGl0IHNlZW1zIHRoYXQgdGhlIG5vcm1hbCBLVk0gTVRSUiBzdXBw
b3J0IGlzIG5vdCBpZGVhbCwgYmVjYXVzZSBpdCBpcw0Kc3RpbGwgbHlpbmcgYWJvdXQgd2hhdCBp
dCBpcyBkb2luZy4gRm9yIGV4YW1wbGUsIGluIHRoZSBwYXN0IHRoZXJlIHdhcyBhbg0KYXR0ZW1w
dCB0byB1c2UgVUMgdG8gcHJldmVudCBzcGVjdWxhdGl2ZSBleGVjdXRpb24gYWNjZXNzZXMgdG8g
c2Vuc2l0aXZlIGRhdGEuDQpUaGUgS1ZNIE1UUlIgc3VwcG9ydCBvbmx5IGhhcHBlbnMgdG8gd29y
ayB3aXRoIGV4aXN0aW5nIGd1ZXN0cywgYnV0IG5vdCBhbGwNCnBvc3NpYmxlIE1UUlIgdXNhZ2Vz
Lg0KDQpTaW5jZSBkaXZlcmdpbmcgZnJvbSB0aGUgYXJjaGl0ZWN0dXJlIGNyZWF0ZXMgbG9vc2Ug
ZW5kcyBsaWtlIHRoYXQsIHdlIGNvdWxkDQppbnN0ZWFkIGRlZmluZSBzb21lIG90aGVyIHdheSBm
b3IgRURLSUkgdG8gY29tbXVuaWNhdGUgdGhlIHJhbmdlcyB0byB0aGUga2VybmVsLg0KTGlrZSBz
b21lIHNpbXBsZSBLVk0gUFYgTVNScyB0aGF0IGFyZSBmb3IgY29tbXVuaWNhdGlvbiBvbmx5LCBh
bmQgbm90DQpvdmVybGFwcGluZyB3aXRoIGFyY2hpdGVjdHVyZSB0aGF0IGV4cGVjdHMgdG8gY2F1
c2UgbWVtb3J5IGJlaGF2aW9yLiBFREtJSSBhbmQNCnRoZSBrZXJuZWwgY291bGQgYmUgY2hhbmdl
ZCB0byB1c2UgdGhlbS4NCg==

