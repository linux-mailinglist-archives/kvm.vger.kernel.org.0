Return-Path: <kvm+bounces-65047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BC26C99633
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 23:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C014C343776
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 22:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555A8284662;
	Mon,  1 Dec 2025 22:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lGqnZM1J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA73279CF;
	Mon,  1 Dec 2025 22:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764628301; cv=fail; b=bgU0qnYDkQQTDPYkTXFGGl3KRvfkNeHp91k7LcKkQvQ3n5cid7wdNzuq1+K/EizOTNMK0jCJ4+7CibhKpEBmB58RWHB6hdGukW9h1OSIIFujALiJjfF/eAzy9hRwC6uEhB5LVZJERuCp4UO5rUp2johtifcA+l2Nyo7/f5YkDxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764628301; c=relaxed/simple;
	bh=MCYutdaJm/ckWJ7HYn7lwnONLpcstCBggJ0v/RmorHQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nIqycR5vJ1s/DOaut34duy383pLPNrGawD8CUCxB9achlFSz6reu2k4+FVzExuvhoGxAX6T5G7LiiBh+T01Tpon0Hyly6Lv6QVjAd+I7mLfJVXoyNT8BhFQnRX6tkN7hdBn0sMesYlN2F95tie/Cpp+FPDIVG/MEb+WzzCZLO8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lGqnZM1J; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764628299; x=1796164299;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MCYutdaJm/ckWJ7HYn7lwnONLpcstCBggJ0v/RmorHQ=;
  b=lGqnZM1JC+Q3M2tYOfY6nikVFnKhaR27f9Q6S9+GmdLFrX+CLOSV08P4
   Y/9CXo9EE+y7+stbDqiek4tIDCGtAVq51kBelLSIFtsdKwDtdswzXQAq5
   wCF4KF1ip2zE2oAhKI7EXaEqpqWDuL/1gAVgv81LxP15ukA2lc/AY44XF
   IvaUmd5G+L3R+M1xWU+TEfBcc+v9MCzCNCqw63s1r43mA9DamWrZWESh7
   +KTXDsXkBUPthafkUdcyqkruNOgZJ3nvUuTfEYSivXbBxoTeihvzlaQFB
   uyoRz3J3XSgT6sFxMGvYbHTz9z8UlmLGBSv2DnJLSomTY8LrUJcfflrpG
   w==;
