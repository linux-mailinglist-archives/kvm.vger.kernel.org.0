Return-Path: <kvm+bounces-65170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A06C9CDCA
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 21:03:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CEC6F4E45E1
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 20:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884662EDD62;
	Tue,  2 Dec 2025 20:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EkWa+k2U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C5F2C2340;
	Tue,  2 Dec 2025 20:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764705770; cv=fail; b=Bh85NjmcEFXSkcnE384ZpZ6YQ5BKqlz/kuNd5Ry0/x69Yh2ccHM/Lr2WMWavof54D9bYtq7a7VGa9ujsARM/abBGIhfSyxXSsfjQ9w9qEOz4a9mTl0i4w1gB04BDBaCZ5dQDyansgpunWIRQJG1J18jXCYah0NAOrNLz9C2nWRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764705770; c=relaxed/simple;
	bh=c6sJrFLNXm/a3iuxABswFkdEZ8fMmNIbomgK3bgSr1E=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o+qj7sIKJ5Y1xcId//6DLgR8jsF7hdrBk59ahamjfTnDftTJJbZu9UJ0DsTJD1tHWSARxIIPwUNCj6PBVuWOHIbrTteQM35glXTHJ8UB74rg31/mf/7SBuT2zHV/Xvf1e9Fh2QHTURyRJhX4wRg31k7m8Vw+mKypUWXTNv3iMg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EkWa+k2U; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764705769; x=1796241769;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=c6sJrFLNXm/a3iuxABswFkdEZ8fMmNIbomgK3bgSr1E=;
  b=EkWa+k2UNY7UbWHCADYcum3HG8rPr3hbUrhUnazQNeC+AaIwsgxnz/An
   pCTJW1oLkilVlKjwwi9pjj0xeDobrrxkd8Mx3a//L01Med42bGN640QAp
   YG2ytbqTCWsCDRD8Fj2Ox3d7QFMAH2jGQMjUsdtItuVzUqUOM43WDhvjD
   O0WV1sWShZx73Idrg7J+lYS2bjB7gF7z7TgA3jzFNaSqB0akoVmiC1Xg1
   eWNsbsI4bDk5XSsIwm4I79p78KCG/SNbWYGHs/iN9XnLTY3ssioL1t76a
   H+k7PPtto1hKAPRfpF3m9az6+MeY5OzHPkqkS3Gtm7kpy8zoeTpXy2TS9
   Q==;
