Return-Path: <kvm+bounces-67719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF6AD11BE4
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 11:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CECBC308AC05
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524B527703E;
	Mon, 12 Jan 2026 10:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CPb8LHZT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438B81C84CB
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 10:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212507; cv=fail; b=SsWVT1VTCI+QJevACFp/OeMRHzByuXkfEeKgpisi+/lIsHeialQF7cXBg+0XbNMmEoYju4puSqQtL2NvsGI7giIp0xL2g8t4e6QPBZgGlBJnkSrzH4Xu+VDa9bsgDk8fPTuN0nDpv2i0q+eHpwA+2tfhIZ/ZMVKz4SYgkqNN5Vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212507; c=relaxed/simple;
	bh=Yr1ICbENrIgyehUmXkjCqzii/5Tu4l13h2j4OVtNib8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r5auL0/9ikYfxv7Tg7hvWN2cVXPm08wIeNB5Xc46lmYbMcy3UG0tHiimOxVRHaxDMNIB/eXLB5vFr5ZOXo1jcSQS863d9PVBGUs85hhcub1yXSP8s/Qu0KqfQrLAkGk5Mdjq2r+oH/BCgmnU8INP0cPgQFBn7iR2Ru4rWRjGz74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CPb8LHZT; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768212506; x=1799748506;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Yr1ICbENrIgyehUmXkjCqzii/5Tu4l13h2j4OVtNib8=;
  b=CPb8LHZTb/7zfnMxUoE8oBh5arcCD6iwuZEXZYD+TMyZ/P+Gmvtd0WH2
   azKhZo/UV44ytaGDLWOfvwwEHWoTxyz7C3bXi74sfSeqF1q848oxVPR1g
   6VgMezUkv9XLAalEGlMk2LcdyXMPQWtQIeqmM9F0KOEHqfrwINwcEFB5X
   Pos5XAcv7hbRrLnHgNr003ud4L7PlKtza84k+hWDx49iOZRxwRt4ULk0j
   EveyLMKPU0G4qdyzIuhL/um7Fx0zzRBfG6a+ikVcpQN0CzVYnlUAPK5GT
   Es8rA80gH2P6sdTQkCipODp4bKMB8WxOxbR9jpeN1RfTpL/ZYrWxkPttZ
   Q==;
X-CSE-ConnectionGUID: suqpefp9QsC1JcpRd35w9Q==
X-CSE-MsgGUID: ZQrvLw+vRaClLRQYXw5+XA==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="72061576"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="72061576"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 02:08:25 -0800
X-CSE-ConnectionGUID: 65QRugO1TPmDvGeHwkY0oA==
X-CSE-MsgGUID: MGs7omkNQ3aaVCzQ+J87hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203962445"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 02:08:25 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 02:08:25 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 02:08:25 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.49) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 02:08:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q+ZLFSpKe7z8dSHXU1dHEKjpXoHSkhszo6MEKmqs7SZLoaKFfaR3W/K7li857YG79myVIvMBxQxhJQdUkum+WJzWaWeja7vbalCJeekjwrgI4Gf8XDp4z+Rfks+3baj+SPzsBirdISKyH0YSAs/ZKb6BM1zVi0Fb9cW8r/Ml2OFx6WlDzEj0/RQKfAV8J/jOn2q5AeR5+0xwyNIoVb2Vnwi3b+EeoKLnAJwrouWazCOYXWgnqF8oioJOvfweMxiG6jsM7QA8s3w7CmhuwntaTyRI1LcHb2k46eL/m7mCbYLY9lHWtcvrvoCHEY/VLV0QFjsn2bU9/2FwIqLokyuBKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yr1ICbENrIgyehUmXkjCqzii/5Tu4l13h2j4OVtNib8=;
 b=ta5d6OUNuI7AJU0b3R06eWtnrLhO4+udlzIH2YbG+wq/2ULd7LE53z6M8QP+4AaI6lFIVGBsNLzfir6YI+lS7VYl7nTouI6iXyFczuuht8yPgUaf6RjOfqlZ2G8LRSkiM/H07+sE6JqRJKPzt4mrSolA7Ckgwvns1INytZNvy56heECA9cSAdVdOq6Yw9+29RbGxsuOeAom4G95pALWWRkx0ow5V/3xqHVcnRQpEqfbUCPThJMC+U9E0TTpnvQgHCpKCxYE9M6oGf0DbUCAVJUFkMo3Kj02DMDDPZA56xF9la6mMbAfzesYlx/vvSGbpeafmAPme76PKcl/hsPKnfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB7970.namprd11.prod.outlook.com (2603:10b6:8:121::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 10:08:22 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 10:08:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v5 4/8] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Topic: [PATCH v5 4/8] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Index: AQHcfg2+g3iG/lPJIESQXTfla1BNtLVOWqSA
