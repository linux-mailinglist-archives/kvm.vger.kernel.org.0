Return-Path: <kvm+bounces-42387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D7D6A78145
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DB887A2C3E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6956220E717;
	Tue,  1 Apr 2025 17:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZd10GbC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F5D20E33F;
	Tue,  1 Apr 2025 17:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527761; cv=fail; b=GHfhk+hChLdw2dAqTJ4AIxjODT/RsJ/nkNJSjc6t+BsZF5RZ4SyntgH+pm/fz6bnqIVx0wNvlHLi+0uzwShXFkWX8s76ZCdF5Qv0AC+FP9fPMt678bX8Hf7CiShH4sMYBz1AKI9UyjrfIm5gWVLYps/9V4OfVv2PgIDcXREv1XE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527761; c=relaxed/simple;
	bh=SqWueqzqCYFu7ouNLiXRSAXkP97he1hzHd6RnBLLASs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nPnjg5nHc/+5HBdpsdddiTHYvql9UYMiCo8YORs4V81hsXp7r4c5F4G8BQu/SHGcmH4T8RC/qZM0y97b7Niw54sKFfdZOLKnAJ4OdlagTjut5jnu3EGNltz5+HbyYa0S6i6ytgOZl8fDoTUyMNwqkTcD8V4L7JyZMFbcxn3oVRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dZd10GbC; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743527760; x=1775063760;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SqWueqzqCYFu7ouNLiXRSAXkP97he1hzHd6RnBLLASs=;
  b=dZd10GbCQn1UED/F1BUkRyqgfd9KzSYbxiiRbniq+84Yj8t9JS1ZEzc3
   FY9iq4gwpUEkjIVfeGhAR/YO5AM+c/ruL6tC4WLQdXaDhWtTHOX1ugsWS
   4+D2UoknbspBcrZNlX+8S9UUgfU5L2mM6h0ohyQPOR9dUxGsN6xwOwxRN
   AE8nB0ooNxdHLc2sBY/p9QqcqoFQUmd8NpUlfEz/3vBnTgGRBkQu0d6Rl
   wQMbCpbdmCmmg2oBV31HRpjeL5B/2Ymh5nna/KQs35VwJ5dy6smCm3r34
   cqemNPCa6BTEAOQE0rXX5J0Dosfl7/qresYKSrTr/Vy7ansl8xhBVvjs7
   A==;
X-CSE-ConnectionGUID: hrAiJSkcTHCYgI2aOxFxWw==
X-CSE-MsgGUID: 5PLZvvNHT4WnjTeFP13dgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="67338221"
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="67338221"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:15:58 -0700
X-CSE-ConnectionGUID: 9SwxGX5yQVmMK1Iwz+iVlA==
X-CSE-MsgGUID: sKHLRjwsS9mY/8Rx36yh0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="127267230"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2025 10:15:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 1 Apr 2025 10:15:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 10:15:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 10:15:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eaM3YxqRyOc879kJBNDJTuhMVvLgvjZXihPEPr/7WL2saJCLG/bl2Fn8pqYz8rP6yrWVZTZ+OuSUpM7dZ1rzEaW5NnV9sjbtbwa/PHWztvN6pbsKZbMvpoq44YxXf04vZ3aRJn/hQ01aP2CpZJqIZ5j1EC9UApvA7ukqAOslsKn1hctrfHocS8ZVRc/yMQLyXpeBbVmVozmFUUL0jLGwcN1VqG06BTYR+rO/BaGpP46tsgNObR6Gzcf45T9E2OSnDhTvCaQBOaqFeXTL1qmglefO6kM+dE2hZRg8WgM/K+5P/1Dk0qNhIJL/vzyq+K33BuhMH6N6ALfstIBPMColXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3srarNTjCgybSX7GyH/rN7OgXvzzen2BpVKaIyoZEVo=;
 b=jEvEgmhZisk8f26ksgh28Pp6vMgPDV8OBf7iUq2xeq+j0QTacR4ZxGrl7DvgVrqkmkneAg7Ftuqh4SU5m37n11ytCadHnfjX4rqq8z3NlG7zwzFlbK6xrMt9K01PhIf7id2BK0kY+MvjTWMs4DkW7v2ZEDh1+3zsICGC8ic7XPEAVu5pYsgikaPFz37Te1DAfQTXwix1NPMSF/wUiQzS5mh3ADKYx2JP7sNaXNrEX+aBGJ7EIDJ+FPPlckNbhiH8mCHUppl7oDoUcQIiOeYYUKnk3s3DbZKT33z584FAnMR1DWcvOofWChs8X/lHdCLfHxqwX2xlKeco9ocA0mkcwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS0PR11MB7802.namprd11.prod.outlook.com (2603:10b6:8:de::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.47; Tue, 1 Apr 2025 17:15:54 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 17:15:54 +0000
Message-ID: <d472f88d-96b3-4a57-a34f-2af6da0e2cc6@intel.com>
Date: Tue, 1 Apr 2025 10:15:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/8] x86/fpu/xstate: Add CET supervisor xfeature
 support
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Mitchell Levy <levymitchell0@gmail.com>, "Samuel
 Holland" <samuel.holland@sifive.com>, Aruna Ramakrishna
	<aruna.ramakrishna@oracle.com>, Vignesh Balasubramanian <vigbalas@amd.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-4-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250318153316.1970147-4-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:a03:505::17) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS0PR11MB7802:EE_