X-CSE-ConnectionGUID: sMVAmYqaRou63qF7NKBysg==
X-CSE-MsgGUID: kMYXlUHrRceD2ynHdvHSPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="77373658"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="77373658"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 12:02:48 -0800
X-CSE-ConnectionGUID: 4BI2R8C8T+2WXTWlEV8ccg==
X-CSE-MsgGUID: tAQ3Tja+TDGkEJCammr1OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="194288692"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 12:02:46 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 12:02:45 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 12:02:45 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.41) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 12:02:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y2OHbeSghdZWOyeHpnfQaDmdtW0uN0Rg0RWu3NYbOgHScYhdU+FPxqwj8Y8NMv2DgAVwvJJXHsC3wdGBv9x48yjRHwNbluqHEBXa0R0TyJbpo4Y8tRdse4U7MfcDbUEG0VHFynVNqBf/dB2xHYBDalgvj3npJcsTIJPH8OZnUxNE8jSiEuznyI3TI/xr2FO386QQxA7BoV/DmMB6NB2/beSczDuMdlVyPcbo7LsJX/c6G0VXmSsk8S2qwiboPr/7AKadZKVo0siP/NXjIi8DurVi2lNLAd5CW63yDJc/5Pnrf2+LkC9BRBlnPB40Z58f6+sydlq/ngkHnSQjYlqAHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6sJrFLNXm/a3iuxABswFkdEZ8fMmNIbomgK3bgSr1E=;
 b=XRCUCb2qOGFkQ8Ew1cFe6xCF3mcx/A09/lJXkU4/KJSppjlxlQCmqzvqGZ8LUWPBvA9yY9oQ6zzJD2wSlqQ0S+cN2AdgKN+rcg58WomHwwU+nP4/xEKNBrHcuNE8Bg2/mD0M6lNu4Rp3C/O927Z1B9Q4jdgmlFyR9gaqhWyszyGiKyvpBm/wGs/oqQ2xsjwVxP0F5LWQVx8H8KTxMbib0FJ6QBdu2R9+8YQRx2HrxGcEzXgL36EjoPtuEs9rh8Jod63Wzlk74095C9P0P021P+sui9lo9qxG30K7ReY0PQx0wlXccJsCdp8Fmqs0Ce1TihwPvDg3G9WRt2wBPb+DHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB7659.namprd11.prod.outlook.com (2603:10b6:510:28e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 20:02:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 20:02:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UGu/sAgAa1nwCAAJayAIAAz+YA
Date: Tue, 2 Dec 2025 20:02:38 +0000
Message-ID: <0274cee22d90cbfd2b26c52b864cde6dba04fc60.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
	 <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
	 <f080efe3-6bf4-4631-9018-2dbf546c25fb@suse.com>
In-Reply-To: <f080efe3-6bf4-4631-9018-2dbf546c25fb@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB7659:EE_
x-ms-office365-filtering-correlation-id: a9fd27bc-012a-4db7-fa21-08de31ddbe34
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?MmRPaHp2WVE0aFJIMVdDd3ovbG92RHBDSWpzRDJsTnp5VXdnQ3ZkN1RtRlFJ?=
 =?utf-8?B?N3psdkpqQ09aWkgxZ01GbDNvYlRocWt6VXp4eEdUWEU0L0tZVlpPUTRPci90?=
 =?utf-8?B?aUZjQ2IyQlFlb2daMmVoQ0FwMWltbmk4UGc1OCtZVDB6NUZJMm53b2I0Qlc5?=
 =?utf-8?B?QXNqS0N2THJOa1JYbDBKRGdsNFZwUkdDMmFVUjNUMWpvYUovMFVJNFVVNlhi?=
 =?utf-8?B?U3NMWERxUk1DVnpES1JEYVA2RnEzemNRRElPdGdiRmdJamhDaE1SMUJvWlI1?=
 =?utf-8?B?MG1zODJlTG5HaUZCY1pDNHhhWjkyMGsveVZsN0tkYU83b292ekZzbFQ5WlVq?=
 =?utf-8?B?Nm85czFROGdxTHBCdVZqNTZnTGx2Y2tWU2RYMVVRZUJDK3llMHU3RVdaaWRJ?=
 =?utf-8?B?NXlFTFJlajJtR0F5V2hsbERXaTV6SjBTSHRTZ25iUjBZOVpDMFlFQ2FkRXU1?=
 =?utf-8?B?Z0hhRXdwNU5DOXVDTU5OaUd4SHlnUUwwNFNxZjBxWGMzVWwxL05GcnBZRDR3?=
 =?utf-8?B?OHBlZFZvYklZQlVzRFhsYnJhNnRUR1hNSlgySC9xMzh4elJVeVlJSjFaSU1W?=
 =?utf-8?B?a0grNU9WWlZQY1FNSm9tbGtSRDQyUkY4LzBsK3o1dWEwV2JJQi8rVHZvZGht?=
 =?utf-8?B?RW5CemF3Wi81cXloYUE5TjhEMzRaS0phR0ZrajQxYUJDM1p1UEpVSWNvVTFL?=
 =?utf-8?B?SW1pYzNBZERaNHlXL0VmSXgxQ3hWN2JrMWU2SXU5MVUyYTRiZzl5Z3gweDAy?=
 =?utf-8?B?UnNzdlA0WFZoTkwyWTZzY0FnWVowN1prM1ByZDI4Wmp1bk1QU21SQllTbVUw?=
 =?utf-8?B?a3BmdDBxVzhDemxac2ZMeE5Canc2dDJ4QUI3djJLbDhJM3JGMlQreFBncE1N?=
 =?utf-8?B?U0VvTE9FVjd2cXVTMVZFcC9URUc0THZaSDJnQTI5VysrSjA3V09yTTQrQ1lr?=
 =?utf-8?B?d2pPeUlrbExJZVlLTGo2VVc4SzluZlluUW5kZWc0dHBqT0duSEpQTlkvYW5w?=
 =?utf-8?B?QmxESjM1YTRlcDJHMlZYSkdBN045NFpQa3MxalIwVGl3WlZRRVUrWURyRXlM?=
 =?utf-8?B?aVpPSEdvRnlwTERZc0lCOCtZZTVwY0pzK0NRSHVISm5yd3l6UVJMK2NJU0RT?=
 =?utf-8?B?R1NBWVZiL1c5akxoRnBMa0xDd1JzU0hWQWhaQS9zQ201YmxUa2lBeTc1Q2Q5?=
 =?utf-8?B?YUNYLzJIOHZQSjY3ZEl3dG1KelRRempKbGsvZU5QK2hxbTF1dG0wUS91Y0xv?=
 =?utf-8?B?d29jL0tUbU1mRDI3K0tlRU40eVlLLzdJcUlBQmUxeVRYUGlRejdDRlBIczA2?=
 =?utf-8?B?TEZQbG9CVElUQmxVeVp3UEE1dnVsS1BKeFJqZHBKNzlscndVTXF1RXJMYTBB?=
 =?utf-8?B?ZnlPaUdxbVUvaXNaU1pjWXB0dmlrQjBMYS9INVp5YVFNQndSaUtsaTRrbUJh?=
 =?utf-8?B?RnNRRW5iWjFJR09Jb0xzU092eGdZWVdkbEtDYzI2eEQvSjFvV2hYd3ZITjJY?=
 =?utf-8?B?cHNWT09NalZOdHJFV2taWG1PbWFzNGlKOGtmVGZ6cFpBMjJxRDRMbmMyeDJM?=
 =?utf-8?B?ZFNoM3pkRHIxSUk2dFZ4eG5LdUtsa1M3SjhtcEIySHFwZTBkYnBWQ04rNTV0?=
 =?utf-8?B?S2o1SDg2OTZ1YTk0Vm16RWpycC9VZDZxRFdkOHh5Z3hOVlJLVjEwYWF3QWpI?=
 =?utf-8?B?NDJEM2dRYzZiYm1ONjg4NSswOUNrVlUrUUgvR09kL3FMODZra3c5d0xReEth?=
 =?utf-8?B?TUhRbktITTRZRG5oOFc4SDBGUWNxWm91YTF5TmFrUkR2dFFiS0lBSytGYkw0?=
 =?utf-8?B?azhieUdkQjlUc3RXU2tyaU81d25TQVZwT1BxU3RhaFlrMUd5MWtGeVhSQ1pY?=
 =?utf-8?B?UGhENGhhUTN2VUEvR1BJaGdYb1pheC9FUzNTVW41aXVXZjc0NUdGMmxsL2dF?=
 =?utf-8?B?V1grbVpVemQxQmtONnRrQ2w2UXlidWZtRU5jbWhVcGVYUEFhZVFna3MwNGp3?=
 =?utf-8?B?Ti9lOTVPOUN2WTFmc1lZSlpINzYwVzJ2TWQ4cjJzMWdjVmpKaWRWY1ZmSTU0?=
 =?utf-8?B?Z0RTcXVkTi8xT2RhZURYNVczaWJGdUlFbklDdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bEpQVTZmMHllcDZ5eGhZVGduVHo3WUlVSndSamEyVS8zeWI5SytHNTd0OHI0?=
 =?utf-8?B?YVpjYk1xbTJ6R1A5andGZDVPck1sb29JSHI4cUZ2QW00YzhhcTJBNlRBdzUw?=
 =?utf-8?B?SnVOTUJUMU13ajdlWDVzQXFRWWloVElsaVkxd01VR0EzQ24rU1B0ekZiV2Jy?=
 =?utf-8?B?RUVWY3NQa3RXalhMN2tvL3UxOUloS0gvdXErU2s0bzNablRpQ08wY3l0NDZ5?=
 =?utf-8?B?UmRHUWhlN0JxVE1ZSXFZNEpvWE1uQVRmcFBvSVdEZjNVUFpGaFh5ZGZwbFdu?=
 =?utf-8?B?ZW45SFlZanhRZ3F6QWphKzZKVUh0UlBKM0pzSnlROE1uNlpvWUpkYkZZcUwy?=
 =?utf-8?B?aExwdTNXRXRuMUdhT214U0hndjNLblpNcmlYN0lhWkV0Y0hFblFVeTRBRDdv?=
 =?utf-8?B?cEp3SjF3aWlTOXRkNzlkeFJJSlhLZ2hCVDVaemVSU0VmSXRpMU5uWU8zQXlE?=
 =?utf-8?B?R2hZYVZCYmFMYm1iL3FPTEFLNFN2cno5cHowUnhobVhvNS9WTjhZMUpLSWtp?=
 =?utf-8?B?MEE3emc4bm1yVmprNkNYSUNBQU45OEJnMHplRmlGdU93YWV1WEhjV2x2ZURU?=
 =?utf-8?B?WWNTbHkrWVpTNEltS3U1RFErN3ZlK2xtdWE1aHFpV0svL0RpWCs2ck02UzBs?=
 =?utf-8?B?dWZJaWpQWjZrandnQjVmbS84TVoyeWVtSU1td1ArUng3MmxCVDE3Y3pMYkVI?=
 =?utf-8?B?TldWcTZkM1hDM0QrSVZTOGNWRjZhWlR4N3dJVmdvVlYxOUdJZnoxNkJFL1o5?=
 =?utf-8?B?b0xxSUtvMlJVcStJRkJlTGJ5V1hIaS8wVmJiS0VwU0E4RzJVZXBKNVVzS0RW?=
 =?utf-8?B?aDR6ci9VMTJuWXVvK25YOTM5bHI1M0NKQ0VObnFrMVVXV1MrYXVjV3FaVnVz?=
 =?utf-8?B?cVlSNU5TYU94NkxraXRCZHA3SXRDUG9yRWlEZEpTZ1lYeEFEYXF3Q0srNm96?=
 =?utf-8?B?WUZwU2R0V2hBaENCN0pZZFVLNjFwcnExb2J2ZjkzcjNIN3VoTGU5S2t0SjQ2?=
 =?utf-8?B?NktFckdHQ1NrZzlxNlZYanNHZnlNM1pBS2lxT1BVdTVDM0J2SWRyYlhnbkMv?=
 =?utf-8?B?K2ZsWENzdzF2cngrQ0dDS2NYUGlMdlJDOEllNVZtTktHdVBYVC9Bam1KZjMr?=
 =?utf-8?B?NmRGUmJJMVRHR294MnREbFNHL0NhRDBRaEFuZEliN0NqYXpVSURZRHdXT0Z0?=
 =?utf-8?B?T0Y0VnhRbW5vckYyZUw4QjJJbXF1d285K1JmaTFXeklwdUY2dzQxSlBseHl2?=
 =?utf-8?B?cGhZN29Kb29WL3F0Tzg0S0d0d3MydmJDNnNZdnEwMFgvd0s1citxckVnOUpV?=
 =?utf-8?B?VFRObDdqcjM1YzZYNG1QS3QwMTAxTzZQTUgwKzNVTGZtVklIdTB4Y2U4QXV1?=
 =?utf-8?B?U3V6cUdHTFhXRGxZd1kyL3AyOTNmZ0MyZTlTb01YcHdpTG9FYkZaNEdEUlZy?=
 =?utf-8?B?R01obHcrUk9IRnduRmdzTlNUWmZQTWhZRmc1WXhWNThUYmtzdm9QMzdTLytz?=
 =?utf-8?B?NkVDeFcrTWx2SGpMQkt3S0ZEaER6R2ZRTWNFQ0U3UGhTYmF0SEEwUDJydEVW?=
 =?utf-8?B?UEFkeHBrMWZ5VzhCVGxhS3dtRDl4MDB0a24zQi9iNm9SeGJJcnRNWk53QUVO?=
 =?utf-8?B?dVFqS3Q4cWVGdUNLazEvNU40ZXVYN0s4dVNBTGpLK1RBaVFPOGNVRndyQnEx?=
 =?utf-8?B?N2ZQN2g4Q1RvZ0VIVjFmSTkreTV2S2VKSlZVRit6MHpYdldiaDhYL1pNUEgr?=
 =?utf-8?B?M2lCeWZZZWN3QVRFMyt0OU9yaEZsWGllVGRzNi9qTldnWlp3RFkzaUpzenp6?=
 =?utf-8?B?dUQxQVBoK2FXMkd1N1NZTHRXblVxTHhJcDdoUkY4dkFwZnVWSk1PUGdEMXBT?=
 =?utf-8?B?NmZkZFJuU3VWRWZsRWdJZ3hqYlpMTnVxQjVnTjlyNnNFQW5TSWVqejk0VWdw?=
 =?utf-8?B?Q3ZVb0t0ekhBQkMrSkpUTnRZeDRKbStSVW5ieHZXTkVra1dPWmZQS0dTakQ0?=
 =?utf-8?B?Vm9FdGlQeGVuK2xrTEhJQktmamRSN2F0c0FPaHVraWxCMGEwWGRDOUdVZ2x0?=
 =?utf-8?B?UVZEVXVHQWpFWWNDSlpyTHk4V1ZLSktVV0poWUhzd3ZqWVExRE1ENm10L0cv?=
 =?utf-8?B?bWlCVnhDY2U0cnp5bGhZT0hwMklLZVliVGxuNHNqMzRNanJONm1OTVl3bE9q?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AEA4D29D766F5F4F97255C85EFCBB46C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fd27bc-012a-4db7-fa21-08de31ddbe34
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2025 20:02:38.1598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5dL/xpNrJSRgeUDqN4BA6URaAp1E1inHP9xb8DD5kf7I8B/y+ltsGmhijKHJUdNpbIGjIr8XSOQvrz0bSPzha4SIr8C2JNAeg9xAnZ1bOGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7659
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTEyLTAyIGF0IDA5OjM4ICswMjAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gWWVhLCBpdCBjb3VsZCBiZSBzaW1wbGVyIGlmIGl0IHdhcyBhbHdheXMgZ3VhcmFudGVl
ZCB0byBiZSAyIHBhZ2VzLiBCdXQgaXQNCj4gPiB3YXMNCj4gPiBteSB1bmRlcnN0YW5kaW5nIHRo
YXQgaXQgd291bGQgbm90IGJlIGEgZml4ZWQgc2l6ZS4gQ2FuIHlvdSBwb2ludCB0byB3aGF0DQo+
ID4gZG9jcw0KPiA+IG1ha2VzIHlvdSB0aGluayB0aGF0Pw0KPiANCj4gTG9va2luZyBhdCB0aGUg
UEhZTUVNLlBBTVQuQUREIEFCSSBzcGVjIHRoZSBwYWdlcyBiZWluZyBhZGRlZCBhcmUgYWx3YXlz
IA0KPiBwdXQgaW50byBwYWlyIGluIHJkeC9yOC4gU28gZS5nLiBsb29raW5nIGludG8gdGRoX3Bo
eW1lbV9wYW10X2FkZCByY3ggaXMgDQo+IHNldCB0byBhIDJtYiBwYWdlLCBhbmQgc3Vic2VxdWVu
dGx5IHdlIGhhdmUgdGhlIG1lbWNweSB3aGljaCBzaW1wbHkgc2V0cyANCj4gdGhlIHJkeC9yOCBp
bnB1dCBhcmd1bWVudCByZWdpc3RlcnMsIG5vID8gT3IgYW0gSSBtaXN1bmRlcnN0YW5kaW5nIHRo
ZSANCj4gY29kZT8NCg0KSG1tLCB5b3UgYXJlIHRvdGFsbHkgcmlnaHQuIFRoZSBkb2NzIHNwZWNp
ZnkgdGhlIHNpemUgb2YgdGhlIDRrIGVudHJpZXMsIGJ1dA0KZG9lc24ndCBzcGVjaWZ5IHRoYXQg
RHluYW1pYyBQQU1UIGlzIHN1cHBvc2VkIHRvIHByb3ZpZGUgbGFyZ2VyIHNpemVzIGluIHRoZQ0K
b3RoZXIgcmVnaXN0ZXJzLiBBIHJlYXNvbmFibGUgcmVhZGluZyBjb3VsZCBhc3N1bWUgMiBwYWdl
cyBhbHdheXMsIGFuZCB0aGUgdXNhZ2UNCm9mIHRoZSBvdGhlciByZWdpc3RlcnMgc2VlbXMgbGlr
ZSBhbiBhc3N1bXB0aW9uLg0KDQpLaXJpbGwsIGFueSBoaXN0b3J5IGhlcmU/DQoNCk90aGVyd2lz
ZSwgd2UgY291bGQgdHVybiB0ZHhfZHBhbXRfZW50cnlfcGFnZXMoKSBpbnRvIGEgZGVmaW5lIGFu
ZCBzaHJpbmsgdGhlDQpzdGFjayBhbGxvY2F0ZWQgYnVmZmVycy4gSSdsbCBzZWUgaG93IG11Y2gg
cmVtb3ZpbmcgdGhlIGxvb3BzIGhlbHBzLg0K

