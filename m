Return-Path: <kvm+bounces-59212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1BABAE3FB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE570324669
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E14225C804;
	Tue, 30 Sep 2025 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iHruqt7N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EED81F5847;
	Tue, 30 Sep 2025 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759254884; cv=fail; b=B8wk5jLwRHiDT8IXIt6OtAW3r84W0FuoI6bKvQpkmmExyJ00R/MIMd1LAkDEspIjr8d/q7u6LVMS++dJFp0VzT3kyOefHHzNKZnM/0InqyHVXTjotO22Xnb2OBw1uUwgtbX/Qi8Jgc1w4vehj1FVcutMmOMiyEsIvghsFB4vVrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759254884; c=relaxed/simple;
	bh=76evxT4CQqfEy3HttkBEpmQY17ay1ebJIcsT0reaS/U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MtjomdhuEusySBUPY6zDzuQqcs+cuKq9sN5QaBOdHvJAOUa6M07lMXW5R3XWw9dUFVkXtcqNps7Jd4/YtwlGfHHi3iu4TE080oHfB/FphDZfoIBE98/RiYS62HkWF0RRThQEPF5hwxQ8OicQat/4t6mvwkZiS/U1ew5wyWgpK74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iHruqt7N; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759254883; x=1790790883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=76evxT4CQqfEy3HttkBEpmQY17ay1ebJIcsT0reaS/U=;
  b=iHruqt7NiLuzau1mRjnzdwFu9/wqo3Kwf8Ijq5In5/mH2D2M1S9WI9AY
   9NK3EuSU7QFQhMXIuQFGLl4dlvgVKoRVTrKdhQSKJ45jvP4sQpmRl4GH7
   Cn1NE/rcA8t1+59cX3HeTOXnq6EGJA26vvtGshEVzI3aQZhKGgxTl9oyj
   2JSRkKJl6wXLyXog6s3X7Y7Z02EO3Owi+3eJtSuImO6aLz579vHIdWs6M
   kAekULk4VJorG1R0G96TemAhg8QXuBx5tZCK9jBxAhYD4TjoJDgsDsOlj
   nPRUv5ZHL+IAHIQmIsf8T+SQOALI2JGlk0mubDMG4CKQOMbCzbpHUOReq
   w==;
