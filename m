Return-Path: <kvm+bounces-51824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2E4BAFDB45
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 00:43:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1609E564DC0
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 22:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1DD261593;
	Tue,  8 Jul 2025 22:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j6L21yPm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083F8BE6C
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 22:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752014606; cv=fail; b=looRoe9UKiKn/ugVOVgZZTecaOlc2qrLKvLhXKfZGu9MyxpGhhzrWkVDQKZSc97ARk9Jzx1Wzc88zDMoyhlU2WEp576cvXMkbvtIOKJFoksTJAA2vs+aDt4n3EnOSN5/a/TMJoYtPO2V35NOs+6uOHuBGwV62hTOvYaKoyQx8zE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752014606; c=relaxed/simple;
	bh=DSLhkn1IWlmflHHiDs7zv8QUHArQfagQafQJEyqKW58=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tOB3L9hw1vZoSJ5lz68imTZjxlfzw5AoEVCYJj5FJNCuFxPPuZCJnX7Muft+WzGZ2NcoyU/xklprr9CtwNzWCXRrs1lX8QoELLNh5u7lcwy0pWRRoSj2TaIVB4qIV9JjEBQc+D9oYzZeOpKOXZnV64Axs4OxyOqh88nCawiodco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j6L21yPm; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752014604; x=1783550604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DSLhkn1IWlmflHHiDs7zv8QUHArQfagQafQJEyqKW58=;
  b=j6L21yPm6yfedcxARwZcuM/lfhaOX3Hl2+n6bxnl3hbKBC5cJOVgdmAT
   Ve2VvB6iBHfenMVFOsIeflozW7J/kh+2j9K7NvgxebvXxettwS54tfZUc
   Adcsn96EE5z2r2F0TGgqseXEDGgCWofBtYAS1s6nKh6cii9bsP7x956tP
   NYzy7z2Cq+XYqeLQ6YnnKHA5Du/yPNHE6sb3FCuSzc32xrZQCyyUgqYa7
   yI7AheyMSr9Nxlb3RrOZgZadZf5qIxSGL0iEHPnMO1hUBPmw4XjaF9uFu
   JITPFKAyxpabB8wOjeOHRbnWS3HlFp0k5li1KHKD+DzxfK7+I0xDNDAXc
   Q==;