X-MS-Office365-Filtering-Correlation-Id: 0db4b8af-096b-4887-e3d9-08dd7140dc3f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z0pRSFdTeDhHcjdlbWU2SExXZnNWOTN5a01hcHVRRngwM2lINGlsS2JEWkh6?=
 =?utf-8?B?T3BxZXpyL3gvOTNJUFJJUEpzQTZ6Mi9Ca3Y5ditKQkhFRlpaTEwwM0lqMVFz?=
 =?utf-8?B?SmRGMGRHKzErRFN3ODYvdVVJZllOaEtOcTZ1QXBVQzNiTVZZaFBWbFdQMmhC?=
 =?utf-8?B?emNQMHdUVU5xY202dEpQRmV4K055c3JMempWMDhDclkyZVNyMkg1cGR1TWVV?=
 =?utf-8?B?czl6N2ZaWXJsZ3RWMlZRcDl0NDRLaHhEeDBXNzRacFNpUzhBTjhJaW9tOXpY?=
 =?utf-8?B?QlNYSFB4cklJQzhSVWdWaUV3Sm1nTFBuYUQxOVlPOGdwUk1IKzI0aS8rWGYr?=
 =?utf-8?B?aS9lNlZpN2l6Z2R0MU1aWjA4dWtnaUVoUDNMOHViOHZpUDE4OTUrT1lKZFF0?=
 =?utf-8?B?RVV1ZTJLdk1FbnFRditVS2V4ZitzRVpsTkJCT3JIZWtyZlBkRmhTdVFuYWNm?=
 =?utf-8?B?Y2JEbzAya09EamRTQkExTTNUV3NqOWlraDQ0RHBjdGZzUkpZVDB5VnBQQVdh?=
 =?utf-8?B?TWVZUXBLWEFqbkk3MVRjaGtOaWRYc3liTHFmZ2JKNFdHVnF1YktQZFdpY0ZQ?=
 =?utf-8?B?eVNsV0g0K2JUSFplN3NXSVhKWVFPM1VXbGZPUjdzVzd5UzJSODBQQnc5bHRr?=
 =?utf-8?B?UWp3SmZFeXY5ZmpDSEhFNlUxSC9icm1yOEgzY3NibVUzdXJ5MEdrTmhhOElh?=
 =?utf-8?B?b1Vib2NBay9ZQU5WUDFKK0w1b08rczg0NmNCcW1jb2llOTRzNEJpOGV1TUZQ?=
 =?utf-8?B?RkM4T05DWlg4c2UxamhyYklmY3FoeFhJOEloSW9NcEFMZUN1WVdzVmVHUisr?=
 =?utf-8?B?VnZzV0xRbEJnNmVjQW80ZE01S0F4c2x4b1FkQW1QY0g3WVFFOHlFcWxmTnEy?=
 =?utf-8?B?aXYzRllRcjlkNHN6MFdVYm9UWDlQUENtRGtWZWpZM1BSSDZCZHY1Ly9JdTZa?=
 =?utf-8?B?bU53R1liVkE4QmtoQytsbGs4QTN6N0ZtMEw5UUJYVnZabW5HQjFxSGdWZkoz?=
 =?utf-8?B?dnZiR1BkN2pxcXRYMk9RZ1RtS3k2Y0gwdk1hRlJUYkRRYURUdVpPNWZTZnNo?=
 =?utf-8?B?RnBLbmQ0NmJVN3V1MEMwWTZKUXJ3TnVGN2IrUlp0a3Y0ZDJadVBEcXFFSXRv?=
 =?utf-8?B?eU5wbDNQSVhRZ0JUc1huYlNuZFhUN3M2cTkyMU5Ob2FzbmpOckdRL0c5TFAr?=
 =?utf-8?B?eHBocnU1ck5SL296MzBFNXVmYzh3RFVPTk5pRS8xUHhuTjQrdlR6KzhkM0F4?=
 =?utf-8?B?UzgvSVdXc0NabU5yRVMzSkxob0VVZ3IwQldCVDdjemNTMjhaeTdYK3J0SFpo?=
 =?utf-8?B?aEppQXlRWUZzUUhwZE5qVmkzRDVZaEdSYTFWcHp1WCtHQlpHSlRJVFRSTkEx?=
 =?utf-8?B?L2VSdVZwWE1sZ1Q4OWJEZ1JaUCtWVk92M29KYkNNZy96L2g1MXhRYWFKOXEz?=
 =?utf-8?B?U2d0L0NtZTBJS2dDWk9XOUhCMVIyZytzaDgzSk9ibHFDN056S1hmRzhRa0Uw?=
 =?utf-8?B?WElydHd2d1FGeCtvQUYvb2d0VUowZGd1S2hrbS83Q2UzWng2OUV1MytPU092?=
 =?utf-8?B?Ulp0VnBybTVrczJlOXF0L0xMYnpTTzdhMFNGc0RyT0tRd0J6b2s3Uld2SVBR?=
 =?utf-8?B?TC80bCtvMnU0NzNsb2ZFVVJ4MTM2QmtNbkNFYU9DQ2RDRzJTczBjclZpM3B5?=
 =?utf-8?B?K2UyeWQ0VktZTlRldEMrblF3YmN5a0xPV0ZFUkd2cW9HbHJyU3BBZHVlNHMz?=
 =?utf-8?B?STlMbFZDL3gvTTZVYStpWEpPTmlOZmtoTk1Jd3ZqQUdJODI0RVJSUDNmV0E2?=
 =?utf-8?B?YjF0UDVMU2xmQjZHaFNKT3JFanNLZTlycCs3WE5LR1Nma2svdjZXNzFaWmJW?=
 =?utf-8?Q?swbNFt19oh9Tx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkpsZTdtamc4ZjkzcUtZNjlRaWRvcWtmWGR4QW4vS1IyVFpBRXAxblozL3do?=
 =?utf-8?B?UUlvNDA4NUlzaFdKb3JVUzJXUDgvek8vN1Jtb2pqN25FM1U3QXM5Z05oald2?=
 =?utf-8?B?VnUyV3VUUGZjSUt4NHRmVzBZY2lIQ1RkNU4wbTFXWkhhU2dHQlhPc1VGSWNO?=
 =?utf-8?B?b3c0TE1kZTFvSEdFbnhJRWZNdTJBNmhmUnNEcGE2MGt0ejFBdFJXMVJQaHdp?=
 =?utf-8?B?aU9lNEs0VU5XdVJHa0JLUWxhVjcwSXcxOVpPZHdwbk1WdzV1VUk2S0hoZ3lK?=
 =?utf-8?B?eGZabWt0elIrWmlDVE9WeHYxRW5zUzZDWVp6WUdsWXNFUlEzazhrR0krd2U2?=
 =?utf-8?B?TUVBb1B0UU1jT3krSm13a2MxR1NONE1ZYUI5RHpmUWg4RmNCT0owQWxTU2RG?=
 =?utf-8?B?Q0RGbGdaMFFJckxQenlrOUV3dzJPVjhqa1RQUS8yRk9NQjBvandpdmF2d3dN?=
 =?utf-8?B?VDE0WHYyUk5jeGdXdGl3WDY0Vk1vT3lQeVJKTW5KSGp5R3Z6UFdiYUtsKzUy?=
 =?utf-8?B?c3BYV1V2eFlmVGIwS2tkd01hdnIzVEJlc0hlTVBUeFZqbVVmbzJZZ0JUSTA1?=
 =?utf-8?B?QmFlY1dndEhpVGh2RGtQNjRyNUJBbG5pN0N3SGVJclVXQTUwd0wrSjVSOFFY?=
 =?utf-8?B?RHJCMENFRTZGSzQrZDhtTGhBM2hyS2JsUDhmS2JUbHVHSVg1VTRIQ3B1WEpu?=
 =?utf-8?B?UjVQQjRoTW9zK2FqWWVJd1NLODEwdzA0ZW5OWmF4WGFSKzRQajFZVVhlekw1?=
 =?utf-8?B?c3o1UUZlNTJBblZYS01ZYXk4cTlmTjlrVUlxOG52cGVxNjFnS3dPaStRdnk0?=
 =?utf-8?B?SXJLaVhwV1BrWFg5aEZ6bUxIT29NUzRCWlNNUlpLNENGQ1dxekFTaS9kT25x?=
 =?utf-8?B?VktzVEtJditHU1lZSUZrcUcxMENNMS9DcWU3MTNVRmt6K1g1OHk2RENzR1NU?=
 =?utf-8?B?bnlGcDl4cFVvbEdqandldUIxRUx1WVd0VkVaWHdObU5oSGRWODZOWjFPQnNw?=
 =?utf-8?B?SnhwUys2NkZHMWVKb0NzU0lvSnB5eEVmSHppYXU4YW1UT2JpZFVUVnNFMERq?=
 =?utf-8?B?aEpENHBWTzJmM0VtQjFUWkJxWFVQNnBMS0swT3hmcTB0NDJabHJFUjJSR2w1?=
 =?utf-8?B?eW8zclc0WmxQS3E5UTE5Z0dNcVRsWlovaFkvT2JZN0hkWEpDTG5EbTRYUmt2?=
 =?utf-8?B?elRodjcxbHdVOXJjc3ErMHB2ekhHK1NsbHU2dEZ2MVVaUVhGckpSUm54bUZQ?=
 =?utf-8?B?ZExpWmdWenkyRjA0WHA2SlR1Z3VvU09wSjcvcGhvRGxBWSt0ZXMrdWNiRWgv?=
 =?utf-8?B?UlpEa1RQUUppcGlWR0FMTDRJZENzSFBndG9oNUp6dk9qRGNjakp4czhXUzAz?=
 =?utf-8?B?cStqKzVaOUNVKzhOVkk3WHE4ZjJxM3FybzE2bEFZdElnaHh2VTd3c2czTnFJ?=
 =?utf-8?B?RzZvRkdkaGpZZE5oUVFwYkxZZUs1R0tJeDU5YVVqQlJYd1paNUpXUWJpLzNj?=
 =?utf-8?B?bGxhWm9EQmxVNjRFeHBGeFdJOFBLSDVrelptWGgrTUhoVFdJOWZVZDlVK3U1?=
 =?utf-8?B?NTVFSnJTdHhheFNMa2UyYWdsZlBhaFFCbnV5VmpDbU56Yk1VYTZaeHN5MXor?=
 =?utf-8?B?V3ZOL1JoM1Y4QUwxaVUvK01LSDRyLzhmd3hmRUZTZU5EeEs1T1QwMGJxazZK?=
 =?utf-8?B?REpoVmxmNWFlbStOckZFZE5tRWxhMXpBNERrWmg3RVFieUJPSUxJdysvdGkr?=
 =?utf-8?B?ZEFQNmV6TVZMQkhBR3dHWE5KdURkb1E3NzMxSHplb29kTGJWRU82ZTNWekMx?=
 =?utf-8?B?WjFodFpHdlhXTHZWMFlqam5UdGZhRktPTnV4MnhqVTZSMzRhNXA1V1dkZXR1?=
 =?utf-8?B?NEtZdDh3M3hpODlFUkVENjc2eXVmR2RYTERHQW9LQmVBanhZZS9lOTBZM2RG?=
 =?utf-8?B?SGNtRGl0anRXNUJ0SzBpZ21ydWRrSkV6eVRoQWtDVnRpQUNXaEsvQ1Zmb0Jt?=
 =?utf-8?B?NHhlaTg1Z2ZUcEtoTUIwUDBtVGt3WGhudXZGY2FReEpFcnBCNDY2ZGhReU5L?=
 =?utf-8?B?cUhpOUw1ZjNQeTNRUnZXSVQwNFpBc094azl5WEdFTDg0dFgwcVFkK21iRys4?=
 =?utf-8?B?U2F5bzNveFJwcWQwN1RUWWEyRmtwVFR1WmNZdjRTTlQyMk5xY1JwbEZoNzl3?=
 =?utf-8?B?Qmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db4b8af-096b-4887-e3d9-08dd7140dc3f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 17:15:54.5583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 86Tus/bkb7Nc9obiALbR5tr6anSFtqj1kj5Huw+7rYiAGiULAAlTRXBubajj+uWNnp+ofTG0oVVVlbNXgrjA/3R+yb4SkECOFPLYl2VIFtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7802
