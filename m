Return-Path: <kvm+bounces-56188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0929CB3ACA8
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB4113B4CE1
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8D2299927;
	Thu, 28 Aug 2025 21:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="biRpR1Qp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8BE270EBC;
	Thu, 28 Aug 2025 21:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756415975; cv=fail; b=rI7lkLnAWekMCYiOeXiMvHL0GhWXhw1cJ+qLr/k1XW5qFKv/5yIRC7ve+htzY56iKoie61CiUzOSx0l9hU3UVKlmSC1Ruv9bmnq0/Mo8za5EzrdiBiZSYHeAdi3l1/sina2Iu6m0Ihs3p4YuHjGfg4Umy4SU+mbue80cwD3PoRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756415975; c=relaxed/simple;
	bh=q//f6LY+K/0HXSBhI9V/xUU0bkdp76HNmKtJPANnfAM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gXhYeWsnXLnW94UAg7U9hYZaNH1o4SUT2OodYVvhbOibr7FiQVizDQVZXSKQkxJLeV3kCUBBMwc71+2Nlyy46gCGs5ybGkWYL3EhAHAxcF9iSM9+M+fjpYbfeCE9feRWuX+MCD//lQadmtYp/KNMwyTHuavH45jBAtp3XEI7ahY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=biRpR1Qp; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756415974; x=1787951974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=q//f6LY+K/0HXSBhI9V/xUU0bkdp76HNmKtJPANnfAM=;
  b=biRpR1QpDchyJM1vBVKo4DDApLUw6Wy4L+dEyLJ7hiS5Mp3M6NvDffZZ
   zVBXCy/NObyvNTg10ydpJ1OXn3Nv3MUTfmG71z//HplaiVp8qmOxn7nRY
   uyK3g3Z1624dPAhN5GfW0V8eQ4ILhk8wb8TPtbfP3g6PgrYtGIhLnXK7f
   aDT7cYQidoI7iGPeVUO4RtbWFGHRLVnqPselEBs/GGasex7jv25UVhF41
   dEH3zQPMM7OxJkQyM6+az72PLo+ZP7WQct03qkbgGPXzUGusbEbgs+NhB
   eHNWnJqF4zW1YwTDNc67aXhS/Z8Ctb66JkMGN5PbEWPIvpyBbdi0+8wca
   A==;
