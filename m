Return-Path: <kvm+bounces-41549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7993A6A64A
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:32:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 254168855D2
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 12:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BC91D555;
	Thu, 20 Mar 2025 12:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zu3pzlGR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE40F139E
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 12:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742473921; cv=fail; b=eDZjRrv9ELGaqERX1tJ+z++DeMl9CTgYmWT56zpH9eO8WFUl4BeyD/7SRzAKZEBZo5+d0cFTvOSxRPzdEyl/9taQSglf3bA1SZ1V0gPRngi37rczyXsiKAQnbBikleb1zapAntHJnOEi3xTjF/j8RGv7/P7n/XLTfKXVzCKrqyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742473921; c=relaxed/simple;
	bh=U6sn/JEIihNbJbhy56T6YfzVSk4JWONOK4mMPYL1gbU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CfL6Kn8VIzfX8Qk0UBLYcGBrNjpbS1x2d2qXK4QO6WIgWfoBgQq+dH1ENU2Bo1QdRhPSE6Be4p73fs0YyqSSwQu1sXR/YZ+ZZNQXOjDutGywq2So40+7Ps7llE0fA+srBMkMWqTaS7sysFcB1bBGcQmJS5wN1xDs40EqAQW/MQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zu3pzlGR; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742473919; x=1774009919;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U6sn/JEIihNbJbhy56T6YfzVSk4JWONOK4mMPYL1gbU=;
  b=Zu3pzlGRq9jB9WIRfx/dpM0FnoCNxGfDTFtcwikXppgnEMRvgUyie5cj
   HV6P5OhD8tFSU4zF9YGglnJhLkz1ooA5xZHPVkrNlpxI624VmXBC7sQsO
   ykDSWnDDSOCE6EbKMvPMH79NfnI+LyWodvnw2pVEz469cRQxe5CMGnJlw
   gvO3DNChVeP7Zxb34Ei8Eje49Fx+2yCPyubTflWBcA4fMn1KCMkVmRzHd
   Vh7uJL9OfXAUocpVyW878UvjGm9JmOC7jazMPUKuZISXNsvyxRYi9AgPO
   Ph6E+K5PwCiYmyWajPKcwDTNvdlEknqi1MvflVuthh6WGDBDYpJPMc5Kj
   w==;
X-CSE-ConnectionGUID: guAg8aGcQxyC9utCuzBW0g==
X-CSE-MsgGUID: p5q7H4e0ReCGxUaaGoLWcA==
X-IronPort-AV: E=McAfee;i="6700,10204,11378"; a="43813497"
X-IronPort-AV: E=Sophos;i="6.14,261,1736841600"; 
   d="scan'208";a="43813497"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2025 05:31:58 -0700