X-OriginatorOrg: intel.com

On 3/18/2025 8:31 AM, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> To support CET virtualization, KVM needs the kernel to save and restore
> the CET supervisor xstate in guest FPUs when switching between guest and
> host FPUs.
> 
> Add CET supervisor xstate support in preparation for the upcoming CET
> virtualization in KVM.
> 
> Currently, host FPUs do not utilize the CET supervisor xstate. Enabling
> this state for host FPUs would lead to a 24-byte waste in the XSAVE buffer
> on CET-capable parts.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Placing this patch immediately after a few mainline fixes looks to 
suggest that supervisor CET state can be enabled as-is, implying that 
the follow-up patches are merely optional optimizations.

In V2, Dave provided feedback [1] when you placed this patch second out 
of six:

  > This series is starting to look backward to me.
  >
  > The normal way you do these things is that you introduce new
  > abstractions and refactor the code. Then you go adding features.
  >
  > For instance, this series should spend a few patches introducing
  > 'fpu_guest_cfg' and using it before ever introducing the concept of a
  > dynamic xfeature.

In V3, you moved this patch further back to position 8 out of 10. Now, 
in this version, you've placed it at position 3 out of 8.

This raises the question of whether you've fully internalized his advice.

If your intent is to save kernel memory, the xstate infrastructure 
should first be properly adjusted. Specifically:

   1. Initialize the VCPU’s default xfeature set and its XSAVE buffer
      size.

   2. Reference them in the two sites:

     (a) for fpu->guest_perm

     (b) at VCPU allocation time.

   3. Introduce a new feature set (you named "guest supervisor state") as
      a placeholder and integrate it into initialization, along with the
      XSAVE sanity check.

With these adjustments in place, you may consider enabling a new 
xfeature, defining it as a guest-supervisor state simply.

Thanks,
Chang

[1] 
https://lore.kernel.org/kvm/d6127d2e-ea95-4e52-b3db-b39203bad935@intel.com/