X-CSE-ConnectionGUID: iN8NcJFtSriSYdItEmPkZQ==
X-CSE-MsgGUID: 88FSGhaATTu6JKs1z+Mr4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66618939"
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="66618939"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 14:31:39 -0800
X-CSE-ConnectionGUID: KRCeah4iRC+zfpnpmukYcA==
X-CSE-MsgGUID: yIMjkPpsTCa24z0LRGwVJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="194992284"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 14:31:38 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 14:31:37 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 14:31:37 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.9) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 14:31:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=no7r4os+nUAN63di+rSWr9NT4ippAo1Y5kfemCbIjJE5nRYt63TWK7fyaCgmBwC9vtuZRCMyxlD5+Qt8BgKg6P3mMl+TwIqL/sQlL89/SRYQEgMcuGmtFKorZKY4N6JUTO4P9aVfB4FhKD9lFBJZct402CC93DHUAeGLT+sUY46A1KRW4StROIMS3aaQKByPC4Bb1WJVtMOZZteBXtY2cAuOy8SCP24Thk8nl1cUNTvU272HJkj6/MIEvELoqhf1Hnjv0FxviZQp6/AYgHv1ujk34fsEAgTV7nmuufA6HWRY8kEDh4RIk7CyZbO09QjTvB33Tboio4/FxhpHNNPXfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCYutdaJm/ckWJ7HYn7lwnONLpcstCBggJ0v/RmorHQ=;
 b=JyUzKbF0dtmF1fk90dFUzz4akXx/yz8dcgAeJIcF+Ta5InsgTLPqOCLstM9a+JgJtoZY/YQi2KGYtnYZfgSLHm4kshA02iYafo9haKw4OaxAV0X5u1CfI+3wNiBL1EDA1t7WptHK0kMMK3Cppa3k0bH5LBLYqz0OfSBMPZy7wdEsZUUt+O6YbRkANjiZJUTdsrDM+Oi2w5khni2Je4Gu1lSFyklykXLTDwJdwYP2vs3AdMdeA3XobPsIPkv2gJ3HYk/OCxfe7oSAWH15W9t1K6INze4pXx5mK1UsJrzmRMe/9BPSHukOhIH/zPvcQv4JLA+9c8XmtoicuiKv3kD2jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA3PR11MB8075.namprd11.prod.outlook.com (2603:10b6:806:303::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 22:31:31 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 22:31:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UGfeQAgAbxkQA=
Date: Mon, 1 Dec 2025 22:31:29 +0000
Message-ID: <a7550dbfc61009ef5f6c81ea6681c38e64a265a2.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <21115e18-c68d-492d-9fd4-400452bd64c7@suse.com>
In-Reply-To: <21115e18-c68d-492d-9fd4-400452bd64c7@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA3PR11MB8075:EE_
x-ms-office365-filtering-correlation-id: 0091563a-2470-4453-e289-08de31295f8a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cTA5QmZORUZDbzdoTmVuMHZnWG9SeEg5cFNSZkMwUTRyK3VQdnQyZzZhdkt5?=
 =?utf-8?B?azZUOCtPcU5Ca1JZVnZaSWR1dkVjSDhISExlY1REU0ZQdVBPSTQwdk43WDBS?=
 =?utf-8?B?amZ5MXVVNzZqcUI2QUcvdUI5dWl4VGFKNS9UU2NUMkVUL3RBMmtkUEVuUUlP?=
 =?utf-8?B?YzVFWFpFemRKclNRZGVpRnB0YThaczJJM1dONDIvWVMvNGN5RHhBaTJkTy9i?=
 =?utf-8?B?T0NEaWwwYjhjNnlyRHBlNERDUkppa0tRdFg4ZkFDbHpNTlVCRy93aXllODMv?=
 =?utf-8?B?Um5MeGthUldEUDdVZjUyUlFldWtTNDAxL0dHTU9vNnVJRWtjUlVVNDFNYW9D?=
 =?utf-8?B?MkZsTEdLUW54L3hiU25ZcnVLUDBkbTg1RVhmSzU4MjVkSHZiaXRwUDhrS0pP?=
 =?utf-8?B?azBpWVRmTlliWjNmNkIwYlZtUThTUG1kTm5PT2tBOUN1ekF4VFlKYnEvSGZh?=
 =?utf-8?B?U0dDRlhNWWdlcmRLb2lXT1B3QlpmdTBOYWdpZTEwcW91K05BQ2VOSjV4VHBZ?=
 =?utf-8?B?QUdhak5wVDBISVJXdVhYVm4rNkc2RXFGSGhlR0JGUlpQTkpZc1RlcnYvM3hV?=
 =?utf-8?B?QUFTNU9GOS9iM2RrQ0crWWJQcGEwRE5SN2Z1b01ZMzA1U1IwQ0Q1N1JhWkNr?=
 =?utf-8?B?b0ZUZkhpR2dLd2dQMXlPbGNncS9jQkxGN0JFai9MSmsvcTNNZldqRVVyU0xz?=
 =?utf-8?B?Ym42LzBFOWJLcWNQSUp2dVJYalp0Mmx1eXdZLytkOUlTNU4zV2p4aHRxT3d1?=
 =?utf-8?B?eWd5MHozeDlpSDlQSk81TWNNVU9qQnF1TTdXUU1WTlV2bzk4bzZrQmxFcnR4?=
 =?utf-8?B?cXRPazRacTRUUTBNZmR1OHF3dHdKMkJBWVlVbG0zaWxtQVFWS3NCYUYwZ01T?=
 =?utf-8?B?UTZKR1NOYTdsSnZvVHgrMTNUUWladHBGWG5Bb1RCTytPOGRuNDBkaG53blY3?=
 =?utf-8?B?TkxkKzdxdXNrK2ttVlZodUZ1b04yY3dMaC91VU01ZmQybzM0U1JFQjN6eWZn?=
 =?utf-8?B?ZWxTWU03ZUxERDdBUm1CYkVxZ0VidVJobndSaDhOUkNEZUVacmhPRXo4d3A2?=
 =?utf-8?B?ZE1iNEZISUlaM0lxRmJpNzI1UW01N1pFN1pOQnIzTHRnUkw2YTdkSURIWFp4?=
 =?utf-8?B?dllRY0hndlQ3bjRBU1Q0T1o4VkhXRzE4RjF5RFpnYkQ2bS9VbHFSYUVHNUw3?=
 =?utf-8?B?ZUtraDgyTUIrbnN0cWdQYWlPM0lQci80WlhXTEhPa2FZWWFxNE1jL0R3ejRV?=
 =?utf-8?B?dkRPR1pWVXVVanZJanNJRzh2b3NDTjFqcXBWZWRvWloraXNDWG5qeEVPNzNM?=
 =?utf-8?B?QjZ1UHRYMDJZeWhiQ2FhUGdOUzRBNFRZbUNwRWNIbTBma3BjZm5WR3ZRRlVj?=
 =?utf-8?B?SVlNbzI2Tjg1ZzEremZCQ1FmN3FyR2pucDRjL3NKcEEzMkxSaXF6UFE0b0g4?=
 =?utf-8?B?UzhoVFpBM3JOQ082RVFpRnJrZVhYNWVkWUxrcTdhT2MveVNyeE81ZWRCc1Ru?=
 =?utf-8?B?cHRicWl3c1l3UlFrODBnQWtRU09rL0kwalBUTkhHNjYwdXRHRnYvR2w1TlFY?=
 =?utf-8?B?TTM2WnJWMTdwOWlyQW9iL09GNHBLNkg4aVBocGp5YnFpdFMvV0RoeUVmekNs?=
 =?utf-8?B?Wkp1WERWZVRKWWZxSFBNSTFLSU9rRzFraGg5a0htcE0zYndCOUczNHJ3S215?=
 =?utf-8?B?VnZYbHdnQXNWMzE0OFZ0YlhHNWhDZ3pZOU9WL092K3V4bzhlZGR1cHI0ZHN6?=
 =?utf-8?B?eG9xK2tUK1lFSm4zL2NYNzhqc0dubjJ2T0pwSzNBcnlYZVV3Rm1iU3JYeHlv?=
 =?utf-8?B?bDZ2VTZVMmJnTHJESkhmenFnMnUwRUtmMFhvdDdyZmdZSjFBc3dFQ0Fta0hE?=
 =?utf-8?B?b3ZFZWZEeFpYRzBCMzI4K3FyRERoVC9VS1J3WHJmMGlLQVd1VkJwM2IyVUk2?=
 =?utf-8?B?bUg4UmxMdXdrbVNhU29jUzlUQmNlSVBLOUdlTHZmWXlYcC9MSzdpTTBjYTh0?=
 =?utf-8?B?cDJvSkNSbUZTQTh1aHNoS2x0R3E5UzZtUk1yRWZCaHZieEhVQUlGTU5lWE9o?=
 =?utf-8?B?dXZYeGRLNGgxeTU4UVREa0ZjbmJOczhGU09BUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clI0K1dvbDBoT2dHVlMrUnA5OVU2V2FLUjlqTStYTld2b2pzZElRRkRWZDcv?=
 =?utf-8?B?Y1dqWk5xSHZzZkxQbExraXdZRjNqbzlBNU5LK3VURDF5ZmtsM1VtbE9OYTFZ?=
 =?utf-8?B?YTdlRmNGTGoydytJcitJK0FUL1IwNVNpcStsNm9ZVHVMempMNE5VN1FlalhO?=
 =?utf-8?B?YkhqaSswcC83ZXQrUDZiN3JKSXBqU3JkRnhQVlVWcTlGTHlmVHFYTGhXUTNt?=
 =?utf-8?B?QW9SV2RIa00vOGpCemR3N0dBTVFrVEdRQW94VGI0VWRGbWZFSGVBdkE4cW56?=
 =?utf-8?B?Sk5NcytFMUZ4dUtYRTFYaGNTWERyNDRyc3hCN3J3R0dqcnZ1dGNXWUZpZkVo?=
 =?utf-8?B?a3A0U2F6VXlIZHhDNWxMUTNCNStGeUp2UlV1ZUVXYzd0bmM4YkppRG1sVlNv?=
 =?utf-8?B?K215TXVwNkRjZ3lHZUt1c0dYcGg4Q0RWNGpScEk0RXlBaHlwK2twdS8vaFd0?=
 =?utf-8?B?allzL29BVTVkSEpxU05ITTU0VkM5QjRoaVVBNjNSTzdVR3c1QmczMXFsZFlT?=
 =?utf-8?B?WVgxVVRxcnZ4RjMwSHVPaG1DcHJudUNVa3N6QzJNZGQyTGx2MW9MbnBBQ2dz?=
 =?utf-8?B?ZU5mOXI0REcyYzdiUG1GbnBBSHU0cEplSUdnQnovVkUvdW53SFdkQUZJQ1B4?=
 =?utf-8?B?WElrbk9jRHBwcnA5Slp4aVZFM0NzZGdDQlJSTHR1c0lDbis2Z2x5ckNSZWsx?=
 =?utf-8?B?WWo4NXBTdEtseHBsYzgyS1pwRDhVTWdHV0RXamtoSU9tZGk1bzlsYTNvSk9S?=
 =?utf-8?B?T2s3R0MzMFk0NkFtTjR5TUt3c2J1VHRnRTF2VDl1KzE4ZHR0Z2JjMTZvMUFN?=
 =?utf-8?B?VmNTSFhHZG0rVmgxNitSQlRadFRGSmlDbGM1NTlrR0huR2tPM2hGRlJQQjU5?=
 =?utf-8?B?Rzh1RnRQTFA5UnovT1NMQnZ6ZGE4WG41c0h1bVI3OHNSeEtpaSs4RGJOSlNH?=
 =?utf-8?B?cmN4WGwyRXR3bGM4Rm1zNC9xT0NXTGFvRjI1cTFGZUxiUEVucklNaDFLQ3ZJ?=
 =?utf-8?B?NVZqRklheFRSTnNVNlQrQWRhWnZSM2FoQXVzQUxkSEp0TjJycW5UaDNESVpC?=
 =?utf-8?B?QWdIY0tMS2EweTUvMmdWUkNndG5lWkFOUE12eW1SRHB4ZWladmJ2eXJGa3Ns?=
 =?utf-8?B?NlBPeElMSGN3b1RxR01TVHFjVjJwNzhFRGRRTGcrM1ZBcDI1dk12NXFoOTZV?=
 =?utf-8?B?aWZzQzQ1VGdzZ3ZIWEpxb3FEVFc3UVl1Vy9MczI2QXg5YXNMcHRkVXlvVElj?=
 =?utf-8?B?NGtZaTBDdjEveHJ1b2I2S3VqelVZTXhDRzlBRFVVUGdLOHp5N0VyL1UxeVdv?=
 =?utf-8?B?ckVlY1hHMzhwcWNYck1pWEZ6TnFOK09oTlVjNkp1N3JwclQ0em1QYmFIcnRI?=
 =?utf-8?B?RTVwSXkrcnZrOWYyRDNSVXNabDhKbVNIWHdSVm1iS2taUjZxWENJQ3BuOGdI?=
 =?utf-8?B?VGlwUmsvQlJNdWkvdjFOcW96Q0c3MVozNUJqNUNzVUUrcWJncENlZkV4bkNC?=
 =?utf-8?B?dHlseXVFNlNxZWZ4S3VENVNRaE94c1ZyZUlKYUNkb2FaaG1hNUdqR3dsSzdB?=
 =?utf-8?B?LzE3Rlh6UWd0QlRnRk8zVGRvb0o3cnowb2VaakxyQVdlU2lLcDVQRkFXWmxX?=
 =?utf-8?B?STluSmNFR2Z5ZDdqbVZFS3hkdFFvOXVqMTdsZktTOXYwRHQxa0VJL3llVndh?=
 =?utf-8?B?QlM4ek95eUtvZkFjRjI0Q1FTcUtWVjFtYXVXRXRGbk54T1BlK3dIdFRXaCsx?=
 =?utf-8?B?VVM2TnlPUDYrZkdUSFpYM3BCOFhRc2pqai9DQlpPUEozM0dEUTdremZaZk9S?=
 =?utf-8?B?Y2E2UXRRcXJWSEFzMWZYaktERHRBaEtoMG4zaHJPUmQvQ3FFOEhLMGpzMWJj?=
 =?utf-8?B?cGtKcTJNV1NNaDhoQ2kwc08vV0N5UUhnYnBNa1lsZ0dPU1Vjb0NOZW9aZ1J1?=
 =?utf-8?B?NE9GSHM4SnlsQ2NVYlRYVGl0dCs1Q1REVUFBRVBQRkdpd3IzZlRpb3RGcitU?=
 =?utf-8?B?UjBvbWxiZTRWWG0yOTZCenEwSXNWYjdwSmp5c2JVUkM2ZUliVncreVRjcmwx?=
 =?utf-8?B?ZzZ0M3loZ3NsSVRUemhJbjhsdThhcUNpOTJEekJ4RmZTS3R0NWVaR2VkS21x?=
 =?utf-8?B?ZlEwTUs1b011akVxWVREc1RRSlh5REJHUWkxTWxwbGdRV0ZjUWRVSm13bVZI?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <82218925A1F0654783B4D85D80516266@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0091563a-2470-4453-e289-08de31295f8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 22:31:29.9157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dg58CH1ZXQdZtKSq81vsWvJkTwb573KEqPrXInPSmtK1pM2Oj5NXEf4zsRe/GrxnIxoNw158XKlCgkFBFdSvdMjDXXQGdEoamgHRV1HxJ/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8075
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTExLTI3IGF0IDE0OjI5ICswMjAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gV2hpbGUgdGhlIFREWCBpbml0aWFsaXphdGlvbiBjb2RlIGluIGFyY2gveDg2IHVzZXMg
cGFnZXMgd2l0aCAyTUINCj4gPiBhbGlnbm1lbnQsIEtWTSB3aWxsIG5lZWQgdG8gaGFuZCA0S0Ig
cGFnZXMgZm9yIGl0IHRvIHVzZS4gVW5kZXIgRFBBTVQsDQo+ID4gdGhlc2UgcGFnZXMgd2lsbCBu
ZWVkIERQQU1UIGJhY2tpbmcgNEtCIGJhY2tpbmcuDQo+IA0KPiBUaGF0IHBhcmFncmFwaCBpcyBy
YXRoZXIgaGFyZCB0byBwYXJzZS4gS1ZNIHdpbGwgbmVlZCB0byBoYW5kIDRrIHBhZ2VzIA0KPiB0
byB3aG9tPyBUaGUgdGR4IGluaXQgY29kZT8gQWxzbyB0aGUgbGFzdCBzZW50ZW5jZSB3aXRoIHRo
ZSAyICJiYWNraW5nIiANCj4gd29yZHMgaXMgaGFyZCB0byBwYXJzZS4gRG9lcyBpdCBzYXkgdGhh
dCB0aGUgNGsgcGFnZXMgdGhhdCBLVk0gbmVlZCB0byANCj4gcGFzcyBtdXN0IGJlIGJhY2tlZCBi
eSBEUEFNVCBwYWdlcyBpLmUgbGlrZSBhIGNoaWNrZW4gYW5kIGVnZyBwcm9ibGVtPw0KDQpZb3Un
cmUgcmlnaHQgaXQncyBjb25mdXNpbmcgYW5kIGFsc28gYSBzbGlnaHRseSBtaXNsZWFkaW5nIHR5
cG8sIG1heWJlIHRoaXMgaXMNCmFuIGltcHJvdmVtZW50Pw0KDQogICBXaGlsZSB0aGUgVERYIG1v
ZHVsZSBpbml0aWFsaXphdGlvbiBjb2RlIGluIGFyY2gveDg2IG9ubHkgaGFuZHMgcGFnZXMgdG8g
dGhlDQogICBURFggbW9kdWxlIHdpdGggMk1CIGFsaWdubWVudCwgS1ZNIHdpbGwgbmVlZCB0byBo
YW5kIHBhZ2VzIHRvIHRoZSBURFggbW9kdWxlDQogICBhdCA0S0IgZ3JhbnVsYXJpdHkuIFVuZGVy
IERQQU1ULCBzdWNoIHBhZ2VzIHdpbGwgcmVxdWlyZSBwZXJmb3JtaW5nIHRoZQ0KICAgVERILlBI
WU1FTS5QQU1ULkFERCBTRUFNQ0FMTCB0byBnaXZlIGEgcGFnZSBwYWlyIHRoZSB0aGUgVERYIG1v
ZHVsZSB0byB1c2UNCiAgIGZvciBQQU1UIHRyYWNraW5nIGF0IHRoZSA0S0IgcGFnZSBzaXplIHBh
Z2UuDQoNCk5vdGU6IFRoZXJlIGlzIG5vIGNoaWNrZW4gb3IgZWdnIHByb2JsZW0sIFRESC5QSFlN
RU0uUEFNVC5BREQgaGFuZGxlcyBpdC4NCg0KPiANCj4gPiANCj4gPiBBZGQgdGR4X2FsbG9jX3Bh
Z2UoKSBhbmQgdGR4X2ZyZWVfcGFnZSgpIHRvIGhhbmRsZSBib3RoIHBhZ2UgYWxsb2NhdGlvbg0K
PiA+IGFuZCBEUEFNVCBpbnN0YWxsYXRpb24uIE1ha2UgdGhlbSBiZWhhdmUgbGlrZSBub3JtYWwg
YWxsb2MvZnJlZSBmdW5jdGlvbnMNCj4gPiB3aGVyZSBhbGxvY2F0aW9uIGNhbiBmYWlsIGluIHRo
ZSBjYXNlIG9mIG5vIG1lbW9yeSwgYnV0IGZyZWUgKHdpdGggYW55DQo+ID4gbmVjZXNzYXJ5IERQ
QU1UIHJlbGVhc2UpIGFsd2F5cyBzdWNjZWVkcy4gRG8gdGhpcyBzbyB0aGV5IGNhbiBzdXBwb3J0
IHRoZQ0KPiA+IGV4aXN0aW5nIFREWCBmbG93cyB0aGF0IHJlcXVpcmUgY2xlYW51cHMgdG8gc3Vj
Y2VlZC4gQWxzbyBjcmVhdGUNCj4gPiB0ZHhfcGFtdF9wdXQoKS90ZHhfcGFtdF9nZXQoKSB0byBo
YW5kbGUgaW5zdGFsbGluZyBEUEFNVCA0S0IgYmFja2luZyBmb3INCj4gPiBwYWdlcyB0aGF0IGFy
ZSBhbHJlYWR5IGFsbG9jYXRlZCAoc3VjaCBhcyBleHRlcm5hbCBwYWdlIHRhYmxlcywgb3IgUy1F
UFQNCj4gPiBwYWdlcykuDQo+ID4gDQo+IA0KPiA8c25pcD4NCj4gDQo+IA0KPiA+ICsNCj4gPiAr
LyogU2VyaWFsaXplcyBhZGRpbmcvcmVtb3ZpbmcgUEFNVCBtZW1vcnkgKi8NCj4gPiArc3RhdGlj
IERFRklORV9TUElOTE9DSyhwYW10X2xvY2spOw0KPiA+ICsNCj4gPiArLyogQnVtcCBQQU1UIHJl
ZmNvdW50IGZvciB0aGUgZ2l2ZW4gcGFnZSBhbmQgYWxsb2NhdGUgUEFNVCBtZW1vcnkgaWYgbmVl
ZGVkDQo+ID4gKi8NCj4gPiAraW50IHRkeF9wYW10X2dldChzdHJ1Y3QgcGFnZSAqcGFnZSkNCj4g
PiArew0KPiA+ICsJdTY0IHBhbXRfcGFfYXJyYXlbTUFYX1REWF9BUkdfU0laRShyZHgpXTsNCj4g
PiArCWF0b21pY190ICpwYW10X3JlZmNvdW50Ow0KPiA+ICsJdTY0IHRkeF9zdGF0dXM7DQo+ID4g
KwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCWlmICghdGR4X3N1cHBvcnRzX2R5bmFtaWNfcGFtdCgm
dGR4X3N5c2luZm8pKQ0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsNCj4gPiArCXJldCA9IGFsbG9j
X3BhbXRfYXJyYXkocGFtdF9wYV9hcnJheSk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCWdvdG8g
b3V0X2ZyZWU7DQo+ID4gKw0KPiA+ICsJcGFtdF9yZWZjb3VudCA9IHRkeF9maW5kX3BhbXRfcmVm
Y291bnQocGFnZV90b19wZm4ocGFnZSkpOw0KPiA+ICsNCj4gPiArCXNjb3BlZF9ndWFyZChzcGlu
bG9jaywgJnBhbXRfbG9jaykgew0KPiA+ICsJCS8qDQo+ID4gKwkJICogSWYgdGhlIHBhbXQgcGFn
ZSBpcyBhbHJlYWR5IGFkZGVkIChpLmUuIHJlZmNvdW50ID49IDEpLA0KPiA+ICsJCSAqIHRoZW4g
anVzdCBpbmNyZW1lbnQgdGhlIHJlZmNvdW50Lg0KPiA+ICsJCSAqLw0KPiA+ICsJCWlmIChhdG9t
aWNfcmVhZChwYW10X3JlZmNvdW50KSkgew0KPiA+ICsJCQlhdG9taWNfaW5jKHBhbXRfcmVmY291
bnQpOw0KPiA+ICsJCQlnb3RvIG91dF9mcmVlOw0KPiA+ICsJCX0NCj4gDQo+IFJlcGxhY2UgdGhp
cyBwYWlyIG9mIHJlYWQvaW5jIHdpdGggYSBzaW5nbGUgY2FsbCB0byBhdG9taWNfaW5jX25vdF96
ZXJvKCkNCg0KRnJvbSB0aGUgdGhyZWFkIHdpdGggQmluYmluIG9uIHRoaXMgcGF0Y2gsIHRoZSBh
dG9taWNzIGFyZW4ndCByZWFsbHkgbmVlZGVkDQp1bnRpbCB0aGUgb3B0aW1pemF0aW9uIHBhdGNo
LiBTbyB3YXMgdGhpbmtpbmcgdG8gYWN0dWFsbHkgdXNlIGEgc2ltcGxlciBub24tDQphdG9taWMg
b3BlcmF0aW9ucy4NCg0KPiANCj4gPiArDQo+ID4gKwkJLyogVHJ5IHRvIGFkZCB0aGUgcGFtdCBw
YWdlIGFuZCB0YWtlIHRoZSByZWZjb3VudCAwLT4xLiAqLw0KPiA+ICsNCj4gPiArCQl0ZHhfc3Rh
dHVzID0gdGRoX3BoeW1lbV9wYW10X2FkZChwYWdlLCBwYW10X3BhX2FycmF5KTsNCj4gPiArCQlp
ZiAoIUlTX1REWF9TVUNDRVNTKHRkeF9zdGF0dXMpKSB7DQo+ID4gKwkJCXByX2VycigiVERIX1BI
WU1FTV9QQU1UX0FERCBmYWlsZWQ6ICUjbGx4XG4iLA0KPiA+IHRkeF9zdGF0dXMpOw0KPiA+ICsJ
CQlnb3RvIG91dF9mcmVlOw0KPiA+ICsJCX0NCj4gPiArDQo+ID4gKwkJYXRvbWljX2luYyhwYW10
X3JlZmNvdW50KTsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlyZXR1cm4gcmV0Ow0KPiA+ICtvdXRf
ZnJlZToNCj4gPiArCS8qDQo+ID4gKwkgKiBwYW10X3BhX2FycmF5IGlzIHBvcHVsYXRlZCBvciB6
ZXJvZWQgdXAgdG8NCj4gPiB0ZHhfZHBhbXRfZW50cnlfcGFnZXMoKQ0KPiA+ICsJICogYWJvdmUu
IGZyZWVfcGFtdF9hcnJheSgpIGNhbiBoYW5kbGUgZWl0aGVyIGNhc2UuDQo+ID4gKwkgKi8NCj4g
PiArCWZyZWVfcGFtdF9hcnJheShwYW10X3BhX2FycmF5KTsNCj4gPiArCXJldHVybiByZXQ7DQo+
ID4gK30NCj4gPiArRVhQT1JUX1NZTUJPTF9HUEwodGR4X3BhbXRfZ2V0KTsNCj4gPiArDQo+ID4g
Ky8qDQo+ID4gKyAqIERyb3AgUEFNVCByZWZjb3VudCBmb3IgdGhlIGdpdmVuIHBhZ2UgYW5kIGZy
ZWUgUEFNVCBtZW1vcnkgaWYgaXQgaXMgbm8NCj4gPiArICogbG9uZ2VyIG5lZWRlZC4NCj4gPiAr
ICovDQo+ID4gK3ZvaWQgdGR4X3BhbXRfcHV0KHN0cnVjdCBwYWdlICpwYWdlKQ0KPiA+ICt7DQo+
ID4gKwl1NjQgcGFtdF9wYV9hcnJheVtNQVhfVERYX0FSR19TSVpFKHJkeCldOw0KPiA+ICsJYXRv
bWljX3QgKnBhbXRfcmVmY291bnQ7DQo+ID4gKwl1NjQgdGR4X3N0YXR1czsNCj4gPiArDQo+ID4g
KwlpZiAoIXRkeF9zdXBwb3J0c19keW5hbWljX3BhbXQoJnRkeF9zeXNpbmZvKSkNCj4gPiArCQly
ZXR1cm47DQo+ID4gKw0KPiA+ICsJcGFtdF9yZWZjb3VudCA9IHRkeF9maW5kX3BhbXRfcmVmY291
bnQocGFnZV90b19wZm4ocGFnZSkpOw0KPiA+ICsNCj4gPiArCXNjb3BlZF9ndWFyZChzcGlubG9j
aywgJnBhbXRfbG9jaykgew0KPiA+ICsJCS8qDQo+ID4gKwkJICogSWYgdGhlIHRoZXJlIGFyZSBt
b3JlIHRoYW4gMSByZWZlcmVuY2VzIG9uIHRoZSBwYW10DQo+ID4gcGFnZSwNCj4gPiArCQkgKiBk
b24ndCByZW1vdmUgaXQgeWV0LiBKdXN0IGRlY3JlbWVudCB0aGUgcmVmY291bnQuDQo+ID4gKwkJ
ICovDQo+ID4gKwkJaWYgKGF0b21pY19yZWFkKHBhbXRfcmVmY291bnQpID4gMSkgew0KPiA+ICsJ
CQlhdG9taWNfZGVjKHBhbXRfcmVmY291bnQpOw0KPiA+ICsJCQlyZXR1cm47DQo+ID4gKwkJfQ0K
PiANCj4gbml0OiBDb3VsZCBiZSByZXBsYWNlZCB3aXRoIDogYXRvbWljX2FkZF91bmxlc3MocGFt
dF9yZWZjb3VudCwgLTEsIDEpOw0KPiANCj4gUHJvYmFibHkgaXQgd291bGQgaGF2ZSBiZWVuIGJl
dHRlciB0byBzaW1wbHkgdXNlIGF0b21pYzY0X2RlY19hbmRfdGVzdCANCj4gYW5kIGlmIGl0IHJl
dHVybnMgdHJ1ZSBkbyB0aGUgcGh5bWVtX3BhbXRfcmVtb3ZlLCBidXQgSSBzdXNwZWN0IHlvdSAN
Cj4gY2FuJ3QgZG8gaXQgYmVjYXVzZSBpbiBjYXNlIGl0IGZhaWxzIHlvdSBkb24ndCB3YW50IHRv
IGRlY3JlbWVudCB0aGUgDQo+IGxhc3QgcmVmY291bnQsIHRob3VnaCB0aGF0IGNvdWxkIGJlIHJl
bWVkaWVkIGJ5IGFuIGV4dHJhIGF0b21pY19pbnQgaW4gDQo+IHRoZSBmYWlsdXJlIHBhdGguIEkg
Z3Vlc3MgaXQgbWlnaHQgYmUgd29ydGggc2ltcGxpZnlpbmcgc2luY2UgdGhlIGV4dHJhIA0KPiBp
bmMgd2lsbCBvbmx5IGJlIG5lZWRlZCBpbiBleGNlcHRpb25hbCBjYXNlcyAod2UgZG9uJ3QgZXhw
ZWN0IGZhaWx1cmUgb3QgDQo+IGJlIHRoZSB1c3VhbCBwYXRoKSBhbmQgZnJlZWluZyBpcyBub3Qg
YSBmYXN0IHBhdGguDQoNClRoZSBnb2FsIG9mIHRoaXMgcGF0Y2ggaXMgdG8gYmUgYXMgc2ltcGxl
IGFuZCBvYnZpb3VzbHkgY29ycmVjdCBhcyBwb3NzaWJsZS4NClRoZW4gdGhlIG5leHQgcGF0Y2gg
Ing4Ni92aXJ0L3RkeDogT3B0aW1pemUgdGR4X2FsbG9jL2ZyZWVfcGFnZSgpIGhlbHBlcnMiDQpz
aG91bGQgaGF2ZSB0aGUgb3B0aW1pemVkIHZlcnNpb25zLiBEbyB5b3UgaGF2ZSBhbnkgc2ltaWxh
ciBzdWdnZXN0aW9ucyBvbiB0aGUNCmNvZGUgYWZ0ZXIgdGhlIG5leHQgcGF0Y2ggaXMgYXBwbGll
ZD8NCg0K

