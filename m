Return-Path: <kvm+bounces-34627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B88A9A03034
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:10:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DBCD3A5018
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 19:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7B11DF74B;
	Mon,  6 Jan 2025 19:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yff6gw39"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72A11DF724;
	Mon,  6 Jan 2025 19:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736190634; cv=fail; b=LJu0rtXHe11MaCDKuRIWUit4rzDsJ3ybAtyPtXGRQSlsZH/86+Vdct1SIuJB0EB9MBJ/YqCYrGVCzKm6K8UhvKuK4nTR5/bE//5IcPyjTFCC/Zs4g/bgyvLK2/nmOSi4LYf75k0JKzUb8/6Uya0XuKnAxIirdD3rs5HbJ8jXL84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736190634; c=relaxed/simple;
	bh=bDiv1QLXia7i8d/9baQ7OLelrpVQZpsJ2eTkKMOZuc8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Onxsg8I8BXqBBXCxfDSGUyP07xQYyYCZ8n1ZxfrqEsZPfJeZ3jW1FgXqEyI06oPPqreNV17WEEegiiTHBz3NniaL9MGuo8HQGGBbKw1aZBRX30XAoQTXvFFZfztqxhJZ9Ur2Zy+/GHudepooUu8n/6LtSASQXFss1PMa6nJTymQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yff6gw39; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736190633; x=1767726633;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bDiv1QLXia7i8d/9baQ7OLelrpVQZpsJ2eTkKMOZuc8=;
  b=Yff6gw39jp2xfHRjCTQovvcNYmfB2wCY3E0NzQ+5tYk7acqfkuMASIPD
   3c9lEIKW6UkytMT9D0KXvkh95iTURGngAgw9tkMMfTfNA71pz9HeiOgUP
   KTH3inMndSMUpGgsuq1uexbqMhAdsrfRGEjDh5fyhIgNIaRQI9iog/N7m
   ARRytLnNSLRwUEneOco3/cz7XZQpOH1x3KplU8Smua4jH0An/Pe+qjztP
   OzHxedDkhJiKMf1hCUDwO9hMXyx/i+OAW7ApnE0/0aVtDMq9pYlzJ+bTg
   RQA9RgkINytnpsini+t6bN5ZyVA1xtIN0LbR4kVhOXGNl8chDxDhUoAPF
   w==;
X-CSE-ConnectionGUID: IIhKTXNnTg+pExj4k6gSxg==
X-CSE-MsgGUID: QEou80NLQo+xOLbDBwFKew==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36513814"
X-IronPort-AV: E=Sophos;i="6.12,293,1728975600"; 
   d="scan'208";a="36513814"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 11:10:10 -0800