X-CSE-ConnectionGUID: DIVk5QvZQOWbhTblxofOPg==
X-CSE-MsgGUID: Kd2wzjv0Ty+a9Ze/B5546g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,261,1736841600"; 
   d="scan'208";a="128173173"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2025 05:31:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Mar 2025 05:31:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 20 Mar 2025 05:31:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Mar 2025 05:31:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B+IRoPdxe+WIFIQE2VVE5XVlPLJ3aqmCP4huJWSLLYY/JjtbE/ZRsdyoM6zxkTY2JEuQ2T44anL6/OBAebtFmHPXJQWCIkMn6c+0j0BkXWrw1mFUx4ijtTqcj2hbddYq/8f0DsieTaYEBIW/kvgk6B/6sXzR9DiCoRH0CBzLexKLzgtE+5OhXrZ63tyREILOsryQ9UIcii55AuqOiIb2H6aG7CaB5WBUoSH8+El+0ldieoVdelxiu/jAkF1OqF7uXLnNTcMi1CVI+psIKkDzNEXuj3y+TtAR60pUQGPoUuCAGHvhGJsr9fPXTBYixBuRcr9tGvQrxOsZ1UFzYHsocg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INt3RnI7WIMGP7sBaCmw7e3sWHjbiCNWrLq8hhmQ2Vo=;
 b=L97isV23in8FkHAEaZY/wOCpNH3xnxlZcNoLMteVJnZet0hyqrl669obFgA46H1e961F9UrJjKnXCBnVDmqOOVEkk38Xtw4dI+Nq5REr4aOpCyEtab2GYaOyYgxi4kQOdhHTIpcj7TtRWIPYQFKDi9q4xIGH6pJcWdq4h/5eoBV4hCGsPdfiJKDiS2sMgd1plO2tY9QbBC8GXRS3HFdaG3Mpu/gnO58mOH1fKslGaP8MHcf8oSQb90yfRjHGSznxIUpVt8G7pGON75++IvKU2Nvy2zgK5yDfGfP+KxeQ1MsbpDiHYg/bJmU3osUlxi9mex+PCCAdo0qRrdePPBqF1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN0PR11MB6255.namprd11.prod.outlook.com (2603:10b6:208:3c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 12:31:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.8534.031; Thu, 20 Mar 2025
 12:31:54 +0000
Message-ID: <064c601d-6049-424c-9a84-bbbca0d4ade1@intel.com>
Date: Thu, 20 Mar 2025 20:37:20 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support
 pasid
To: Nicolin Chen <nicolinc@nvidia.com>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-4-yi.l.liu@intel.com>
 <Z9sB1Ncudc13jATq@Asurada-Nvidia>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Z9sB1Ncudc13jATq@Asurada-Nvidia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0060.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::24) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MN0PR11MB6255:EE_