X-CSE-ConnectionGUID: e6nN5iEST+uiv6tOe9Qgsw==
X-CSE-MsgGUID: q8Ryj9vZSEmBeEDUlzLTsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="84140959"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="84140959"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 10:54:42 -0700
X-CSE-ConnectionGUID: BNKHR/iCQqS4VWiZvHX9Sg==
X-CSE-MsgGUID: A8cLWGmZRM68E+eSpeaG2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="183839853"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 10:54:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 10:54:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 10:54:40 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.49) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 10:54:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q82F9UEgXAt85yMFL3R+eNFEjBgVa8FL7upWxV4W9M5Cquagd0/7XUuiifJL+3BBqPGCF5Albv0RM5YyKSNvdOkiOQZctw9AO9m8fXRZkTZQBFkSyRIUxZiHa6A2uD2mcF1V/6rNw0uc/jUhAF1nTzM5tGhdHBtJSl88y/1fwI1eZdi4mtHHJKavfbGDVniYMe500E1qhlaaRKIsln9FwRQgsPvmY0GdyNBpinwVGYEPfyNn2/3SRYr8/wJ/UcvUaDHuWL4psTvxLRJiN++5EUwVU+PWzboBDdq3/PVttvJePmOBo7Hl6RXcnCQtHruRcM2yxHybN6v98ohJaD6nXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76evxT4CQqfEy3HttkBEpmQY17ay1ebJIcsT0reaS/U=;
 b=pg8CeyrgBYc5MYZdSS+aT20Uab2hTY0mY0UVf0vOfRX5FkW23aV5yJ07adI+++uNtADLePMOaR6iauauRdNX+btuJLiTmtPwus4HNMZCCTMv6FIea8BI8VTLMMn5N2SEB5hxwMsF4fGuwysgOWYYYTFrErqIn2bY22xzdBDkhjN9JLlKJ1O0qcpeEE3OBNAIy1hIK4pHdauaucXHb+Dr8mL1xhQlDtbejmU8Rcnt84m9lURu0pefpauMXF+QHY0M2wFehFSJwDQTnNEO+PA5CYLQN6fEXdf6o/61qxP2tgcyJv3YFkVJ/FqrntRFkBXpv3TkfeItdi1yMTxd5j5hUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6323.namprd11.prod.outlook.com (2603:10b6:208:389::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 30 Sep
 2025 17:54:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 17:54:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Topic: [PATCH v3 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Index: AQHcKPM1I9Uz3YNymUWJSwvxA2Y0bbSq+d6AgAEayYA=
Date: Tue, 30 Sep 2025 17:54:34 +0000
Message-ID: <42ecbeadd2d8916229f1936dad58ce71323a5525.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
	 <aNssIWsngqxQCd9i@yzhao56-desk.sh.intel.com>
In-Reply-To: <aNssIWsngqxQCd9i@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6323:EE_
x-ms-office365-filtering-correlation-id: 2b0dd70a-fe56-4ba3-f824-08de004a6a56
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YnZmbVhqYUkvanVGOWthY01lZkxhTGhpMldrQkx1cFlONnBhTlEzNVd0eUd6?=
 =?utf-8?B?bG92MUx0RHlEaHg2Mk1YcHlZblkydzExMnRLVWR6QmV2dEM1bWo0LzZ4QUdn?=
 =?utf-8?B?QStMaUx5SmgwdERWeDZFYVJTM2FxRzR4THNiaDF3Zmp4SHdhaWpiaWQ1TUZZ?=
 =?utf-8?B?MFBPNXo4N29oekZoYkZ1ZW1EWHZMVEJ0bFhZUUR5ZTJtODV6S1p4UGxDd01Q?=
 =?utf-8?B?OHAvdTJDZW1jQmRwRndPdDhEZEcvUWZIYUxaOFhJZEVZZVdkOWtjV2hpa0Zn?=
 =?utf-8?B?R3daZ05yYmZNeG9Nek51UURZbW4vbzREamNDSVJSRk5GVGUxWndobHJoM25I?=
 =?utf-8?B?cnNrbjZkaktraEFrMzdLTmUxWThPWTBEOVJoVmg0ckZKd1l6UWswTVJ5dm9K?=
 =?utf-8?B?eTBtMFViRGhaTjYzdzB6VGpZNDhtcWpBVzBHTEt5QnNFblhGcGUyNzhFU3Vj?=
 =?utf-8?B?aTM1cTZWaHltSWhmb3pWb2lMeSt2ZEw5UzRvcHcyS0pKMUZzTzcxc1JOOFA3?=
 =?utf-8?B?N2RBUUE2c0pCZ2YxKys3eHZiZmNUYU9SK2hMTXJpd29JQVJtNFZPVGZPK2do?=
 =?utf-8?B?M2JnMXdvOVV1OUFKTWNEVExtdVcrNWVkTEF3cS9URlpJM0dyUGxkWXFmR0ds?=
 =?utf-8?B?b1RtVC9wTmFIQklic3kzcUVTc2FvenUxaHhaNnpBMTNrQzI5enlZaHMydzRU?=
 =?utf-8?B?cWxNSHNJTFN6Q0dtY3FhQzZNb0hGaUF3RkZHV2pwVzlYSFlSQkUvb2U2WUJG?=
 =?utf-8?B?aWlJSFFVd3A1YXdHS2pScklZLzltOWUrT2czZHhkcEpXcXVUcGRUQWpiMlNE?=
 =?utf-8?B?MTd5SFpBTzQ1Y2tFRVFUU2owcS80cHo5eG11bmVwcUZSS1ZUMllMVEhpNGJr?=
 =?utf-8?B?ZENCT2grem1HblljOXR2RmJjdC9yMW81VnBiNDRLeU5RS2VEUmVFN0N6S1dY?=
 =?utf-8?B?SHVuOGxDVmpSaGUzUXpJZjdNR3c1TG90VDFuck5CSkVHdjI2T0tXbmRGeUNp?=
 =?utf-8?B?eHN6TTMwcVJwVGRuRDgrWDJnaVRGMkJRN0U4MG01VkFkWXlNQm44NUZpYng3?=
 =?utf-8?B?ckxSck9QSnJoNEUxckhUcjA2QUtSY3RSTTJWemovUUJiS2M1bUZpUGVIcUFh?=
 =?utf-8?B?dkdYS2pZNWpkTEQxeDA4YWlNWmkzd3RWSnd0bG16dmZmOVB0Q0FwTE0vWnJn?=
 =?utf-8?B?RnNGOGdMbnR5WFE1ZzJ2M3hEMFBYRmZtcm1KWXZnN1VGRE5oVmtGcFNyS0k3?=
 =?utf-8?B?UkFQZzVXNGltTWhJM1JMS2J4TXhEUWxPaTJtUUgzenVsTk84clVSWDMrdzFV?=
 =?utf-8?B?ZCtkTDRSN0sxQUJoRkpaVW9TY1JkaS80b0xBZmxaTkkrd3pqQzVsZWVFVzhY?=
 =?utf-8?B?MFBadDhHK294RGxsVGticXJnZlJ0OE5Eb1lZT2JwUlNCZHYwbHFsMU5MZ2ov?=
 =?utf-8?B?azIzVlFCcm9Ia3dqZXpaWU5kcEg4VGxqS21OWFdlMm1ZR2FRazdsVExnbDRM?=
 =?utf-8?B?bHhWMFdWREJ1cGVsMnZmUGtDemZMc1FnU0pHVEZ1NnNCRE8vby9FU25WbW9G?=
 =?utf-8?B?YkJ1MmhuRVd0M2QwYkk0Nm9NeG1TRmxtRVdaU0k2R08yOHlHR3lhUmMvNnBN?=
 =?utf-8?B?TTUwU3BJUk9KNzBaUFc2eDZQd1NhTW5uNDMrMkdjUzAzYVpMQUNHWjJmWGh2?=
 =?utf-8?B?Nm5mM0cwbVJOcXNHTjVSVlFwZWZPNFplb2xvd0d2cHQ0NFZxcDlKcGl2bFNz?=
 =?utf-8?B?YmhoaEVUWnBoN1FubE1CNjd0em1yYzNHTWNNcTlqYWVXWElkTWE4SHVVQ05S?=
 =?utf-8?B?RitNbHVwdHhwNVl6cjZHZFRlSlJTZ1B1SUtBM0pRdUhiMUQzQ0FmWUtMWjhq?=
 =?utf-8?B?Y1J2T1NqdkltbmMxRDc5MmJ1aDZqMGJDQzF0VHc1Q21wRGxMdWRnZ1o0OHFJ?=
 =?utf-8?B?cmpKdm9QUmJZcWVaNXRxSjZ3UFV2L2xrR2c3Um1zSkhQZHpVU25jeXdkRnFU?=
 =?utf-8?B?Wi9JUzdsaTViQXYwVW9iMTlndWgvYlpxOVFyZkFOeHRvN295STFIdkVSRG9v?=
 =?utf-8?Q?6To79i?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlg4VExFS04zN2hHb0dOTWkzTkhlalV0cmx6di82RHZlaXJSSWtCNk9rRWJs?=
 =?utf-8?B?L3pLdm1BRk1YdGNPeVl0OHBhc0hFRjROMVBwRUYvU3l2eUZ2cllhWmVDTjVG?=
 =?utf-8?B?cVRTTFNaczZGWG9tTTlMZnYvNzl4aVhNRTcxZlByWWtxcGtsNWpybThGTjMx?=
 =?utf-8?B?TGR3K0NtQjk5NEJ3aFRxU3puV3JBQVIyNktrRjlVU0g3d3NBQmNuRjlqdWYy?=
 =?utf-8?B?STNPdlNVZU9abGgwRUE0bGFiNWE2V1l5ZjA4cHRpWGQ4TzJidE5OZDFtNkc1?=
 =?utf-8?B?TGNRUzRKK3VCTkVkMkxtaDdjUEVlQlJWaFFKTEk4Rko2eVUvSzZCREUvQVNW?=
 =?utf-8?B?bmlya0RNUk1KNGFpV05NRjdWelJzbjVha1c2dzV1ci9sK3RzM3JPc1FNZG9m?=
 =?utf-8?B?MXJZbFhZRlRPU2NRTnFWd3ozeVlBcXFldGRiZ3RteFFqdXFCU1JyeUdWWWZN?=
 =?utf-8?B?bW1NSTlMdkp1SjA5VFFEZTQvNWJoS2xDZmphWU1CcEFTYnQ5MGliN1ZPQVRr?=
 =?utf-8?B?dnhUNm4wK3FyMkFBTU1zTTZEbTNqTGJpMEdYb1BwV2dQbExpVVYzVkVRRUQv?=
 =?utf-8?B?RDNqL2ZMQ1B4YUJoWWhjVWQ2YlNMOVQ5ZjZRS3NNNmRJUjczNkhtQUEvQWQx?=
 =?utf-8?B?V3V3YWY3bWZ6Y2FDS2RzR2pKYVJzQXRRWEN3RExsUWh5UWwxMDcwNWhsNS9V?=
 =?utf-8?B?bnlCMXFqRkg5R0JyYnlIaFdnVmRVTEJIOXpTT2VENGFwSG9XeVpVSWJCSWFk?=
 =?utf-8?B?QXFIeWlVaUlCQUhQc2FYbkxlOU4vOVcvazVQK04vcWlWa0Y3d05qYWRGU1o1?=
 =?utf-8?B?eDFOdFN3cmpyWHlRZExGYVQrVm01NGloT3JzOGdlcGszNDF6b2dRZGZQUUxx?=
 =?utf-8?B?cFFUZUVnSzRjUWM0ZFZIcmJLK1UvazVvbUNHakNDVkVQTEE4N3U3TmE3REYy?=
 =?utf-8?B?TForc2JIRkVLWkpNKzVLVEFIREtMSzRhbGVYbVRNZFB5MFNDVHk4aWtGZTJG?=
 =?utf-8?B?NTZGemxoU3FjL2pta2xkVDhCRCtDcXRSd1BxT2RmNzJQV2t0K1ZnTUxSdjVI?=
 =?utf-8?B?YUE5Q3N2Qi9BV2JpWXl4b3NIcVFNdWdHWHZEbnVNNVoxd05zOGV4UjBScnpS?=
 =?utf-8?B?TE85d09KZStyZTJxVXpod09kcGRnby9WdEJ3QWpRZG93TzBndHgvRzFpVDZL?=
 =?utf-8?B?RnJJaVk3b0gwd2hLb05uQ0Fxd1FvUTFQd1pFYnpMY096WDczOU1MRktTYkE4?=
 =?utf-8?B?a0N0TThsMVZsWUFpK2NBZE5yY1djcTlIV0ZTNm8vbnVGNzNQcVVyQ0l1RGVv?=
 =?utf-8?B?clh1bHNiKzJFZmhGZTJjakFmcGlWYzBOL0UzdW9LYlV0dEEwWjhaWXJ0ckhu?=
 =?utf-8?B?dFh4dDFJSVFReVlSb2RnMVdIYm42RkduQSswcDhYV2RoMzhuenMvOEQ4cVpi?=
 =?utf-8?B?czdKR3lEamo1alhBQzZzK0xEdENqd1lXaHZHc0ZWVUx4NmU3NHFJTEs2RUxE?=
 =?utf-8?B?a0NUY25mRzMzWWtZU3huV1paVXFxU0xISzJNNGJBamRYUEFobGZNT0ZzRnpD?=
 =?utf-8?B?enZuZTNRVUU5NzFnZzVTN29WQU1Kbmw2dG5pM0pPRk4wK1ZCL28rZUNDcHh0?=
 =?utf-8?B?VHNMa29oRmJVV0FKTXI3SjBlQjkweGJ3WmJ6b05IZTBiK0NEZ28wbDBzSDRZ?=
 =?utf-8?B?VG9HRzNxK0hkMzJPci84azlxTnlmeFpsZEUvSUVCODc2bytlNiswa0J2S3I0?=
 =?utf-8?B?TEg0bGs5OHlMZ1BjNnhnOWFEK24yNVRqeTNqeXZMK0E5YUpnZDlLWHh2dHNV?=
 =?utf-8?B?NDZpYjFNS2NBbDJKVVpYOGNGN2s1d21ZMXdXRFlGakM0NUdWMi9KZFA5Qm9o?=
 =?utf-8?B?UVdYbHlsZ1lGdG8wUXhvNXpzdUVsRkszbUZsYnNOYlJBTC9Ma1FWb0h0dmMv?=
 =?utf-8?B?c051TnlGR3g2RzRISlkzUVpueTBzZlNEYWlYa1B2b2hwWS9TZGFhZURaYWpz?=
 =?utf-8?B?MlpLaUZ2Qi8yZk9MUVFtd2ZpYXVnMm1yTktUVHZNcEpGRXc4UVVJTTBHR0My?=
 =?utf-8?B?UWc0eHlDTzZ0bzR3MlJzbUNENkYwWTByNDFQdVc4N293T3VLQWRIekNKazhH?=
 =?utf-8?B?cm81MktBSXVmVjRyS3h5SzZzN0JYanJIT3piV0J6U1JNR0M2WXZaSDJuQ0xH?=
 =?utf-8?B?d3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <309AE61E8CC748439546DDF1A3F86198@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0dd70a-fe56-4ba3-f824-08de004a6a56
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 17:54:34.4537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQJHYEZFao7aVkRkKA49/0Lf7qVAh2XRO8z2J7KnJo1OGB9IYWyQFtZcxKLOgYgjvRwg8C/2ag1qBffMXVgDtFz6KD14VPR1G+UZjVTwMB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6323
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTMwIGF0IDA5OjAyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
VGh1LCBTZXAgMTgsIDIwMjUgYXQgMDQ6MjI6MTlQTSAtMDcwMCwgUmljayBFZGdlY29tYmUgd3Jv
dGU6DQo+ID4gwqDCoAlpZiAoa3ZtX2hhc19taXJyb3JlZF90ZHAodmNwdS0+a3ZtKSkgew0KPiA+
IC0JCXIgPSBrdm1fbW11X3RvcHVwX21lbW9yeV9jYWNoZSgmdmNwdS0+YXJjaC5tbXVfZXh0ZXJu
YWxfc3B0X2NhY2hlLA0KPiA+IC0JCQkJCcKgwqDCoMKgwqDCoCBQVDY0X1JPT1RfTUFYX0xFVkVM
KTsNCj4gPiArCQlyID0ga3ZtX3g4Nl9jYWxsKHRvcHVwX2V4dGVybmFsX2ZhdWx0X2NhY2hlKSh2
Y3B1KTsNCj4gQW5vdGhlciBjb25jZXJuIGFib3V0IHRoZSB0b3B1cCBvcCBpcyB0aGF0IGl0IGVu
dGlyZWx5IGhpZGVzIHRoZSBwYWdlIGNvdW50IGZyb20NCj4gS1ZNIG1tdSBjb3JlIGFuZCBhc3N1
bWVzIHRoZSBwYWdlIHRhYmxlIGxldmVsIEtWTSByZXF1ZXN0cyBpcyBhbHdheXMNCj4gUFQ2NF9S
T09UX01BWF9MRVZFTC4NCg0KVGhhdCdzIGEgZ29vZCBwb2ludC4gQ29yZSBNTVUgKmRvZXMqIGNh
cmUgYWJvdXQgdGhlIG51bWJlciBvZiB0aW1lcyBpdCBjYWxscw0KYWxsb2NfZXh0ZXJuYWxfZmF1
bHRfY2FjaGUoKS4gSXQgc2hvdWxkIHRha2UgYSBjb3VudCB3aXRoIHJlc3BlY3QgdG8gdGhhdCwg
YW5kDQppbnRlcm5hbGx5IFREWCBjb2RlIGNhbiBhZGp1c3QgaXQgdXAgdG8gaW5jbHVkZSBEUEFN
VCBwYWdlcyBpZiBuZWVkZWQuDQoNCj4gDQo+IFRoaXMgYXNzdW1wdGlvbiB3aWxsIG5vdCBob2xk
IHRydWUgZm9yIHNwbGl0IGNhY2hlIGZvciBodWdlIHBhZ2VzLCB3aGVyZSBvbmx5DQo+IGEgc2lu
Z2xlIGxldmVsIGlzIG5lZWRlZCBhbmQgbWVtb3J5IGZvciBzcCwgc3AtPnNwdCwgYW5kIHNwLT5l
eHRlcm5hbF9zcHQgZG9lcw0KPiBub3QgbmVlZCB0byBiZSBhbGxvY2F0ZWQgZnJvbSB0aGUgc3Bs
aXQgY2FjaGUuIFsxXS4NCg0K