X-CSE-ConnectionGUID: ntd6F8HJSVm6UKucLKsgIA==
X-CSE-MsgGUID: Pd3Vl80USPuCEkagfHsZVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,293,1728975600"; 
   d="scan'208";a="102414672"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 11:10:09 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 11:10:01 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 11:10:01 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 11:09:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ofQPx4VfdS6witt9wKhB431UZCwIExhgp0a4/ytLdXophxSzjBMvTJp3MU9Y0/e3mlpbnOoyI1Ogd3ad6Dgs1uZVWmU8+yd8z8C5GiD24JfjSOVO9Z0DkXPwqvnTrabOQk353UXopVQa+Dq/M6vr9sRxesmK8bjeHDy8CCAh8EFyJROTeBYRN3tfGi/imez62LbAfxqhchBymK9wUHIPmEOxCzXoEVBSwP2AYMAPw9snDgmg/HBqu/M0nmuog9c37IYlK/MQTepzHsmY7McV6/RY+FtHdk5ihyI1auYz0a9Vji+E8cPG8QUrq7PE0yFy3yJX0smxIn759538Iwb4dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bDiv1QLXia7i8d/9baQ7OLelrpVQZpsJ2eTkKMOZuc8=;
 b=CdXHo9/oC0jp0H/3y4ljTeL9mCRMy7PkMJrJbyjIP7L6j9XQhIvVP6O6qB5Q2IQZV2YRu05Y38mnHvBw5EvOVFgCznFLoXdEN8FZPmBIHLskO9ZAG2LZX4w2zMm1q8H00yeR3bAMOXnNHQnXzftxmaJs/4IAAuuufH+0kWLaYaHXNDGtLfNWAcBU5TPBdC1Jzb+flm9NxySqeZ6Zs4XqgIMZ2K/kkeMesst9GUkZdiVfTlcKZw+RzdFfEcYcfbmK2EF/9XzmK5RoAgEU1yPFhCT7Xsds+aScYLjIBrpxWT5qFmdPXSbSp3u5STr7g8Yl8djRLTaF8BqDLFR79aLYTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7334.namprd11.prod.outlook.com (2603:10b6:8:11d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Mon, 6 Jan
 2025 19:09:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 19:09:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Huang,
 Kai" <kai.huang@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 18/25] KVM: TDX: Support per-VM KVM_CAP_MAX_VCPUS
 extension check
Thread-Topic: [PATCH v2 18/25] KVM: TDX: Support per-VM KVM_CAP_MAX_VCPUS
 extension check
Thread-Index: AQHbKv4sedD7zMKo7UqVE/Sbhj6pmrMJJ/IAgAFfEwA=
Date: Mon, 6 Jan 2025 19:09:27 +0000
Message-ID: <c63d85118848faa3b741a11d9925333fafd4ea70.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-19-rick.p.edgecombe@intel.com>
	 <08a02ded469a50cc6d0ae3998d9f3e2ba643c7ed.camel@intel.com>
In-Reply-To: <08a02ded469a50cc6d0ae3998d9f3e2ba643c7ed.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7334:EE_
x-ms-office365-filtering-correlation-id: 8eb49296-c21a-4836-5d36-08dd2e85a442
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RVJBTmhVQzVleStIODJuK2dwd0VpaGdMRjF0bnAyNjdlUENYUDBZL0YwWkpL?=
 =?utf-8?B?Mm9qS0d0N25ieHhzbEtiRDRlaEVKa0pGWGJGUnZjQ05wUTY0dDF3dGI5ektu?=
 =?utf-8?B?eWpBQm1CTFJUdTRxWERLbXFOb3dWMGt1YTFjeXROdlQxVG1HNnZTWnNtOWpE?=
 =?utf-8?B?WHA3a0ZoTlF5cFVLSWhUSFpmbDR1VVUrRlR4T29WbUpjUC9HQWtzT1BVTVF6?=
 =?utf-8?B?VGlqbWtveW9za0RXRmVqUFRGdWJoUFlLK0V5WFJSclRISE43eW8wVFlWNXF2?=
 =?utf-8?B?bkVCUDJnRGtaenI5RnhkT1UzVVNxYkV1S1JqRFVmRURLNG9mYlowSEpTa3lZ?=
 =?utf-8?B?ajRqbGpSZnBOc242bmRnNnhhVUdmNTNIeFlZb0Nwd0kwbGd1c2VuQnV6Y3B6?=
 =?utf-8?B?VDZYeTdJelJCaVNqWFd4SWhoQVVtaFNZZ1J2bG5ZSGQxNHQzampiWTRUaUpH?=
 =?utf-8?B?QkNzNW5QOHphcEtmSlBVR2FoWCt3eUkxd2RETm91akZLS1JjSUxGbUd2bFZk?=
 =?utf-8?B?bGhRbVBxZThwTlhCeGJ2c3NRaXFzalVqNXhFSmt2b2R2V21LTEMrZHZ2a0dy?=
 =?utf-8?B?d1JYZUtPUDR2VkVzLzdWWnE0ZFdLQ29ONjVVbnVTTTVwdm9uZGh0T21GdnNK?=
 =?utf-8?B?QjJoTDZpT3NLaW9ieS9RY1AyMEZPcVZYMTZzQ0k5cW5IRVNrZmhPeno0Nzgz?=
 =?utf-8?B?VmlEd2x4ODRNbmNhY1B2b1hQekJDS0FBTlJVcklhczh3dUhSUnV5MGNPTXRx?=
 =?utf-8?B?NlRyaTd0RkdrRXR1cVNQN1NZamhrSUN1V0Q0UGhYWkVYbk8xa3J1cFpnOXNi?=
 =?utf-8?B?UGw0K1BaV3lxckJwVkExeTVvU2Z2S0hqNXQ3N0hUN3VxRzVOSGFabUlvZU5D?=
 =?utf-8?B?ODM4dTA0SzdVUzZWb2VPQUZCSzVwS1pFQ0xGMjJGSzcrMGMzOVZDQ2RuZFV3?=
 =?utf-8?B?M3RBQzNMUmpodTdGY2sxVGlvQ3Z1ZnVKRVJZQW5HdzljR2JqdUlWWkJnWVlE?=
 =?utf-8?B?Vyt0SkQ0eWJ5NFgrc3hFRW9CdlVnNURmdVhxSmlRUGpxbkNySFVEcFIrZmtk?=
 =?utf-8?B?OG0wTlR4ODRRT25sOHdzUUZEV2dob2Y4MlZJdGlKdFZ0Mk1lZmJkcXdYQjQ2?=
 =?utf-8?B?QkEvM21KbTNRTUtaSTMwSVFoQTNFNG8rU0llZW84RDNQREtwU0grSGxIM28w?=
 =?utf-8?B?SERLTXM2dW9iNVZpQkJUZ21YN2Fmc0g4a2lNbTNCMzJaMWxSRnJONVJJQnhP?=
 =?utf-8?B?MzhXSWJCYUYrWFJGa0pKTnlCSUdEMCtaSFV1ZTVYclFxdFVid0tZNVJCbWZW?=
 =?utf-8?B?R2lrS3FYNmdJMXdkRWJvRm14OCtSQ0hlQzdhN0l1OFhoYzdVR2RTMmxjUHR2?=
 =?utf-8?B?VWlOR21CbTBMUm0vTWVWZE9tak85WGlaL0hWandEaVc5SndOYm9ZMXp3d210?=
 =?utf-8?B?bTJJM0p0TS9yV1g0NEpCTXo0UHdRSEZRVjhqU1dLYm5zZ0wvbkR1T2xWQjlC?=
 =?utf-8?B?WVkxM0J6NHczU3doQmpKcGt6TFBhUWFmSkUrbDNxMElaNWR4MXdmd0x6QWFN?=
 =?utf-8?B?YzJ2UDlKYkRVaWtxMXU2bXNocVBmSk9Dd01EYjRuZFdpeFN2bm5oN3hYWHRD?=
 =?utf-8?B?QUwwQkd6Rm1LRmlrTTBOZ3NUS3NqdWdFYlVJNUhXM25yU3VXa3VqRDlycVRL?=
 =?utf-8?B?dVhYV3drOGY0M0E1MnhIWGZwTHF2N21LWjhtVEtrK1cwSFhlcmF0MDBidDhv?=
 =?utf-8?B?N2pXRytyVWNHUTJZU2QrWS9DbXVEaGVTTmdNYnVhWXhqY0piSWMwbkpPNjFO?=
 =?utf-8?B?cUMvS3IvRXV4Skt0R3NKYnF3a1N2dlJ2V0xHTHpKWmhQTENPQzhtSDhwTnRq?=
 =?utf-8?B?N0lSQUlab0ZwWnoyWmZMS3ZvYkJkRG5FbHA3eVVROFZ6V0Uxcmd1OFFhNTJq?=
 =?utf-8?Q?FRJDhaGU97UdIM0CwuDWZyNO2xs5dJc8?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3cwekNPaytZWTVVNjZPaDdPWDNmZ1I3eXRFa1dRQi9DcHRBOEkrRU5ISS8w?=
 =?utf-8?B?SEZ0NlRRUHBSMjFiZHI0QnNBMlV6aVROZFBxTVhVMU9aT08wSGY5MW5FR1l3?=
 =?utf-8?B?MWtTZ3FCR1B2VStyVkV3aHphUUJLTFhkMjFyckl4ZU5vL3ZPdFI5Z0JNZlBV?=
 =?utf-8?B?NEJUUDRNeTVpY3BNNnpGRWdlNnRrWXJFMDBxUHVhTXlpQkQvSWtIZzVVVHIy?=
 =?utf-8?B?WWxCdkExY2JKeDhhM0JFV0RDcDJuVmhUMmxMNzNMK1MrbnFPRGp6ZWhzd1FX?=
 =?utf-8?B?NmlzNHI3RWlGZVBtOEN0aElsYndvRUQvWWl4cUVwNHhqZldzM3kva045SHJQ?=
 =?utf-8?B?N2NKL0M4QzJQdlJIMWNkb3o2V0oyZmU3MW5hV3VpZkU4TlZGTFBLL1d4aVFD?=
 =?utf-8?B?Zk1iRStEeUVzOW9MVStaekJhNC9Ma21nV3BoOGdOTEJoVVlaNWhoK0FJREY4?=
 =?utf-8?B?TmRMR3pFL2hIeWIrM3Vzb2dEWWY3SEI0d1poNDl1WmZMbS9sTlp0d1A0WTU1?=
 =?utf-8?B?REVSZCtpYUlBV1hjUjhMZzNVRFBxY0M3SjkremI2OFhUUVRPRVNQN3YyVldW?=
 =?utf-8?B?dnZDSlc4c21USzM3aC85U1VLeGpyVjY1QmU2QVlmb2N0cnptazJkT1NNUGRv?=
 =?utf-8?B?NWpVREJ6TVgyUklUeVAwZXBNdllDTGJJK2lDaXFPcUpTKzVadkh6L1R6a1Rj?=
 =?utf-8?B?Z25nWDhzWldGejI3dFRzdThLOTI0aDM3Y0pCeng0MWcrdTEwa3FUN1YrQmpT?=
 =?utf-8?B?YnJOSllnL3dGdXBIOGNkRlBNdFkrT3J1K3VqRkxnUjE1VytWR1llS3lrUGZM?=
 =?utf-8?B?ZUJ2TWszNkNvaVlKNVh0Z0VxUEVCaUZwOWw4bkxWbjdVNU9JdUYwQ2tCZDBW?=
 =?utf-8?B?SWc1MGdzYVBnZTJaYkN6TVYrMFJUK0M4UEtlczdxcGJrUlJ6dGJHYzFMc2c3?=
 =?utf-8?B?NDZOYlZxR3JKcHFjQlplTDRuTXBQWWYrQ2R2T0FlQy9yU2svbGhNVHg3RzBN?=
 =?utf-8?B?cnNCMCtqdi95b1hKQVNHTkVZNHY2bWlMRktlV1RidTJialhveGFZeTdEbUxz?=
 =?utf-8?B?OE5STmF4Qlp1RllITytNODJydTh3QWZieC9MTHYvTVlqWnFDenlpRjl4ZUk3?=
 =?utf-8?B?RlZOUnZZbkJKQUZXMkY0eUNTVndZK2N6YVNPVTJiK0s2UFdiNm51dE4yaUJs?=
 =?utf-8?B?QUw0eXVvU3NsMkxRN2d2ZDVQbTB6S0czZERKU1FwUUdWbmtrZzdscXhFNGk5?=
 =?utf-8?B?ZEtmQ2RxZFgzUzc3VDR5ZGwvQ25lQTdBWCswRGlVR3JOY0lUMWhCMW1XWG1h?=
 =?utf-8?B?Qks0L2ZBbDlZY3NzeHBWUGRlMGNvaWFwRXZKUDZ3czhwbm9SYUF2bW1SZTlH?=
 =?utf-8?B?bVJTYmYwemJWOG1TSUdkVnZVNFBYRnNJSnIwUVNkSVFPNmJrT0l1dE5VY0Vm?=
 =?utf-8?B?c3NkM1d6WUUzQ1pFUGdQMGdwczRxa1piNmJTcTNJOXhBbVJnV2djemd0MUdR?=
 =?utf-8?B?Ym41OVdlMmdteHFqOVFzTmhxbTZRUXhjenZYRmYzTkkxT2toQmRaVVJaMW44?=
 =?utf-8?B?Zkd2VGUyK2EyYit4TXY3WGFBNWlCangrVzVxTWxicVc0azVhLzUxbkcvZmEx?=
 =?utf-8?B?Y3dwY0MrSUNnWWZDUmxOSGxYTTkwY1hxM1RRVHJ4K2cvSjJFODNzUXFwbVBS?=
 =?utf-8?B?YWltWjFjSlZVMWlQaVUrMEcxNXY5d0VlcEdhNHNYamVpRUlGSmhyNHRPbmg1?=
 =?utf-8?B?bjliUzQwQU4rZ0lwSXhmRzRrVGM1WnZOTG5kM3c2bGY0MG8xOEUvNFBIY01I?=
 =?utf-8?B?NjY2NXNMU2VZREY3K0R5MUlzeVdnNUMrTUlNK1NvWGE1UFEzNlRacDRMRitz?=
 =?utf-8?B?NmR3MXJYRXVVNkNuS0ZxSmU3aHpScjRCUzNQWDN2ZUMvVmRkSmRQdDBCZ1li?=
 =?utf-8?B?d2p4bjFZNUJrSWg5NHlPZkNMRmNWYUZBcEpaOUFFa2x0UFN2cnNlMlRoTE1U?=
 =?utf-8?B?YzB3UVBaTlZLdVVIdlB1WDBUZGlTRzFMOWtXdTYrNkhHT0dma1ltaGFXTHFi?=
 =?utf-8?B?T3pSdFVaUVN5bXd5M05CUXI4RmNNQ0ROTEpPdE9TeG8zajRhZm1pOFpWU1RS?=
 =?utf-8?B?ZVc4K0c1YlNyWC9qRWFWK2hoSjY5U25GbE1BdjlNbmRrbWR6TkRhR2NMZ0JC?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DACAFCC65604349BAB8734F4C8A1A73@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb49296-c21a-4836-5d36-08dd2e85a442
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2025 19:09:27.7457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OFpJsWdwLPF4ttKqFNkZjdkY7SXWCRe4ivr+FpCDif2ePv7VQIvErjItUJgpRLUWZFjm0HoKWlsaJGXAxURC0/6CTCZpvr1Q4k1Gd42WZSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7334
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI1LTAxLTA1IGF0IDIyOjEyICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBJ
IHRoaW5rIHdlIHNob3VsZCBkZWxldGUgdGhpcyBzZW50ZW5jZSBpbiB0aGUgbmV3IHZlcnNpb24g
b2YgdGhpcyBwYXRjaCBzaW5jZQ0KPiB0aGlzIHNlbnRlbmNlIGlzIG5vdyBvYnNvbGV0ZSB3aGlj
aCB0aGUgbmV3IHBhdGNoIHRvIHJlYWQgZXNzZW50aWFsIG1ldGFkYXRhIGZvcg0KPiBLVk0uDQo+
IA0KPiBUaGlzIHNlbnRlbmNlIHdhcyBuZWVkZWQgc2luY2Ugb3JpZ2luYWxseSB3ZSBoYWQgY29k
ZSB0byBkbyAocHNldWRvKToNCj4gDQo+IMKgIGlmIChyZWFkX3N5c19tZXRhZGF0YV9maWVsZChN
QVhfVkNQVVNfUEVSX1RELCAmdGRfY29uZi0+bWF4X3ZjcHVzX3Blcl90ZCkpDQo+IMKgwqDCoMKg
wqAgdGRfY29uZi0+bWF4X3ZjcHVzX3Blcl90ZCA9IFUxNl9NQVg7DQo+IA0KPiBOb3cgdGhlIGFi
b3ZlIGNvZGUgaXMgcmVtb3ZlZCBpbiB0aGUgcGF0Y2ggd2hpY2ggcmVhZHMgZXNzZW50aWFsIG1l
dGFkYXRhIGZvcg0KPiBLVk0sIGFuZCByZWFkaW5nIGZhaWx1cmUgb2YgdGhpcyBtZXRhZGF0YSB3
aWxsIGJlIGZhdGFsIGp1c3QgbGlrZSByZWFkaW5nDQo+IG90aGVycy4NCj4gDQo+IEl0IHdhcyBy
ZW1vdmVkIGJlY2F1c2Ugd2hlbiBJIHdhcyB0cnlpbmcgdG8gYXZvaWQgc3BlY2lhbCBoYW5kbGlu
ZyBpbiB0aGUgdGhlDQo+IHB5dGhvbiBzY3JpcHQgd2hlbiBnZW5lcmF0aW5nIHRoZSBtZXRhZGF0
YSByZWFkaW5nIGNvZGUsIEkgZm91bmQgdGhlIE5PX0JSUF9NT0QNCj4gZmVhdHVyZSB3YXMgaW50
cm9kdWNlZCB0byB0aGUgbW9kdWxlIHdheSBhZnRlciB0aGUgTUFYX1ZDUFVTX1BFUl9URCBtZXRh
ZGF0YSB3YXMNCj4gYWRkZWQsIHRoZXJlZm9yZSBwcmFjdGljYWxseSB0aGlzIGZpZWxkIHdpbGwg
YWx3YXlzIGJlIHByZXNlbnQgZm9yIHRoZSBtb2R1bGVzDQo+IHRoYXQgTGludXggc3VwcG9ydC4N
Cj4gDQo+IFBsZWFzZSBsZXQgbWUga25vdyBpZiB5b3UgaGF2ZSBkaWZmZXJlbnQgb3Bpbmlvbiwg
aS5lLiwgd2Ugc2hvdWxkIHN0aWxsIGRvIHRoZQ0KPiBvbGQgd2F5IGluIHRoZSBwYXRjaCB3aGlj
aCByZWFkcyBlc3NlbnRpYWwgbWV0YWRhdGEgZm9yIEtWTT8NCg0KTWFrZXMgc2Vuc2UgdG8gbWUu
DQo=