X-MS-Office365-Filtering-Correlation-Id: a30c76a2-e359-496d-4e08-08dd67ab3244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TWJ4aUxDdTFwc2hUblB2L1ZIdVN3UG1XUHY3VDFJbXM1Z2s2L0xWRUdZMjY2?=
 =?utf-8?B?Tlp3c2VVK1diOUVUV0dIdWo4dXh4MjJwdndla1R4WE9yTk14RkRjekFlU2pO?=
 =?utf-8?B?QmJjaExuWXlJNUJLMFlucUt6S2FZdzh4VVNQdEJlM0lmckpISFFLZWlLYzhn?=
 =?utf-8?B?RC94TnhOMFFGQWRHeWc0OXFMbWtydC9pd24rNHlTMzZlcTJRZlFMYkxDeDRU?=
 =?utf-8?B?aVIrOUxhK2c0SzB6ZC9FVjdlTkJmU0hLcnRkOEhpeHE4enpZaytvVm9kLzdB?=
 =?utf-8?B?MkRUMVU0Sjh6WXdZT3FRdXd6ZXRCVzBaL2lQeTFNRkxJMnlGd28zT05NNTRB?=
 =?utf-8?B?emdYalRDZWhLczdiYnZreEx4MEZ1dlQ0RHJWekpFWHd5S3c5Uyt3RUFXN1B4?=
 =?utf-8?B?elV2VmhQU3BPdG5oYUt0amRxcndtSml2bDJTRkx4L2hOZlgrVDdMWWtaWVE2?=
 =?utf-8?B?VE1paS9FYlhnbDV5MnJhb1Q2djRnd1U2M2ZTTWtGRjZGWWdZYTNQVE85QzU3?=
 =?utf-8?B?Qmc3OTFzL3paNFpVeDFoWnJZQmp6WWNqVVlSKzYxbDg3U0Mxdm5UK1BWbUZE?=
 =?utf-8?B?bGY4RjhHNGRmcE5PUktCQVY5V0ZMNWdWcWZjeUpIUWVWeFlwU3NYK0NBOTN0?=
 =?utf-8?B?eHIwVElDL2t3Vk5EWGJmSE8wcm5mOUxRRytFSG1SaC9QWTdENjBBZUgxLzhq?=
 =?utf-8?B?UC9XSnprYUx6TFFGeWN6anJRU3I4cjF4eEEwSjREU0pjVE9ENkRLcnRPR01s?=
 =?utf-8?B?OG8rQnpQYzNRa3g4OW5EUXhMRVBDVFVxZDUvaDVFcDByMEh3cEIxbWEyOGVu?=
 =?utf-8?B?Yk9SdjU2QzRpMGVkakNack52V2JtV3BGeFpTem1WUUVtV3UrTkFWbnlpd0t3?=
 =?utf-8?B?YVRmOUNLOWxveVhXTWVaN3NrWVZmMHVZcGp3cS91dU9PWDh6VEEwQWNCSmo3?=
 =?utf-8?B?Tm5UdGFrM09zbWgwUWpkLzZ6TkRTZGhXUnB5RUxPbHNvblp6bVI4cWNHZmNH?=
 =?utf-8?B?dTdSSXYwRkVZc2lycUk3TWhVNkU3Y3JPalpxekN5SndZam9iMk13cHZqa2VG?=
 =?utf-8?B?bWhycXZ2TENxY3A1YjhMRWh1enpoL3Y4M2pDdng2R0NmWmFwOVdkbldzaVlH?=
 =?utf-8?B?Uk45WkxpUGY2SmFMTHFvckxSdG1WZXdQVmlnQ0c5SFc2T2xnVm5Vb2duNU93?=
 =?utf-8?B?dnlFMzQ5cEdMdkRnRFFQbmNRNGRjczhQS0JXQ2w4YmVXSUJ1YUJLOHpKb3Bt?=
 =?utf-8?B?Q1VUMWtzSmdXVTdwY1UyTmhmQWxZSDNIcFVFUUlJWlJEclp2QWk3aUIvVUQ5?=
 =?utf-8?B?S0p3ZVFDZllKd0VhcWtmK2YydDR3ZXhtdEdBM2k0Y0JlazBMWU5qTnhuN2Nx?=
 =?utf-8?B?RlE2SUFIb1ZzQ1Urc083QWtMNmd1cnI5TWttOTZDbkNSR1hkNUU3T3ZNZ3c1?=
 =?utf-8?B?a1lGRUVpZGZqVVRCL09BWnpqTkFiRCt4Qkh1ei9aTVM3ZFoyQk00TVI5VU54?=
 =?utf-8?B?T1ZwcGNpSnZZQkZ6RVozVGE3THpla3Y5dVEvSEJDeXd3ZEpvTFRNaEc5UnUy?=
 =?utf-8?B?WEZsL2duVFplRzlTQUUxSGFXeE9Oa1ZJRTJ1SFh0MVZWTFRObS9LUGpEUVFr?=
 =?utf-8?B?bzhpY0lXTXhUM0E0cGVWdzMzMER6N3FYajU0QUd1V1V3Z2NpaTF0RFdDMzZs?=
 =?utf-8?B?RWRncDh1UGNaMDJKb2dVQStFamtkQm1aN0Z0U1l2Rm1zb1VoV3pMQmE5dHhr?=
 =?utf-8?B?b0k4b0EwVnB1RmlpQmZuazBXMmlrNmltem1EOVRUbU9KUzZXVUdnbTVML3M0?=
 =?utf-8?Q?sh/CpT69REl8y6EEsjTtTwO6N3isKnMihaRv0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVpEQVVzZjJ0ZkJkRU4wMGFSTVp1OWFIc041NWNFb0I1NG1KTmIrTFJHK05n?=
 =?utf-8?B?ZXBkYlM4WVpIZ0N0STByWUZ6bnQxQnFLZUpLN0kzL08xcDJlVExEclE2L2JI?=
 =?utf-8?B?NkZXaUlYNG56Rk9tK1BnbDBYR2Rna2JDOStPbTBnNTVyMkp5ck4yNEhDVCt4?=
 =?utf-8?B?Vlpvcm5sNDk3TGlGOXUyMCtiQTVGaDFZT0pGYXFjYUl5WC9BaVI0SENzSEx0?=
 =?utf-8?B?R2p6VHQ4VGpkWE1HMXVEYmxvL0lwWkhKVEhNdVFMcnJEMXRnTGUxaXR2L2gz?=
 =?utf-8?B?Y0N2U2dBaVlhdXdrT2F2RDcvOVQ1S0w4am9sc0UrTmJKd1EvYTh0TW4rTVRl?=
 =?utf-8?B?MEFhNXBackNrQ1hXY3AxS2JkeFlQYWpNbFoydWpubEtNbjJoaGNaMUE4TVd0?=
 =?utf-8?B?cmhOYXRRSDJUcDBKOXQzdzBGRXFNWkx5SDY0OTA1VnpMWDRDMkdNMFhKV2ox?=
 =?utf-8?B?Q2JvQ0YwbGN6MmR0LzB2VyszTUlhQjJHaW1yRFdWRFF2bCttZERka1gvdVVL?=
 =?utf-8?B?RDB3V2dUN29NRTdhWm50ajBlVU82enVrTWZHWmRqeGJ0WnhobEdMak91NGVL?=
 =?utf-8?B?NndndDRtdEg5RTF5U1MyRGo5Y01oOXpUU3lIZDl2blpkalFEeGYwN0Y5MHph?=
 =?utf-8?B?azJNVUF6UHRJS2Jpbmd3OERXaHpwK1Rsakd4NE1sd255MjVSRW9Gb29vRzF1?=
 =?utf-8?B?ZHpmQUcySTkwV0tLcXJDRGR0Vm44elhvbVpDM1llZUdNeDFvUFE1SlVpT2U2?=
 =?utf-8?B?RjVDSmxaSStxUUIwc1hBWHQvNVVnVXYySnJaQUxuZDc0RVpWcVpBS1B5cVAv?=
 =?utf-8?B?VDZoeEJ5VWVuM1ZaWGVBL2dPamltTUx4NlptK1o5MFduR01FenFwM1UrclVE?=
 =?utf-8?B?M3YwWms1V0RFM2JqWVZFMTBYNW9EdGRWaXpwYmFDeng5Z0I2azA4TjYwdXdl?=
 =?utf-8?B?Ym1yMjRveDFkRnZTYnpWQ25SUTJZZ2FFaStnWXFPSkxDOVNxTG9YUFZ0c1gy?=
 =?utf-8?B?ZjVCTEZwQVUrTVFZQU9PM3FVRWlzQlRBLzkvUFhaNjEvWmxPc25OQWtLbDUy?=
 =?utf-8?B?ZzlKQzgyaUw4VzJJTGZkSDQrYWk4OVpqc0hTL3lVeTczM3BZTWF2SGwrR2t5?=
 =?utf-8?B?QkpPMkZFdS93NkxubG9yUGJCTE1BdjdPMlovVTFFMnZrS0U0RjZ1NCs1OFR2?=
 =?utf-8?B?RFRBQkI0NWY0V2F3MC95VHhBVWdmSlNPTGM5cTFIWVNUZi9PMExiZlhwVExo?=
 =?utf-8?B?Ri9HaitrWkpGWDhaQmZXazFYc1hrWHIxWkxEZk1kSDgyNjlmK0V5THVIb0No?=
 =?utf-8?B?U28xdkFXbU40N1R5cktSc2drRjIrU1ZTVUNOLzFOUXV1eVRQSUZjbDBJTW9Y?=
 =?utf-8?B?cC9ad0RjTFFnSm5yOEpDSWlHRC9ETHZVZzFoQnN5Q0UrNTdIK0dnYUtnUHl5?=
 =?utf-8?B?YWFUN2lFM0VQRmJ4SG9sbEhCQ1hFZWlhSHhLTm1yV3l5WGFnVG9TWG01MDVW?=
 =?utf-8?B?aWtoOUVCcERwUTFVRzVmU0MwMjA2M3ZkQURMRUhoWkFsTGNhSnpQTkRSQ1FK?=
 =?utf-8?B?YytwNmxaUCt1d25jWFJ1Y2xhdDhYRFdkeDRYeHY1OG1maGZkSmxHK3Qwc3dI?=
 =?utf-8?B?R0Jiek8rcWZRRGttTzVPbnVDWXhPUU44dnh4cEZyOEdTY0NRS0R6K2ZHK3Fr?=
 =?utf-8?B?QS84N0VRbGJGczVLZVdRWVZTT0RDVHJZSVJuZlEwd0IxOCtpQ2pkcnRoRm9y?=
 =?utf-8?B?TVBpVWFoZE1RWm1RdmlZUnJnR0lOQ1NCdjQ2aHBEUHExb08yM2E5M2hjSVBk?=
 =?utf-8?B?Zm1DYmtLTmtSbk0yeW1OeHYwNmJZcERuVWl1MGowQUc4TkIxMHhUc2pxSkVa?=
 =?utf-8?B?emlWaGFxUDZvTjlvcDR5SnkzYmZTVlJvMk8yVXhEcEoyYVBmN2RmbC91TzBh?=
 =?utf-8?B?M0RCMy81V005dDZyeUhmV0tzeTNUMWFOWW5vbWZCcVMyejRrNWsrU2tuUURI?=
 =?utf-8?B?S3BRZEpJZi8vc0xUMVJ3YmZsY1NOaENyb2o5cGI3MDFIL3dYSi8rRVA2TGJY?=
 =?utf-8?B?WjRWNWJ0OEw2d0tqVURwOXE4Q1l2QVVmMWRKNTgzSzlUazMxM0Z1WDV5cWtN?=
 =?utf-8?Q?YGzPo22P/RSe8gnhZqiXooDZc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a30c76a2-e359-496d-4e08-08dd67ab3244
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 12:31:54.0566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jW+ovitPWSRV0sEFZ9Y672eGEB2rLNS3OmTpzrYYHe5ANmAU62g4D2Ao/wVBY3eEpjm5H1sWqB01lwtX6kHZCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6255
X-OriginatorOrg: intel.com