X-CSE-ConnectionGUID: OzsrfHhMTxm69wuuh0FtnA==
X-CSE-MsgGUID: lZMnKHXdSOWl7cTjK4+m0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="76299059"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="76299059"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 14:19:32 -0700
X-CSE-ConnectionGUID: wa/jXKw8QvOUP0UXdd8IJg==
X-CSE-MsgGUID: RpBOedyvQQSTQPpPQPuSMQ==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 14:19:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 14:19:31 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 14:19:31 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.52) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 14:19:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sczvk2hNtq+nReaSiI6mSsBtq7eopKddAfbPv4xM6lPtwRpGqe2Dww7Jaq3d8LA5nrx/uqFfjUcaCPEatL821fAnYVh5Txgcdiu3IRSwwvN/wRgSym5OEmY9q4coppkqAHs2Q/98QUOPXN6XQsTTHkNRkF7F/0Tvz1zn9a49jcWRxBzAfkR070pVUF0rlwhaQuAjqcKLHwy1JLbzmf4nE3waGPKuIXJeEh7niifuiiCH5Uu7lepFTgGmBEMsTSZE4crizlomGs0YWaEmslqJV5C8E9Az8/uk6Qr9nuTJ1RX1HhHyFG4MsTYdO1dP3oNBKmOU55ZGY2ZcHdk9iEZgsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q//f6LY+K/0HXSBhI9V/xUU0bkdp76HNmKtJPANnfAM=;
 b=I+7SVS5+ncJ+xsbKPjVK/ftwYEANpbhDGEchwA0bYh3t42+sKGRoyYq2UAKKjRraKGXWIG8CmKnkmrIFGMAA3jq35fnYdzB1y5IOMZEcLjf4iED4LuToroZnt9HxJXZsJLBvCkiT9/VgFc/JkcjX4lm2csIg1ZpJE2VwCwvn7jTk1QOEsr0+i9UXbkiKp4NXwmaDPisXv3PxFP6k1XqI7ODq9yuD8DIUbiJ0JlUq7hQG3x9FmPKXvENvQLlzF/9OhnJforsBV3q3TCJRWhyqkclMFfiO/RkITFCy61ri9MRTcqK612iXNxYVguKaDKWR3UQpgakNSJMSrYX0DvU6aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB8222.namprd11.prod.outlook.com (2603:10b6:208:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 21:19:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 21:19:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Thread-Topic: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Thread-Index: AQHcFuZaACFmy6w2NkqjEK4wxyWKhLR3VG6AgAEfpoCAAA6JAIAADRoAgAAFVAA=
Date: Thu, 28 Aug 2025 21:19:24 +0000
Message-ID: <48743e1790220072c72d45af8d3582cdd25f4083.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-7-seanjc@google.com>
	 <11edfb8db22a48d2fe1c7a871f50fc07b77494d8.camel@intel.com>
	 <aLCsM6DShlGDxPOd@google.com>
	 <9e55a0e767317d20fc45575c4ed6dafa863e1ca0.camel@intel.com>
	 <aLDDYo-b5ES-KBWW@google.com>
In-Reply-To: <aLDDYo-b5ES-KBWW@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB8222:EE_
x-ms-office365-filtering-correlation-id: cda64dfc-4c4c-47aa-b577-08dde6789002
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b0o3a2VJak5FcTJGdVVwZ09ZQXNBcTliWExVTUpDeCtOSUtlZld1ZDQwdVlt?=
 =?utf-8?B?aGw0VjJ4VE5ic0g3am5QUkF2bzBMRjhKR04zYjlQOE15N3E2UXN5ZjRMc2FQ?=
 =?utf-8?B?K0JjMkJpMTUycGpGWkUwdWV1U0I4T3RGVUVYSkRVMkFCYUczNUNEZ2Y2N29V?=
 =?utf-8?B?L01xTU8zSzVZWEhzNUNGWm1jMXRRZXo4bUdsRlc1T3BPODY5UXA5VXZsOTBQ?=
 =?utf-8?B?d1FYU05uSFBFSUdvUVNEMWJPWiszclBnN21vQjQ5c3BxaTBvNFN0ZTluM0cx?=
 =?utf-8?B?c0Z2eEorVTU5TklLVnViSFZzQVdIVEZwZ0VQTWlxUnkySzFMaG5MNzN3VGZn?=
 =?utf-8?B?aWFwQlV5YUEvZi9iTUh1NEcxMFhHRWhhS0k1NzhKWVVkclpqRWZoQ0J3R2Ro?=
 =?utf-8?B?Q0puRjNLM05FWitWcEJxUU9Hd0cyWmIrbEdOK2htV1cvTWhBd1RCb3hzbG4r?=
 =?utf-8?B?blZLUFNEcmFMUWdSU2ZiQ0VXdVFCSktaY1RVTmIwaFBheHNDd3NLK0tFTXFH?=
 =?utf-8?B?a2EvOUlHdUVOaTVKMUZRdk13ZE5IRC9qQThmRU85dE1tQmJXN0ZVeHo4ZVoy?=
 =?utf-8?B?VmdsQkZBZHBta3FTQ3l3SGFWU1JLeUdmYUhNY3lJVFIzTEhzbXFLSlY4cStl?=
 =?utf-8?B?T3JLdVB5ZXpGT0ZkdWlsVkRrNWUzK0l6NE1pcGpRVFZtbVZ5azZPMFlEdkdn?=
 =?utf-8?B?Vy9iTHZaZGYyWUxIRmM5a1pEd2tGUktOWXJHYThRbHRxUVJ0ZUF2NVB6SUxk?=
 =?utf-8?B?WFo4d1lVV1ZZUXU3cC96RnRSSzBDZ2ZsQ21KN2tqVW5Wb2dxYjNycmo2ZWht?=
 =?utf-8?B?UjRkOHkwajg4dmtjVEI4ZXJUZzVtaldpTU5RekNQdDl4cjVyV1Q4VWJ3ZlJR?=
 =?utf-8?B?S2w2b3NaVlpxb3FQQVdkWm5YckJZQ1hvREhUbExwYUFReUw2V2tubjc5ck1v?=
 =?utf-8?B?MVhEVHV4Unp6U1NwOUJKdVJtbXB1TjhmWFFxMmR4dzJXdU1md0x2K3kzbVBS?=
 =?utf-8?B?T01IU012WVZnVTZRMnJtbktzRFljUXo2SVRCdUdabHY1TUhmY2FvYjF4VGZs?=
 =?utf-8?B?R2JSVC90UFBnMXhIbnZlR2NTSGtCRkN2bVhPVDcyeWZGak5TdHVwTzZCb2px?=
 =?utf-8?B?eWROODNJeGRsSXk5Q2UwNE51V29lcy94eTBqc0NpaVdYSFZzK3pCT0hZcVQ4?=
 =?utf-8?B?b2VVd0RpTFVuckF4cVE4M2hiejh5ZGtwMDNEM2FzOVVqK3N6RnpETERHMTg3?=
 =?utf-8?B?bWZWbGdpdUt0enBndk52S2pKYmdjenNycnBHczNUd1VRSTYzS1ZucjNUeTNF?=
 =?utf-8?B?Tnl5ck1hSzZmNVg1TnYybEtSYlNBSUlaNGU0ZHBrMjFSTjR5U1liTHRvdW4y?=
 =?utf-8?B?M1RsdTFnczRJdVdLSmQra2xZbERLYXZMSEpVeTFHcC9QTitZMjhxRy82SEtZ?=
 =?utf-8?B?c21rSkUxZFovWW0yOTlQallTaE5tSVZRNlB2RWdwU0NDMktseC92dEpqSlhk?=
 =?utf-8?B?SE9wQ3pVVkNSM2ZzVGFCNHo0eXdlQjdZMHZLTkJqRGlreGU2WXVXRURTS1JJ?=
 =?utf-8?B?OWYvRjNSRWhqQUJSTUk2ZE4wVndzdHUzK3I0UGRwRm9SdHh3NXY3MlZ6RS9L?=
 =?utf-8?B?SGN1RHBOS1lmMlh0NHhESWJlZnFSNkFQMVJvUGo0c2hKdENJMEZhZzlWdlhK?=
 =?utf-8?B?Q1FqcW9VOHdlLzVRQUE4MFpkQU54S3dxRmRDV0FVZ0c2MGRjSjZJT2NhUytH?=
 =?utf-8?B?RE5qYmRUMFVpTDF2RUxMRU05dFZOdFJUUXRmY08yM2p0YnpkSXQ2VFRQYzFL?=
 =?utf-8?B?clljTTBiUnhhWElha1pYZ0pjLzY5R21ISnNlQlBDVlQwZzZROFZlZEF6cjVC?=
 =?utf-8?B?clRCS0NRdTBRMjI1SiszbUN6VGlZYzFuYnZTaUNtQ0ZJbGxyakpRZE9CbUpM?=
 =?utf-8?B?OUpZUVo2clJ3ZjBDZzV2bnlERlE0ckE1TXMrMEYwLzFSRWExVm9ROWJiNHIy?=
 =?utf-8?B?QmZBdjgvcDRnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzJ6UEQrNXRhMFFLV3ZpdG5oN25aWkxYYkxlMGJvZUhsSk5wQ1RqUFpqSkxC?=
 =?utf-8?B?NzJjSW56Zm1jNHB2ajhzcU5JRStsT0JrV01YNHJ3MHROTGVOd1V2bTM1Smc2?=
 =?utf-8?B?aktpWUN1SDF3Q3RxS08xVGduS1VFVVNGV29YVktXcXg5bVZiMVpsZlpmbFQ5?=
 =?utf-8?B?T2pnYnAyQlA4Z3BaKzJLaytrdmx0N3BBMUNONitVWjN5cmFUUXBCSUNFbm5S?=
 =?utf-8?B?WElKbWRaaEw5SnlucHFKZGhmYko4UkZ2VDhpTGFLeDVpU2NwMWlWamdXZ0ly?=
 =?utf-8?B?aVlHTFp6bHdST09sdXJaWmsweW1NWUZHcm5jenpWYXliM2Y1U1ZpVnFVYzZP?=
 =?utf-8?B?OWNXYlJpS2t4MmNHbUoyYXc3YVUyTGkzcVhMSXFqajNjMVZqSWlmOTVhbmJI?=
 =?utf-8?B?bk5HVWVHYkRodGY5VHBiWXB4QmNqQTlJM2Q1SUVQTCtHd0UzL2xIcEJxb0NI?=
 =?utf-8?B?eUZHWmxONS82TksrODJoZUU4a3JrQkZlNFgwNU8vZHZ5SDdGM0NtM0JvWVY0?=
 =?utf-8?B?WHoxSXYwQmttSVlZL2Vrc09HTk5FNTFZNGZGT3ExOHBiNzNMUTk5MkJPQk1k?=
 =?utf-8?B?VUdTWjdna3Y1K3JUR1JSMnlxeWtUMFY0MnlFSzN2NXBZOWdxYlFHTFM5bk1j?=
 =?utf-8?B?OFNza2k0aVZhbktKcTMyZXpZcTNCMmhjNDFFQkF5YkJibjVQMUlBK2JIZFRk?=
 =?utf-8?B?SFB1c1RHMHhCRmlaZzlrWEdBTlRNSXB6UGxiOEh0TUcycFdUL3hmbU9odnJ5?=
 =?utf-8?B?QnQwTm43KzF2VWh4TGx2cFNpOXNFMnZuVDBTNUZwdU1zeno5bmFOaDVVclF0?=
 =?utf-8?B?S1AzN2pnNVJiM3l6a2w3eWltK0tSMjkxNFljdzRrckVlTTl4cVN3TkQyNUxB?=
 =?utf-8?B?WksvQk8zcVcyNWJkeHYySEM1MXNvU2NpcExsSExJYzdMd1NQeWp5bGlDclNO?=
 =?utf-8?B?Q0NsVlBDOVZ4NUhoWFlRSWtTNjY0WVFNTWlHUG41R3FkTzE5SDZNR2dsYmE2?=
 =?utf-8?B?R1VXOTQvZVR2dlRWWFhnR1lkVSt1WjNIOEZNS0xnakpzc0ZDWTZMOU8vRGpk?=
 =?utf-8?B?enJIdlRoZHhXdllXTEtSNEs4US9PMVdOM2kwNkZhb3hXOU9lM3ZOWk12bHNn?=
 =?utf-8?B?MzdPalljN3pQNXc2aTVHVHM5MEZKVDdDZk1VSDVjZ2dRZXphNDNRb3d5SThT?=
 =?utf-8?B?b0U1by96ZmliOEUzU0xMdzcwK2xaOVhSZ0NLN083YmlMbjRpemR6WWFhdXdi?=
 =?utf-8?B?eWlDbHcxNmdIU0RFc1NYK3hhTGhRUGVWUm14U2gyZHZiNHEyYXovc0RIVVBO?=
 =?utf-8?B?K1EyYVI1dktEOWJkRlFzL1dwTytuYkloTFFOWnBOUkNGTmUwT1NyMURmTFZx?=
 =?utf-8?B?N0toUVMwNWxtdDNhaTFRcXdVRjFldEtqWU5sd2phMENUaytyWWdnRmRmUXN3?=
 =?utf-8?B?cUpVKy8reW5MRk5VWWlnODNIQ2Zza01HNWtOTnlITUR6YUtSWkRTcEx5NVVL?=
 =?utf-8?B?STU0MTRpZkdzL3dYcTFXU0RLRUJkOTVYbXdySUtGV1JmYkNCSlJxR2JOdWFo?=
 =?utf-8?B?M2tndWFEN2I4OFdNM3FKeHNKRml3N3pFVDlEa0Q3NDJHcEFYS1VicUp3OTdO?=
 =?utf-8?B?Vys5ekoxV3UvckNsQU94dlRJVmd2Ukc1Vy9rNE0yM1FnTDVERWRhblNpSEky?=
 =?utf-8?B?T3VGOW1KblNRN2hhTzdWcmRJdFg3MVNWYkdTUUlRc1J5QVR0K3djd0ZwUkNN?=
 =?utf-8?B?UWo3NkxnaGkwMUZSd2RJbFRhZDZmR2FoRXBRQi9LM2NBQ1BOSVRiUmR4dXhX?=
 =?utf-8?B?SkR2YllCVEp1NGo4b21YYlhDWVZYTENteUdiMHIyekxrY1U0dXY3Ry9xRVhk?=
 =?utf-8?B?cldBbnNqbUNKTW5KR09QOXIyYzd2V1MxNngrWHZKeWlPUE5RMStGL2ZwV1ZO?=
 =?utf-8?B?bWx6cHhFSnZlVUJET2FHWkdLUERTYXI0RFNCekNKeCt3dHZpWmhkRW9jY0Ro?=
 =?utf-8?B?YnU1WUJQZmhlU2ppaWtoWXhOWW85TVBGV0ZJR2VKcy9HY1ZEM0UrUjJxcVhm?=
 =?utf-8?B?b2UrRkhuM2d3NlJ6b3UxUWZlbmxRaXk4VnMvZmxWUXlpSmFLUkVnaEEycTFP?=
 =?utf-8?B?KzFmVGxYQ2dZQ1QrWlBFUnlCY1hxc2FVK3dZR29RUk9yWkdKeWlHZi9SVVlP?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40077752C022DA48ACEE9A8715301CCE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cda64dfc-4c4c-47aa-b577-08dde6789002
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 21:19:24.2888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dzh+OtuEEvaNC8RSjm3NQk3c4OURxgnEO19Qc2hancYLsP5Zs9IEbVcMfPkxGYevgkFsBY2eyMdiQH5yw4493zAjtXABkM9mWp04vUIhyxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8222
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE0OjAwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBCdXQgdGhhdCdzIG5vdCBhY3R1YWxseSB3aGF0IHRoZSBjb2RlIGRvZXMuwqAgVGhl
IGxvY2tkZXAgYXNzZXJ0IHdvbid0IHRyaXAgYmVjYXVzZQ0KPiBLVk0gbmV2ZXIgcmVtb3ZlcyBT
LUVQVCBlbnRyaWVzIHVuZGVyIHJlYWQtbG9jazoNCg0KUmlnaHQNCg0KPiANCj4gCQlpZiAoaXNf
bWlycm9yX3NwKHNwKSkgew0KPiAJCQlLVk1fQlVHX09OKHNoYXJlZCwga3ZtKTsNCj4gCQkJcmVt
b3ZlX2V4dGVybmFsX3NwdGUoa3ZtLCBnZm4sIG9sZF9zcHRlLCBsZXZlbCk7DQo+IAkJfQ0KPiAN
Cj4gTm90IGJlY2F1c2UgS1ZNIGFjdHVhbGx5IGd1YXJhbnRlZXMgLUVCVVNZIGlzIGF2b2lkZWQu
wqAgU28gdGhlIGN1cnJlbnQgY29kZSBpcw0KPiBmbGF3ZWQsIGl0IGp1c3QgZG9lc24ndCBjYXVz
ZSBwcm9ibGVtcy4NCg0KRmxhd2VkLCBhcyBpbiB0aGUgbG9ja2RlcCBzaG91bGQgYXNzZXJ0IHJl
Z2FyZGxlc3Mgb2YgRUJVU1k/IFNlZW1zIGdvb2QgdG8gbWUuDQpQcm9iYWJseSBpZiB3ZSB3YW50
ZWQgdG8gdHJ5IHRvIGNhbGwgdGR4X3NlcHRfcmVtb3ZlX3ByaXZhdGVfc3B0ZSgpIHVuZGVyIHJl
YWQNCmxvY2sgd2l0aCBzcGVjaWFsIHBsYW5zIHRvIGF2b2lkIEVCVVNZIHdlIHNob3VsZCB0aGlu
ayB0d2ljZSBhbnl3YXkuDQo=