X-CSE-ConnectionGUID: sHg6w2r0Q4ehSfunxOt+eQ==
X-CSE-MsgGUID: p09ToxkQSPOwXxRDOr+ucg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="79703534"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="79703534"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 15:42:40 -0700
X-CSE-ConnectionGUID: R1aInxk6RrClOuG0N9WqWw==
X-CSE-MsgGUID: YzrUxYhFSQi93J44WkCsNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="156098572"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 15:42:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 15:42:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 15:42:40 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.44)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 15:42:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c52Eh5GWBMS4WurAc1edQbBMnJVm4Z654Cxz2p3AG/n80qLRFpF7NMtYBU6UNCsDAHD4LTka5uWHGsaAG20PkSD66+7nKwDI9sa19WZNWFhjL8DyXFeG5ApHUajxgABrjRk05tRmKVeYd2wkt2NWzNz7tSE/HpAjof8gSu97xKpQQ773TsrB+0MwIUH3R9JuzbjBuHQff+UmW2lyvD/wzp13WE4SWPGV3kdHjeHgD8STL6tlY34Ek/izr4F953itw35NvlorfsSM0NIB0WgBh9oC9DYWGbdjetazG9v8glQF5mSrm+QDneB8P0tKjA3YTS1J5XFEPCotDRTaQ4lshQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSLhkn1IWlmflHHiDs7zv8QUHArQfagQafQJEyqKW58=;
 b=UcfxYwGl4YU6ES9hEZEr4bjJOpZZI0lr2XHSgRzU/eV0bhaWtb05ldApK+89Hymru2tWmDzMUgB1JM267rKMJv7HdXYvHs808hlkHV2WMWz0Vvw1unYGvojKCbD5ZiaYG2iJ33Er4d/g03VE99622Gbr2Ft7+/gXDAdJCsxzbH0xI/Sm2DBU0KJBAThhR5VHR1lZaAiJzjwqWQIkUfzF8QPMmfM1W9PPFS9CMXjvSa8frd2aK0kZgmuTDZMqSTm5DqMd+h/jBLOj2AnloSEs3C34wGQ1VKSgxzcjw53VZsfYVUXdt6MRozfxIp4VKT6mg9GbaLQ7I/j/zE3V1DhRDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS4PPF93A1BBECD.namprd11.prod.outlook.com (2603:10b6:f:fc02::3c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Tue, 8 Jul
 2025 22:42:36 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 22:42:36 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "bp@alien8.de" <bp@alien8.de>, "vaishali.thakkar@suse.com"
	<vaishali.thakkar@suse.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"nikunj@amd.com" <nikunj@amd.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Topic: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Index: AQHb7yd7VfkdP/oV20S9Gj+gph7qB7Qnf8YAgABJtoCAAEO8gIAAP10AgACISgA=
Date: Tue, 8 Jul 2025 22:42:36 +0000
Message-ID: <bd8006a72878e33f5ffa1f9a6079e5236eb97753.camel@intel.com>
References: <20250707101029.927906-1-nikunj@amd.com>
	 <20250707101029.927906-3-nikunj@amd.com>
	 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
	 <57a2933e-34c3-4313-b75a-68659d117b14@amd.com>
	 <fec4e8dd2d015ec6a37a852f6d7bcf815d538fdc.camel@intel.com>
	 <aG0shOcWprrZmiH3@google.com>
In-Reply-To: <aG0shOcWprrZmiH3@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS4PPF93A1BBECD:EE_
x-ms-office365-filtering-correlation-id: 84d825d9-2c20-4b0a-d8c3-08ddbe70bcbc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UE8wLzV6NFk3aHNmb2RqYnNHZ3FDSHhUd3RYQjZqL3VQdG0wNm1HUlhTSGll?=
 =?utf-8?B?N0dMazJmaEZKdUU5cFNaVkZpTDhWMTZCR2VzMHVYN1AwamxYQnc0ZmpGUkkw?=
 =?utf-8?B?U0pDQTluQ0Z2TWxsU0Uvclgxc2hSYTA5K3I1eVl5MEhqdHpsbHpablJmbi85?=
 =?utf-8?B?NkdJMG1sNEZpSzRoaVZmQmcweXRld0FEZkNVOTFPdlpZaDdHejhSbkUwL2pq?=
 =?utf-8?B?SlhBMkdXeUY3bmk3UWJRclAwT3VhR081bkZ0MFE5LzZGTnBIRVNQRkNyemhQ?=
 =?utf-8?B?QVBlRkdwUko4QzU5TzMraTBaSWNuMytrUEtUTTFIalp0NitoUWhmdEM0UFBJ?=
 =?utf-8?B?b1lTZFU1NFpoMytzcjI5RGtnQkhQWnNrVEs1aloxN3lKby9UMHlzWk1HdW44?=
 =?utf-8?B?T0NFbm1hMWpCUmdLaHRLRzdLenNpRFFDLzRkUWxmd3BjbHVCb2x3MVQvZzF6?=
 =?utf-8?B?T3NKNzJSampzdzNTVGZCWTZ3Y2dzQUp0TXNRa0FObWFrbk9GTTFqNFYveXd6?=
 =?utf-8?B?emlXMUFEUFUrMkswQkNjTkxCSmlXMWtJTVB6Y1VlVkRsdFlxTWEzaG95S0hp?=
 =?utf-8?B?L3NnUCtuTDhzSlBQcjZ1ZmVRVmMweSs1Y1V0WG53SDJSSjg3R2p1LzlNS25C?=
 =?utf-8?B?dTdCaTFJdzRtQy96QnlpMHNFQnJuMjVJdGxyZnZBZ3JTQ1lPWno1MTlPK2lH?=
 =?utf-8?B?ZThpd1ZuV3lJNCs2N2lhZHZxMFRQcFp0Q2xsUWZuS24xdjJ3WmFWaFZUanJ1?=
 =?utf-8?B?cWR3TEFBRHhCYTdlUDJaWTZoU1g4d0F5WmRVZ1JNdkhBb05ScHJnYWh1bXN1?=
 =?utf-8?B?d3c1MStNY0kwUE1jN3pKeExhMy96a09DTEV3amNlREFGSyszYVdQNkYyNzNl?=
 =?utf-8?B?QjdUdWlLL2x0My84RS9QeFBxbkpGeUhFT2d4S0xQN3F6aGhxSG5OUVhzeTFN?=
 =?utf-8?B?UHJ3dkFUbTkzTHM1c3BxWldmQTZ3Y1ZPTlpYSkUxK0piaHFhZWc4YmdHU2h0?=
 =?utf-8?B?TkFQcjVXSW9yY1BmSTNQK01VYnIzMFRYVFdXemtOVnRZYzFEblBSU092alE2?=
 =?utf-8?B?NHhMQkxmTW4rU2IvYmNHN3lhLzlCNVdUMEx4cHhpaDdOa3VRbzEyNUlGeXIx?=
 =?utf-8?B?Z0ZwRnhWbitPd1h5Mk1Lc21jVTlxODAranZVcDhaQ0Q5Y3pLR1FxUUt5VDBa?=
 =?utf-8?B?TmxReWxEWHIwMktoNktEY28xRE9sQUZkb2JvSDU0UTUrbDd3REE5eTZWV3BI?=
 =?utf-8?B?ZjZyUHN1OHZML09NVno3Q0xxRmN6TWExRjluWmVpaU40M3RwcmtJVllKYlBX?=
 =?utf-8?B?MDN6SUQ2YmhjN3FYYnBqN3A4UTc5TlJCdFE4RERVNnRlVVdZN2xVN1hqRG9G?=
 =?utf-8?B?eW9zM2xYbWZ1b2hCMHBTMXNxWldGMlBMNzdKbm1JN1loNjVaeDVzcFA4ZXJM?=
 =?utf-8?B?QW5zVWF4aWh5K2UyWFBJNS9YME5mNmtkNVZtZFFpTW9nUXE4SlJMK3R2Uklz?=
 =?utf-8?B?NmF6QzJYaWdhZ05YVnJLenBiVEVWZEZuNVBPUHFwYWpRRGV1SkxZckh6YTVo?=
 =?utf-8?B?dzgwSzE4QWVXRGRKbUZPMC9KZFlLQWFFTEg3ekZ6eXFuNm1mZDVqbDRHcTQ5?=
 =?utf-8?B?dHNZbHJFNnlvRkhiUVp4TlY4SnYxbUk2Y1d3aGVFQ0ZtUnVMRzFsVXlJWEtG?=
 =?utf-8?B?bVh2OE9qTkMvY1I3MzdwQjRLbVN5NHBSa1I5cVRxMERWeWcrdmRZRllEVFAv?=
 =?utf-8?B?NHA2YXB3Nk1PZXhBRDBiOWVIOFcrT3Q5WlRFVDY5bC91aVV5emQyZXRYTldK?=
 =?utf-8?B?VXRqYlkyZEVmQStyMWZMZldoQmdFckVUWG1YQVFYa3U3aVhiWlRpNzlSb1ll?=
 =?utf-8?B?QVM1WlQzdENtbEJKRzN4VWVvRGcrUklsTmR4aG9NZDFybWluNjVjUUY5bXdI?=
 =?utf-8?B?Si9PdEtXeWpaZTVuZ2JVMm9OcW02enJCR2s0WEc2bm1LRlhRWVBXUVJDYUtT?=
 =?utf-8?B?YlBJNjNJVFpBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eElJMXFXeXJUckNWMW5zOElzenpVZ0gxVGNXVUlOT2Iwb2NCS1NOTk5wRFBX?=
 =?utf-8?B?bDg2N1RCd2ZEbys5OTc2cmtlVXlqbHBTWGpJQkNScXdETG93NzdtZW95MHVL?=
 =?utf-8?B?dFhUa1NlalJuT2RQU3dnSUhuajRQOFBvQVJLK0lWU3VHQjRpQnZYYXpDckRE?=
 =?utf-8?B?UzBpVUlQOW1vdkNSdGtTY2VrOG82OHNKMG9VTjBWUWo1d1ZQVjVLSjhLQlN3?=
 =?utf-8?B?dWFTS0R6cnVidEJwcktXMnpvQWlGTWFBUFhrRjBGNUozOWRYLzVmRGhxSDRw?=
 =?utf-8?B?MTMrbTBHTm5hT2huYWdYZ2w3VzNINnhoQzNiNlFzSG1BZ0lDQkh3ck9TUmIy?=
 =?utf-8?B?b0VxVm9nZFRoUzRmZzV3VjBXRkprY3RqeTBEMUJ6YzlSVHM0c29mTG91TzZs?=
 =?utf-8?B?TEFsVlRpdGpzMVhwZE1NZk9JcEFmVXhTK2RlN2RFTzJZVUI3V09iVG5rcnNT?=
 =?utf-8?B?UkllTU92NUEvTDhOc0pMVUlnbmFjM0k1bGIzMHhYZGlRZHhORUlFZHRFNTFS?=
 =?utf-8?B?cjkwa1VqR0NsUm95eEhLQjZ1VGduVENVUEJPaE1jRzFMNTM4S0hwS0ZwZG1B?=
 =?utf-8?B?NUFFRS94Q2pzenFnUzRlYnc5TlkzNjlxMHJqc1NiWXcrbVVmUW9LOUllVWlu?=
 =?utf-8?B?UmxPWG0rc2pORHdiakNsaVZ1STlTdXhTWUFOdjhOZVdUU1NWZktNOE11ZHRG?=
 =?utf-8?B?SWlrRWZvVFJmM3FubmhtaERFdjNVZm1odHc4Q3pzRGlWNFV5L1VmNGE3eDdy?=
 =?utf-8?B?emF6aFFSZlZsMTc3S1lwUE1ZZGM0c1ZMYlM4Wm5IZWhDY0tFVEhpK3hoVmZX?=
 =?utf-8?B?d3pWQWxsNkI1c0dCenpKOGEwbUR0cjcraFZtVmxVYWxkczFZZEVHQXM2RUx2?=
 =?utf-8?B?OFM5SklvTjNaeE5CN0dpdjMwZVlKYUN0VUxmQ3M4aG1GaHB2aWtNM2pQU25W?=
 =?utf-8?B?QXdMQUxkbVArcVkyL2lrR2JGNTUvZnJQTjZFZlROTVFabGdRN1V4WU43OFEx?=
 =?utf-8?B?Qk50TkNsb21wdXVES0gvTUxQRkVuNWdlR3NjV2E3WUZlSEdzZkpYTkhmaDFi?=
 =?utf-8?B?cTM4dHh3OTNkby9LVWpkbnNCajVMMk9SMnpreG54V25SVlptN2R1My9hbGdh?=
 =?utf-8?B?Q0lDN3pWSmM4eVR4K21UdmhvS0VzZDJaMUc2ZEUrNXRhVnUwQ29UbFNqTmtq?=
 =?utf-8?B?R0UzMHkvQWFYN0ZjaXRoTk5BQWtSRW12eWZCNFNoSDhzZTBmYnlIODl1VlpP?=
 =?utf-8?B?RUNXSUZsUy9OcTU5TFhxbXhSbUhNaklMTTZzQ1V1K2pITTY0V0JUMCtZYjRj?=
 =?utf-8?B?b3Ztb2tnN3d4OGNjcGk3R2JjUkdZZVl0Y0FVbnE5M3FnK3NZNy9tY0VmZUlu?=
 =?utf-8?B?OWlmempZRlM3eStJUzlla1ZBVDQ1QkNWYmFEZ0VFL3dlQVNGREMzOFJDNDdI?=
 =?utf-8?B?SU0xTFdCam43QWxLTXB1QnpuYTZKRG81Mjd3aldyajluK2hmQko4YmNlNlcw?=
 =?utf-8?B?TFduL0tSbnpPZmlPY2MwNTlrR3poamJEQjhGa0Qwd29oZVc4VkYyQ1dtQS9K?=
 =?utf-8?B?Mm9lWmNZcjZMdittT3VTVGVQejlEcDZJZHFXaFM5WUV4L0R1M3BTU1JFNHhF?=
 =?utf-8?B?OGt3VEhRUXZVOXE1a3VndURhN29ZckRidHArU1JKck9LNlBFd3h6T1BQSHVr?=
 =?utf-8?B?czkyV0tHRG1yY0FQOTZCSVdwbGJTNXhvYmQ0d2Y5c0hjQ1B3QjVsSmt6bFlv?=
 =?utf-8?B?bFpCVWNieWFtY1h0N0F4NmFnem51NmhvZTM5bFlFZnlCNE01QUYxMkVSSFd5?=
 =?utf-8?B?ZUY1WlRZMWVVQVJMa0dBTVRIUUlpWTdEdFVRckRLR0cvdmxTeGhmOU1vOVpn?=
 =?utf-8?B?L1luWEQzSHNvQ3VkMUw0N3NCUm9JbTluWGRGdi9RNzFMTlV6MHFzMHJlZ0ZT?=
 =?utf-8?B?dGFRVThxaVo4UFlTWDdBT21WdldaNzg1VVNzK2ovNERoNVpSYzRxRC9QeDdo?=
 =?utf-8?B?dDN3aHdPSlVJVGgrSkpVcG94NkNBVHlTWVVGUjdQaCtIS3B6all6UmdLQUNK?=
 =?utf-8?B?UlNVc1V4Y2VObHNOWXpzekRnS2tMNmVEbElENmVGUjlDeU9MMk5ORGpLR1kw?=
 =?utf-8?B?YldlN0NvVXdWMnYzNEFYbHhNSGZhc0JoTnIvbzczdm5oa2xPZjNVTFFZVnFo?=
 =?utf-8?B?dEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26ED6CE6E1BB464FBBEC6BEE9730CA72@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d825d9-2c20-4b0a-d8c3-08ddbe70bcbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 22:42:36.8331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tTPjbu5UWQ9fuTPzEy8IwY6/Ljs/QByCjS56DSsRVE/YhRwsyw/91tg76Gpz0+O7S9STRZbA+Dd8uatXC+cskw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF93A1BBECD
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTA4IGF0IDA3OjM0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEp1bCAwOCwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gPiBF
dmVuIHNvbWUgYnVnIHJlc3VsdHMgaW4gdGhlIGRlZmF1bHRfdHNjX2toeiBiZWluZyAwLCB3aWxs
IHRoZQ0KPiA+ID4gPiBTTlBfTEFVTkNIX1NUQVJUIGNvbW1hbmQgY2F0Y2ggdGhpcyBhbmQgcmV0
dXJuIGVycm9yPw0KPiA+ID4gDQo+ID4gPiBObywgdGhhdCBpcyBhbiBpbnZhbGlkIGNvbmZpZ3Vy
YXRpb24sIGRlc2lyZWRfdHNjX2toeiBpcyBzZXQgdG8gMCB3aGVuDQo+ID4gPiBTZWN1cmVUU0Mg
aXMgZGlzYWJsZWQuIElmIFNlY3VyZVRTQyBpcyBlbmFibGVkLCBkZXNpcmVkX3RzY19raHogc2hv
dWxkDQo+ID4gPiBoYXZlIGNvcnJlY3QgdmFsdWUuDQo+ID4gDQo+ID4gU28gaXQncyBhbiBpbnZh
bGlkIGNvbmZpZ3VyYXRpb24gdGhhdCB3aGVuIFNlY3VyZSBUU0MgaXMgZW5hYmxlZCBhbmQNCj4g
PiBkZXNpcmVkX3RzY19raHogaXMgMC4gIEFzc3VtaW5nIHRoZSBTTlBfTEFVTkNIX1NUQVJUIHdp
bGwgcmV0dXJuIGFuIGVycm9yDQo+ID4gaWYgc3VjaCBjb25maWd1cmF0aW9uIGlzIHVzZWQsIHdv
dWxkbid0IGl0IGJlIHNpbXBsZXIgaWYgeW91IHJlbW92ZSB0aGUNCj4gPiBhYm92ZSBjaGVjayBh
bmQgZGVwZW5kIG9uIHRoZSBTTlBfTEFVTkNIX1NUQVJUIGNvbW1hbmQgdG8gY2F0Y2ggdGhlDQo+
ID4gaW52YWxpZCBjb25maWd1cmF0aW9uPw0KPiANCj4gU3VwcG9ydCBmb3Igc2VjdXJlIFRTQyBz
aG91bGQgZGVwZW5kIG9uIHRzY19raHogYmVpbmcgbm9uLXplcm8uICBUaGF0IHdheSBpdCdsbA0K
PiBiZSBpbXBvc3NpYmxlIGZvciBhcmNoLmRlZmF1bHRfdHNjX2toeiB0byBiZSB6ZXJvIGF0IHJ1
bnRpbWUuICBUaGVuIEtWTSBjYW4gV0FSTg0KPiBvbiBhcmNoLmRlZmF1bHRfdHNjX2toeiBiZWlu
ZyB6ZXJvIGR1cmluZyBTTlBfTEFVTkNIX1NUQVJULg0KPiANCj4gSS5lLg0KPiANCj4gCWlmIChz
ZXZfc25wX2VuYWJsZWQgJiYgdHNjX2toeiAmJg0KPiAJICAgIGNwdV9mZWF0dXJlX2VuYWJsZWQo
WDg2X0ZFQVRVUkVfU05QX1NFQ1VSRV9UU0MpKQ0KPiAJCXNldl9zdXBwb3J0ZWRfdm1zYV9mZWF0
dXJlcyB8PSBTVk1fU0VWX0ZFQVRfU0VDVVJFX1RTQzsNCg0KWWVhaCBsb29rcyBnb29kLg0K