On 2025/3/20 01:41, Nicolin Chen wrote:
> On Thu, Mar 13, 2025 at 05:47:51AM -0700, Yi Liu wrote:
>> This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
>> a given pasid of a vfio device to/from an IOAS/HWPT.
>>
>> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> With some nits below:
> 
>>   drivers/vfio/device_cdev.c | 60 +++++++++++++++++++++++++++++++++-----
>>   include/uapi/linux/vfio.h  | 29 +++++++++++-------
>>   2 files changed, 71 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
>> index bb1817bd4ff3..6d436bee8207 100644
>> --- a/drivers/vfio/device_cdev.c
>> +++ b/drivers/vfio/device_cdev.c
>> @@ -162,9 +162,9 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
>>   int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>>   			    struct vfio_device_attach_iommufd_pt __user *arg)
>>   {
>> -	struct vfio_device *device = df->device;
>>   	struct vfio_device_attach_iommufd_pt attach;
>> -	unsigned long minsz;
>> +	struct vfio_device *device = df->device;
> 
> It seems that the movement of this device line isn't necessary?

hmmm. it's just for reverse Christmas tree. no functional reason.
> 
>> +	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
> 
> Any reason for the parentheses? Why it's outside the ~ operator?
> 
> I assume (if adding more flags) we would end up with this:
> 	if (attach.flags & ~(VFIO_DEVICE_ATTACH_PASID | MORE_FLAGS))

yes. need to drop it.

> 
>> @@ -198,20 +221,41 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>>   int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
>>   			    struct vfio_device_detach_iommufd_pt __user *arg)
>>   {
>> -	struct vfio_device *device = df->device;
>>   	struct vfio_device_detach_iommufd_pt detach;
>> -	unsigned long minsz;
>> +	struct vfio_device *device = df->device;
> 
> Ditto.
> 
>> +	if (detach.flags & (~VFIO_DEVICE_DETACH_PASID))
>> +		return -EINVAL;
> 
> Ditto.
> 
> Thanks
> Nicolin

-- 
Regards,
Yi Liu

