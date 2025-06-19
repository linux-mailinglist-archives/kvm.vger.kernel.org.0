Return-Path: <kvm+bounces-49924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D499ADFA15
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 02:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83B77189E5B2
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 00:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B3478F39;
	Thu, 19 Jun 2025 00:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wi6uDysE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E7129A0;
	Thu, 19 Jun 2025 00:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750292579; cv=fail; b=PwWMQAjgVnexvXSgYNDFe6feb3GPwwo52SnX08rvzbHuCwI11cBru+lmgPG8HHouYhg1VV6x5hSU7FCve6O6Up7Se2WqYHt5oNJDtkbqd8XYLkwijPxpSu6id0ideoawg62KnUY6K8ihocuq1LJ+3n81wm/Uhb+MPzhC0n2KFak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750292579; c=relaxed/simple;
	bh=REQGhbwIvXhAhgtZxFY/GblGhndQv3WLVhS3Y8UeGvc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iDRtLJw/4SfwUSFShSS7Pw5kX0l9erlEu325ZHOKb7pv/K3VOy5ThuWKtsY+zu0GusaIZ0hcyJA83cLXobggT/2T+El55I4O9+SQR0MJzBu1aqA6wrPYEwziIjDwhawqhQZ9sIdGpkBznG0vl0w39BKYPnS2Xz5L8qVS3Ei8yHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wi6uDysE; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750292577; x=1781828577;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=REQGhbwIvXhAhgtZxFY/GblGhndQv3WLVhS3Y8UeGvc=;
  b=Wi6uDysEO/mzsOXFHaS832Kpdz6PzjgARw8PYCoXUAWC4Lpa+/vjylKC
   QbarlpbVybJyioIW06uTdGmqaAbODSiSjdQhp34khs89EPd7VOGk0Qj+o
   /sC0tPOlgamRMGzUOpOJfvNKprQ/RRU5Xn3RqLgVPWg+0bN5VAuC4e2VB
   RN3Bpo6Hizc3hyUooTcf9JTYiMWjEuh7cdVPYMILxU7aQiu1nHGsiq1Ox
   NGmjUCcyVowpBgz3Dzd2fNAneJF4OzZRjH/Ecxzvq0zli8VzVwGCtIy9n
   4IHDHHaHWUcWEZNwOghNcdvJRcFcbPUYzTpnt71bFLee1Pm2deVwvqOq3
   w==;