Date: Mon, 12 Jan 2026 10:08:21 +0000
Message-ID: <44a4d5832b497cd666e9a273f9595cb2be16c8dd.camel@intel.com>
References: <20260105063622.894410-1-nikunj@amd.com>
	 <20260105063622.894410-5-nikunj@amd.com>
In-Reply-To: <20260105063622.894410-5-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB7970:EE_
x-ms-office365-filtering-correlation-id: de1bafce-e50f-44ba-9ac3-08de51c28469
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bkhKQVhvTW9RVmo0OHVEdlIzcXk4K1p6bks3OW5iOU5COUlja2diWWdlcGtr?=
 =?utf-8?B?R3lzSFBoZ0xnMXhyd05PRTJkSHNBbTVPaDQ0N0lnK1pmcmdGY3BEeG0zWXZF?=
 =?utf-8?B?dXNXOHUvZkkyV2liQ2tlOWpoOHNSakUrTUkwYTBOallzeE9ObmxNVWE5RW13?=
 =?utf-8?B?cmF4ejJxUGg4OUdXRWtMRFo3T0U5b3VNODlHQjd2cWEvRTd1b3lKOWFwSEdF?=
 =?utf-8?B?Y2FFWklscUU0WXNXaGM0ejZDV3dtUXJnaFZ4czNialdJMnp5cm1teTBqNVNV?=
 =?utf-8?B?N2hVdUQ1ZlYvRUhjSlBGMWRBY3JaaWV3bFZPZXh2R3FGeExZNzBFVWEwcDlK?=
 =?utf-8?B?RjVpZmtsd1FxZk8ycHV1WnRsQkRQMndFWDVYTDFMamQydHhEQzJRWERMNTFT?=
 =?utf-8?B?VnBMdHYvcktHRnFvUThlOSttdktGNU1nNkZHVDhIR2JsUXdVODh1cmtmS0w1?=
 =?utf-8?B?Z2Z0ZCtEdTVuc0lhMjFkRjhJWjdCU3d3UGU4UlN6Y0k3UmdlODlIWWVoOWht?=
 =?utf-8?B?aVdLUS9EeHpoem1DSVptWU1HSEErZW5BV0NzbUt1QUhNVEw3RDJwVnN0SjdP?=
 =?utf-8?B?djFoNFVRS2JCMDQ1ZU9Qc215NUpRRVN6VlhpRlBPUDN5cU9DL085cFQ5UG04?=
 =?utf-8?B?Q2NLcHdiRE5DLzd4MkplRUtweWx1RWJnT3R6eXZvaWl5WitWMmp1d2thUHg0?=
 =?utf-8?B?M1gxRXBURHg1OXJweG9XdzRNaFR5SG1yeEJvVFkwSGVJTDk0QTFQNzIvYkEv?=
 =?utf-8?B?RWRsMnFuMlhZNnNXUXdZTlZsRS9iSDVkd0IrQVFSWjJzU1paaDJXMGFUVVlT?=
 =?utf-8?B?M0xMd2NxM0RabHZWN1ZPNWF1eVdJSHpqcHluUzVGdUVEcHoyckp4NlMxNzJs?=
 =?utf-8?B?S3dJMkgwdHlEMlA5K2ZMdUYzZ3BOVHQzTXVDS1orYzYxQjhMUTRCRXZEcU1B?=
 =?utf-8?B?TkpzUUFxL1RpK01TL3l1cklIMXVrbHVJbExJYnl4UVVwOXBIL2wvRituVDEy?=
 =?utf-8?B?ckNjWlFvYVdtUVBvVk5Cc3hheHhMZU5ZNVRFcUY0WE1la2ZNcUZWbHJjOWJH?=
 =?utf-8?B?a09FRGN1ZUtNTURvUFRwUWdwNzJsa3c4Kzl5NEwzSkpCRURmaEoyejdvdU5H?=
 =?utf-8?B?R2NVbURERkoyS1lCb0FQTXM2bmtCdXozcnhEQTAzeGU1NGowdW5IbEVuYWhr?=
 =?utf-8?B?Y3FrTjhsQi9qanpuaHFBb25jRS91TkhMMkIzU05qZzNWUm1RVUZaVnhjWSti?=
 =?utf-8?B?NWJTcEJjRHJYSUszTmxwVm1lWnhoRVVIMlRaR01Ha3Ayenp5YXNMeGhyMlpp?=
 =?utf-8?B?cCtDdlRndzFjQWgyYit0TU15TlVVUXh6ZVkwTnlzbWhGOWk2UUJnWm1nQnVT?=
 =?utf-8?B?WTdwZTZORitCa3BPa3JBdnZ6SlNKYlBHay9VZkFRYlY5ZmE4cEFnbXdyWTBV?=
 =?utf-8?B?ektEWGVSUEkyalhYT0Nqc284dk10eEVMRXExdC9ORUs1QUFPZ0NtTmwvZjZm?=
 =?utf-8?B?K1RRaHRaemo4RERZQ0hGUlhHUjRvQ3pVYVZCR2toUzFPLzNBbWN5TVIzSE85?=
 =?utf-8?B?dFNWdkhRMS9vQ09BQ0FLaE9oOTE1RFM3NXlIRUR0bnc2aUgvZ2RPRHhzQXFD?=
 =?utf-8?B?bE5RM1ZZVjk0U3F4MmZWTW5hUzljZHdXRXhRUHF2RTJoc3ZNSzlUYzFoWE4v?=
 =?utf-8?B?M2RkeXVzc3ZFS2F0SThPV0JvemdWK0JuWGNvV2phYUJyQ01NZnE5NDNkYVBV?=
 =?utf-8?B?WGYvOXpTZXJZQWVyK1NSSjdoV2VLVEEzYVhDblNreUVDUXVoWU9BNVdmMXpk?=
 =?utf-8?B?VW9uTWt6OVNxai84OHR6WTViZ1RzNUM2czg3aFBTY1pIbjdmU2NCamhSL1pH?=
 =?utf-8?B?Qnk4ckJqY3ZKalhMOEFjYWx6d2NiVWpydGhwYnpKRitZaGFyb3l4a1VNaVov?=
 =?utf-8?B?SWZQbG8xMHlHL1QwcTk3aWpkM2E4RVJRSE4zdDNtenh2c3BsRUNJTmlEUDRn?=
 =?utf-8?B?RkhHc0tMdzVGUnVuTEc4NnJOUHo0a3o5U3VnV0dlTyt2ekdvZTErdXlYL21M?=
 =?utf-8?Q?5sZjUI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUxVekJqOThMNElMd0dWckNuaW5xL2VWWXBDNlN3NmhKcXA4d0JTM2VzbU9i?=
 =?utf-8?B?N1d1QlpmOUo1OXVDQUNZRnQxWnF2UktMd1dmSGxybURvdDIxbnhBdDlqTWhn?=
 =?utf-8?B?NnNpRm9KQXNDY0xPUVExYnpRSDZNYitLemdldzdvWmJkMlkycGl1dWJHSjdx?=
 =?utf-8?B?Z2FQUlhnczFoc1owaE5MMUJqcUcxUDVpejMvWHpkSyt4YTJUTEQwbFRGak9Y?=
 =?utf-8?B?bEh5UStDQk5Ha0pHc0Y3NGcreDYxclcvNXZES0ZBZVBEcU9SUWtMd3M1VHBt?=
 =?utf-8?B?Z0wySlVaY0diM2k2VUI0cnlIbWpObllKc3BES2QwdjltdldVSTFDVU1vM2xI?=
 =?utf-8?B?VnZLYTluK2NrVVZCd1JVSG1ScEkyWkpBUHk1OWdod1huU21HeVd0ZVVldEQ3?=
 =?utf-8?B?UWRwNjdRc2ZWb0t3WFZ4aTA4UG9rSFAxdmlPMUFVRnluNTdFNllFZTBkUnFj?=
 =?utf-8?B?eG9HLzR6NnpkQU4zcld5UndCMHpoTEIzZTlzWmMxV0ZlT3VVY2FTNDBpaG1o?=
 =?utf-8?B?bVNDc1JPdWpWRGlBV3E0ZVZyRVVqcUZMREpUUmE0ZE1NaGhRa3R3cVlkUHZF?=
 =?utf-8?B?RUR5RVVLckZsczhzbjZybmg1bDlqK0FYS1QyUnA2aXBacFBETnFjYm1iVC9k?=
 =?utf-8?B?MFAwcFJlTnFEeitSMTFUZXRBNUYvRVlNTGtQTGdrNVJpVWpYM0IyVFUwOSs2?=
 =?utf-8?B?Y2l5Tm5rU2Z1cEtvbFBxRWYyMEJ6eXpHM1ZRWHZneTFJWlJ2YkpzemVBeWdo?=
 =?utf-8?B?NXJERXpoWXIxTUdIUjJGUjNMKzB3MEN1QmcvOWc0NWtvbzczd0JVYW9vbGVH?=
 =?utf-8?B?TUUwYVgxMllpa01RNTlPT3FzS1FPbzhHUjRpWmtQblRuVm9CMWdkL29KMmZj?=
 =?utf-8?B?dURicytGQWl1RjYwQU1uNnR3aER2TTVjLzRoYS9lVEM0M3RYc0tJMkVGRXly?=
 =?utf-8?B?eHgyZW10by8yTGZ1TGJjWDdTcnpsZ3RjWThzQWFGNldDcGFqK2JsZGdtaHBP?=
 =?utf-8?B?WkVpNGp2dHlGZnI5OHFzMWltMW5temxrejhEeTNQcGE2RTJFeDd5NStzaFMx?=
 =?utf-8?B?U2hpdmxjLzAyZE1QK21ZeU9SdlY5V3JJaTJTQnMyVVFiNWhKNDlYdGFCVzJN?=
 =?utf-8?B?YVJ4NXhJQmtHZWMzaUowWURITm8yT0YyL1dCQ0l2K1I0aXlRbk1IakFFcmw4?=
 =?utf-8?B?QjNhSXZGTmt4bW5HWk40anhxRWVSQ0VnMnRCUGdMdDh6bUY1MVZ3RXR2aUJu?=
 =?utf-8?B?em01Nk9reHFkUjYvZ1VFa05XQkJGSWN4Zk5qQ2JWcE5EbEpiRmVTZHllL0Fx?=
 =?utf-8?B?ZkVabkNuU294SHR3T2IrVkd4MHJXcGxrTWJUTEVjZXpHWlk2MWtxQWlrOTVU?=
 =?utf-8?B?czJQbzN4anl0R25UdjI1a3FqQzFRQklZYktPemZxc3hGeVVpclZDVzhZanF1?=
 =?utf-8?B?cUk4aXVqa3NOUk9TRlVKdTdROXZuQzJmRXNaWm1YUWRoLzBubFhYQ0lId1Bz?=
 =?utf-8?B?SEJTUC9Kbk12ZmwycE40aVdpK3kzdHN3QlhxLy9wNXdidEg3NWxUa3FKbnph?=
 =?utf-8?B?aXR6YkVlR3BDU0dmMk1Hd2wxMi9hMUFtSjgveUp4V3FkNEtuOThiRndTVW5o?=
 =?utf-8?B?aENBNFBNTTMyUUtJaWJway9QeVJMMzZuQ1d6SGY1cWJsS3hMYVl2c2IwQTVl?=
 =?utf-8?B?Ky85R3haL1N5UlVzdllSb1FpZU9vQ0RGeUptN3A4bUtES1pHNlJ1RnFTM2Ru?=
 =?utf-8?B?cWhwS0pUSlgwRTNSeG9aTW44eGtBQ1BIL08zTTdvUmV3R0VUb0lGYmVOa0hD?=
 =?utf-8?B?Q0s2SDFIUmlXdnZFZWJlQU0wOVZUVzRhN1M5bG80Vlh4VnBmem5PWEZoZkkx?=
 =?utf-8?B?SVc2M2NsNEMwekM4NFAvNnh5ZGs2VW41SkNKQTBmUHBENGpVWWg0OWpFOU5C?=
 =?utf-8?B?NjVXRmI1NU9ybk5qZ2w0VDNEVjVnNzZacXAwU3FvYW5WVWl1VVM0UXVYRUNI?=
 =?utf-8?B?MFk2SFJ5Q2huYk9uYm1leG9XZ3kvcGwxOGJMeUxVaHhSZE01bUNOYlhqc1g5?=
 =?utf-8?B?a2Y1dU1WME53VEVZcDFsRXFhZHJKcm9uZWNURmxVTVdGSFNUdzVtOEpXSTJ5?=
 =?utf-8?B?dWxvSVp2ajhHeFBKYVREOG82NzBONUhBSWJPOXhja2RBM21nbmlRdGZYQTRO?=
 =?utf-8?B?SEt0OCtPM0hYTC93eW5Ba0x3eERnajkvYjJRcFFCd09ZVXNsTEpVbW9mZzJ2?=
 =?utf-8?B?akY5L0NKVGNmMEZuT3l2TnVhVUpZcEJjSkd4ZXk0dXRZSFVxeGxVRDFaYS9j?=
 =?utf-8?B?bzNLSFdtdndmME9mRVpaYjZrcnZnZldlQ1g2eDBhYmNSTGNxd3pZQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31EA5C1D3E697D4FADEFC5B540AB933A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de1bafce-e50f-44ba-9ac3-08de51c28469
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2026 10:08:21.9673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5QfIc6ouFoGi9ayOHQ9qy699Fw7p1hSAqjAAIWQ3IQ01wAxvvM9nTgjX4EgalfvOL0/OsXM0jTgrnqe/GjXWTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7970
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDA2OjM2ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gRnJvbTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiANCj4gTW92ZSBu
ZXN0ZWQgUE1MIGRpcnR5IGxvZ2dpbmcgdXBkYXRlIGxvZ2ljIGZyb20gVk1YLXNwZWNpZmljIGNv
ZGUgdG8gY29tbW9uDQo+IHg4NiBpbmZyYXN0cnVjdHVyZS4gQm90aCBWTVggYW5kIFNWTSBzaGFy
ZSBpZGVudGljYWwgbG9naWM6IGRlZmVyIENQVSBkaXJ0eQ0KPiBsb2dnaW5nIHVwZGF0ZXMgd2hl
biBydW5uaW5nIGluIEwyLCB0aGVuIHByb2Nlc3MgcGVuZGluZyB1cGRhdGVzIHdoZW4NCj4gZXhp
dGluZyB0byBMMS4NCj4gDQo+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBDby1kZXZlbG9wZWQtYnk6
IE5pa3VuaiBBIERhZGhhbmlhIDxuaWt1bmpAYW1kLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTmlr
dW5qIEEgRGFkaGFuaWEgPG5pa3VuakBhbWQuY29tPg0KPiANCg0KSWYgaGVscHMvbmVlZGVkOg0K
DQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