X-CSE-ConnectionGUID: tt6uYDaPQLu94rkh4hQEMA==
X-CSE-MsgGUID: ubfvcZOKSf6SV6nTAhlx9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="70105664"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="70105664"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 17:22:46 -0700
X-CSE-ConnectionGUID: enr0yNfKTRC8i4uO6Rsgnw==
X-CSE-MsgGUID: 2T6bZONqQAC2AI4ix8IPKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="150803070"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 17:22:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 17:22:43 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 17:22:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.68)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 17:22:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tY4ojKfIdLUM37R3gCw/U9etBOi/hv8kKXZVqjcgzgDodav0iYWOi6kK07HyH9GG9EZGvfjVfhOGa21zmHA3pxmYGzyZFm55aId1b2A9SE0mcQtBg/meaKFR78VeP3/p5g2gIzRAzxXdYZu+O38Wu/DNF1+mKM94lWFbtq/4/4D6H1GvZWGUN4EIHbmWs58C4vnDRYLNk4Zu8RTLlWBny6UaErH2fcUxChhdJKtFHG5kln3ve9PHLEcF7YAiU36CGlf3eM4UAR0A07ia61IfMgy00ioJH8jowkfU8r1htUMGrlM/rlDe59dJTBQTCRJ0XTt6TQq7lzllhBPDwxznUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=REQGhbwIvXhAhgtZxFY/GblGhndQv3WLVhS3Y8UeGvc=;
 b=J/ykuG0rYf8ll67lfTEp72+NrlYb2vu22luv1n32PHnEGFgoXrE2m0eCtftaZ8tChFtIueb9dFLG1HVorFIWTd2+EjXjpvuR9frNDv0cO46a7bXrcfhyiXJ2itsbqCx++FB+a879618Dhnkq3+4pJbdLWC5lXlsZARg/mpOScnLV+Ii5j3HfXTsZ00Dx4ZLbQwufLt7xueEDBLCes40VxFIxkTKPwluFtpXW9TvwjeP6anhaeuyPkR8LIg9IFCqQO1m6KjU0s6VIdDevHoNxF11h+lGdKDCN1Qy6ZC1SsLnEbUZvjLkZ38hG6BDdppaU5L83zf+7K2AxawExw+wSrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6824.namprd11.prod.outlook.com (2603:10b6:806:29e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Thu, 19 Jun
 2025 00:22:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 00:22:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIABK6CAgAAyp4CAABVEgIABE0sAgABBygCAAU1AgA==
Date: Thu, 19 Jun 2025 00:22:40 +0000
Message-ID: <62b1c20ceed0aa657db5fe73a2f81a37d211f28f.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
	 <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
	 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com>
	 <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
	 <8f686932b23ccdf34888db3dc5a8874666f1f89f.camel@intel.com>
	 <CAGtprH_RaZ9aTB-da1rzjXYZhLvLViAWfALJz3dojqjH2eSgmA@mail.gmail.com>
In-Reply-To: <CAGtprH_RaZ9aTB-da1rzjXYZhLvLViAWfALJz3dojqjH2eSgmA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6824:EE_
x-ms-office365-filtering-correlation-id: 7afb7c2c-3b25-4ecb-d10b-08ddaec76709
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S21HUlM2V3Q5WktkRml2cm43TDcyQnc0aGJxSDZ3UEtWRU9ORTJsb1NsVk1l?=
 =?utf-8?B?QlJuYmMrTE1CWkNPSjY3ZjBmNVA4MjJhRTg2MVY3bTZSTkhlV1o0amVNNzZG?=
 =?utf-8?B?NUNHbThLaHUyaWMxVzR5VDZzYy9JSHlHTE5YQ2FyWnd2Nkw4azBhbm45T1hD?=
 =?utf-8?B?N2FocjhJeklOdERCa3IwNE9XQWVMZzJUWUhJaDRkcDhLRW1yK1RQcHNldEdX?=
 =?utf-8?B?VkNsRUVMSDI0M3JjZkgza0xsSWF2WGpEWHNXZGlPczRwLzVUVkxHTUFPS1lB?=
 =?utf-8?B?dWR6eHVFVWNTTThWQkY4L0dPVG5Gcms4YnFlKzFVSzlXSE5HK2pmcldvdTR5?=
 =?utf-8?B?RmZJVWQ2Mk03NENwZjYvMU9LQ2pSOFJPSWMxVHZWN041cnhURjIzdDlNWUpW?=
 =?utf-8?B?MFRrMWc4MTlaOXViOTlqa0l0Q0RrdXA5OU1mc0EzU3EzbDd1L3VwZXYvejBP?=
 =?utf-8?B?WjEzNUtJMWlPTTFWK1R6bXQ4Si9MOGc2dncranNVQU5Bc1BUMzdHb21EM2tz?=
 =?utf-8?B?aHZSc3dNZ1ZFUTU3L2drdG41a3FQSnhwNjJaTjlKQ2dxTzhsN1JUQUlqaFBF?=
 =?utf-8?B?RUo1ZHNFUEF2UTFhRHNwYVdTTytYUUwxQ2cwU3VCY0UreEFxYWdrVExsTEdo?=
 =?utf-8?B?cXVmb05RelNpN1l3RlZFakVUN2RXWG8wL3g0Y3djMXFRS0N0RzFOTjNsMWFR?=
 =?utf-8?B?QjRIMkp4UWVYWlpzWFQ0WnZHT0VMK0pxOW94d245a3cxVi9CaWsyZXR5eUtt?=
 =?utf-8?B?dytveFlacFA1RE1tdnluRE1ucjNVWkFnczNXcEdmOU1QR1JrT1RnUmk2eGx3?=
 =?utf-8?B?WHExVEtRU1FEL2lvRTl5Z3FDenA0UkdZMXFiQ1F2dUxZVDNVajVZYzZSSVFD?=
 =?utf-8?B?aTZmMytLcFhzaGxrYythVGFPNSthSlQ4OGh6ZDk1eHpxbGJVcW0xRFlWZDlx?=
 =?utf-8?B?VnJSYVFWd1hVZkhaY0lMcXdoSHhtZ2w5UktGVnI1VTJ2NFVrMWx0WW5uUk9h?=
 =?utf-8?B?SFgvZkFDbU1OMUZPaC9rNngyeXMya3NkZ2YvdWdaeUxqdFpqUlh0ajhmSU85?=
 =?utf-8?B?enBVVmRPMzFhaGpPa0lBK1BzWDY4NWd1MmxMZnorNU5rYlBBb1dmT2JZc1Na?=
 =?utf-8?B?eWxNWVM2bVFMUVB1S2pWV25SQ3ZzMFdINVRNRXJ3dHl4c05PaUh3M1ErSEY0?=
 =?utf-8?B?L24vWGRrbHVZZ2JyT0VuN3hmK0hxKzk1RTlKSkVRQi9SOVowUUFhbXluVHZF?=
 =?utf-8?B?TFFDNnhTMVBJZmlSTmpLb21NRnV4VHh1TUtWYkxIdTJxMjdKNnZNZVRqY1Np?=
 =?utf-8?B?aGVhREN6ZEQvZ3hrVGZlQXVENG5CZjdCMkN3ZTNzUkJtdmVnems1Snp3VUdC?=
 =?utf-8?B?ZEVmMkRIdSs0eUdFZ21Xa0I5UzRxNzd1WTZPd1dJclBnZVk4eHFUOW1uQmVY?=
 =?utf-8?B?NUkxT3ZlUzdKKzdVUTR2TThXTXhDaEs5d2ZvRmhCa2JjZEhqNVd0QWZhNXFr?=
 =?utf-8?B?eiswUk5yS3RSSytQVThrYTJMTWI4RDlNZU9TcUtkdWloMURtMDE3Mzd2VVVG?=
 =?utf-8?B?bm10enQreEt0ZEpJUEtPbmMwcG52aGx6a0RpV3FuaXlnUEtISnQxNGtpSWRE?=
 =?utf-8?B?NFB5VnJJS1pEUHdLZjBvdWJabTdtQ2dLS2VzTk1RYVhrYm5QOVVZb0M2Qmxq?=
 =?utf-8?B?S3NCdEZ6eGtlZ2dHcHRyRVo2bmZMNWtCQ1RtV3Mvdkx6VVlGZ1Fqa1RjQUFN?=
 =?utf-8?B?aWRSeUxkVkI4czNrQm5FY2ZEaGxMTUVvV3dpZVYwMlBqaCtYbUliQ3M2UUtB?=
 =?utf-8?B?aFBaeXFpZXFFQlJ4NlZYanlFbEtCK3hXeUFteGxIaDluamVpV2lYRUkvUWNy?=
 =?utf-8?B?Z0tVNllrOEc1MjRDNm1zdTV5aVUrUTVqNFRJengwMjNYcW9FMnpvWHBFMGpN?=
 =?utf-8?B?Zmxaa1NtTDNsK3lqallOd2N5NTJQQXBkZGE3WTFpWnB0YkVZTGlkZkIzejFk?=
 =?utf-8?B?ZmdETk9jM0hRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUZFaDlrZXVkUGtyd29OcmFnSm1GQXVDTGIvNHI2Wm1FdU44ekR5WE1qNmt6?=
 =?utf-8?B?Q2o5NndoWmRMNUNOZTFRWXR5aTJPek81MVpNSXk0KzgrYVJLektVOXQ3bm0w?=
 =?utf-8?B?ZzY1T0l1NVBZYzQycHJKZHVPdkNsWGZ4UWkxSGNLMGttY0R4TXZHazZmSEFI?=
 =?utf-8?B?eHE3cXdBNkNrbFNWUUkrNXFMMzFOaC9XeExpbVU4Y3U5OTN4YkdIaWJhUDN0?=
 =?utf-8?B?U3VPSkMzSFJnYVdBOTV4THMzSU53dGk3TVcrREdxcVl2TU96c2Zod3hLbTZP?=
 =?utf-8?B?d2k1NW0xWERwejRHclU1M0hNOGozWVJnRzZBc2tuTnRRdU50dXdRUW5aWUZX?=
 =?utf-8?B?SE43QUZQM1RqU2NtTGJrVkZ3Qzh3M1kxOHAwT0xVaUIvYzA4VWRLUk4wTEdl?=
 =?utf-8?B?b3pVUUZaYmwrUER4T3Fka015VEo1MGpVSitSU1lzbU1rOHpaa21wdlRxamdt?=
 =?utf-8?B?dlVPZ2picVhIQjBLd2tGTDg5RVdSRHM3UG8rV2FBckVNVGkwZUVYUHJjR1FY?=
 =?utf-8?B?YzAvb2VwYk0rdm5tVkVNYlROenRwSTkyamtRbHZ2emI0RnVUbkJEZzI5LzZ1?=
 =?utf-8?B?T2djeGlOanI2QnExY3FxOVhGQjlQK0p4TEVBNW1YM2NjNCtmMENlY3BKeTRz?=
 =?utf-8?B?UTBlUXRBa3d1amRzSGhqZTZOUVpMNUZmZHA5dVA4M1h6Z1N2UzVQcGpCQ0kx?=
 =?utf-8?B?SGtZL1pVSjNVRlMreDlQSFNMNlIzNGVqNS9hWUYzSElad2pYWVZGc3lzU2Vu?=
 =?utf-8?B?MnBRRWkwVkhUdjJoek9GWWlTRllmbjJlVUhveVpIUkFhVUVJWmdYY0lLZFVX?=
 =?utf-8?B?ZEdRT2JTelF5ZVpvQXFuNDJocFI1NzRFOGtzRHJKWEUyMEdENVhoOGU3SmJ3?=
 =?utf-8?B?OE56U3BsVmNuTXM5dVN2SWFmT3l4UWhDSWYwSnhkZGtmZ3VNMHRGaFhhb2li?=
 =?utf-8?B?ZGl6dWhuVzNQdDRmemJXVGRSeFV2WTdNM3c3My92Ui9ielJhUHplR0YzQUxM?=
 =?utf-8?B?UTlVRFhNOWhBandlU2FnaTVtWUtYc1pRQmZHQ1A1QUJpK2pPVTc1MUhOMldP?=
 =?utf-8?B?NTEzek1CV1Qra0ZIOXI1THdpYzV6OFQzYi9EQ05MSC9MUVM2Q3MrYUFwdkF4?=
 =?utf-8?B?eW9LOXZxNS85Um01ZTdJbkkwbng4TmRhRHZsbFVnTEQxL2pGaU5mRHhDbWta?=
 =?utf-8?B?TjBvSkNkZG82Zlk3ZmtlRmdUYU9FR2ltdG1zVHZCQUUvQkQ0VTJBV05EOUhv?=
 =?utf-8?B?Tnh4aXVjU2V6ZU1FY0tBZmQvK01HTXVobDdIanhaSm1VOGM1TEJ0Q0hsMEta?=
 =?utf-8?B?SDlTekRrVEpFSzVvM08wNkc2YXJDdmpFVy9YSElPWmIzc0crYjB1VmdsYi85?=
 =?utf-8?B?Tk9iak5yMEM5c29Td0xPR0FtclR3cHhQNUJOeHJRd3lOZmlVT3lpVTBSUURp?=
 =?utf-8?B?TGQ4TGNXSzJyeDRLeXI3bm5lUnlielAvdytaUExET2xRV3R0TFRmdC9jM3la?=
 =?utf-8?B?RUgvNkNSVzV2MW1JL1VMTmp1dDNJOFJVOUE3RW45dTY1TTcyOVlIOWI0eUht?=
 =?utf-8?B?UVFzbFZqQUQ5bkxUbTE0dnMrQS9SYjloWEw2bzlNMU51VEJsa25EUElSQjFW?=
 =?utf-8?B?eGJTRGdxT2lpc2QwSTN3b09xMzFNT3RPWWtXZG5kYml5eW9NZWticXRqb2Jn?=
 =?utf-8?B?bUFCWnhRTVV6WXJyaWdpdlJXK0oxb2ZzVzFtMFdwaWFwS05UeXIvbkZUSTdR?=
 =?utf-8?B?YllHcGw3ZzlNKzV0QjgzdXcwN2tkVjFWY3k2L1l3YkhDd2JpSDViRk9BL3Yz?=
 =?utf-8?B?dXNVYU9tQWVDdUMwMlRUeHgrajcxY3Nxblg4c0xMbnh1Wi9ESjJGUHk4TUll?=
 =?utf-8?B?VkdXYTNhNE9YeWhQRTRZTUIzbS96WXBPUW9BRWRMUEhCYjlhc2dzcUhYWmE0?=
 =?utf-8?B?dXNqOW9tbnY4N0NUd25qMWdqdWhzNHVXUm5iWWdrdTBRUWdkajdOMzI4MWF2?=
 =?utf-8?B?TW9jdWZlOGViQTBRSGlKS3NGZ2hLa1NDbUM5TmMwWUZtMFhuOXhmVUxVTnpP?=
 =?utf-8?B?dExmQmxIL0pReUdJby9MdmFKZ0drN0xZUTBDOWhsTFk5OVlTQ0FKck9UdVpm?=
 =?utf-8?B?djhyc3BRZXp1Nm9SSlRBTi9wVjk1RjBwM3FhTkVaQU9Qekt1bzI2Rkl5QlR6?=
 =?utf-8?B?V0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04A6B5524FAF604AA981F646E25CE6D9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7afb7c2c-3b25-4ecb-d10b-08ddaec76709
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 00:22:40.6734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t9q3kgkj+LxwDdwj4qNu0gTu0NjLAHQH2HP9QUk/si8TgUbdGaPMV+63QriqyGASQpq8UJRA+Jk6cBHIJpkN3utr5hSHF4BCLn/w6LWIbcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6824
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTE3IGF0IDIxOjI5IC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiA+IFRoaXMgbWVhbnMgdGhlIHJlZmNvdW50IGNvdWxkIGJlIGluY3JlYXNlZCBmb3Igb3Ro
ZXIgcmVhc29ucywgYW5kIHNvDQo+ID4gZ3Vlc3RtZW1mZA0KPiA+IHNob3VsZG4ndCByZWx5IG9u
IHJlZmNvdW50cyBmb3IgaXQncyBwdXJwb3Nlcz8gU28sIGl0IGlzIG5vdCBhIHByb2JsZW0gZm9y
DQo+ID4gb3RoZXINCj4gPiBjb21wb25lbnRzIGhhbmRsaW5nIHRoZSBwYWdlIGVsZXZhdGUgdGhl
IHJlZmNvdW50Pw0KPiANCj4gSXQncyBzaW1wbGVyIHRvIGhhbmRsZSB0aGUgdHJhbnNpZW50IHJl
ZmNvdW50cyBhcyB0aGVyZSBhcmUgZm9sbG93aW5nIG9wdGlvbnM6DQo+IDEpIFdhaXQgZm9yIGEg
c21hbGwgYW1vdW50IG9mIHRpbWUNCj4gMikgS2VlcCB0aGUgZm9saW8gcmVmY291bnRzIGZyb3pl
biB0byB6ZXJvIGF0IGFsbCB0aW1lcywgd2hpY2ggd2lsbA0KPiBlZmZlY3RpdmVseSBlbGltaW5h
dGUgdGhlIHNjZW5hcmlvIG9mIHRyYW5zaWVudCByZWZjb3VudHMuDQo+IDMpIFVzZSByYXcgbWVt
b3J5IHdpdGhvdXQgcGFnZSBzdHJ1Y3RzIC0gdW5tYW5hZ2VkIGJ5IGtlcm5lbC4NCj4gDQo+ID4g
DQo+ID4gPiANCj4gPiA+IEFub3RoZXIgcmVhc29uIHRvIGF2b2lkIHJlbHlpbmcgb24gcmVmY291
bnRzIGlzIHRvIG5vdCBibG9jayB1c2FnZSBvZg0KPiA+ID4gcmF3IHBoeXNpY2FsIG1lbW9yeSB1
bm1hbmFnZWQgYnkga2VybmVsICh3aXRob3V0IHBhZ2Ugc3RydWN0cykgdG8gYmFjaw0KPiA+ID4g
Z3Vlc3QgcHJpdmF0ZSBtZW1vcnkgYXMgd2UgaGFkIGRpc2N1c3NlZCBwcmV2aW91c2x5LiBUaGlz
IHdpbGwgaGVscA0KPiA+ID4gc2ltcGxpZnkgbWVyZ2Uvc3BsaXQgb3BlcmF0aW9ucyBkdXJpbmcg
Y29udmVyc2lvbnMgYW5kIGhlbHAgdXNlY2FzZXMNCj4gPiA+IGxpa2UgZ3Vlc3QgbWVtb3J5IHBl
cnNpc3RlbmNlIFsyXSBhbmQgbm9uLWNvbmZpZGVudGlhbCBWTXMuDQo+ID4gDQo+ID4gSWYgdGhp
cyBiZWNvbWVzIGEgdGhpbmcgZm9yIHByaXZhdGUgbWVtb3J5ICh3aGljaCBpdCBpc24ndCB5ZXQp
LCB0aGVuDQo+ID4gY291bGRuJ3QNCj4gPiB3ZSBqdXN0IGNoYW5nZSB0aGluZ3MgYXQgdGhhdCBw
b2ludD8NCj4gDQo+IEl0IHdvdWxkIGJlIGdyZWF0IHRvIGF2b2lkIGhhdmluZyB0byBnbyB0aHJv
dWdoIGRpc2N1c3Npb24gYWdhaW4sIGlmDQo+IHdlIGhhdmUgZ29vZCByZWFzb25zIHRvIGhhbmRs
ZSBpdCBub3cuDQoNCkkgdGhvdWdodCB3ZSBhbHJlYWR5IGNhbWUgdG8gYWdyZWVtZW50IG9uIHdo
ZXRoZXIgdG8gc3BlbmQgdGltZSBwcmUtZGVzaWduaW5nDQpmb3IgZnV0dXJlIHRoaW5ncy4gVGhp
cyB0aHJlYWQgaGFzIGdvdHRlbiBwcmV0dHkgbG9uZywgY2FuIHdlIHN0aWNrIHRvIHRoZQ0KY3Vy
cmVudCBwcm9ibGVtcyBpbiBhbiBlZmZvcnQgdG8gY2xvc2UgaXQ/DQoNCg==

