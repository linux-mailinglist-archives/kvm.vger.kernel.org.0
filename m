Return-Path: <kvm+bounces-16708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 682548BCAF3
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EEC71C21EB0
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5F114262B;
	Mon,  6 May 2024 09:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QShjFmkg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8714EB2B;
	Mon,  6 May 2024 09:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714988476; cv=fail; b=tOKZEmW+KDWNoiQ210nWDFByIFyipih/4Ey4/24BA9usfymoSJjK6C9Rv5lbLfjIybN9Av8Qj96Cjhg/dZdldQyviK8tABaqrvhtQGaRBoHNxM3hRTySgId+T7VsVgr/NQNSfDSMd8ksHedhdFfqy+d3buVDUA705SSyyyrCUDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714988476; c=relaxed/simple;
	bh=IOy2zo8niQeNIWzqzHp+M8zD3ytsXm96Pk2uNc5AydY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GMI3WBCAI2dO8SmsPupk39rHtggbmyAQeX89cLgym6llnrmuBwUwE2MpFtIOhZLfnMCSM9JNvhHR9XODQJRfKvQzWeAoYwRNzkw7KJXDoLiQ7Ia9bM2cykX6de3a67M9IZRBA2DW6+oAVVE8Y00vOMzJE97x33sonbaJP9DZegI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QShjFmkg; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714988475; x=1746524475;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IOy2zo8niQeNIWzqzHp+M8zD3ytsXm96Pk2uNc5AydY=;
  b=QShjFmkgUERWVBeh2MMqgCG/3yjMS9Pdf/OJ3Ra2z41mSo+JRsaUzZF8
   IJHiSROkeE7Y2zDoOQ6bWZwIZ4D7lAIt5sCS0Qm/SNgW+XCa5rDJWbosR
   UTCNoOuDsQ7w9eL6SeiAFdxQMJ5qE3qR38r6hQvDesrLv70HtfutJ4BT3
   cbdbqZVV/UsJOf5+l+s2E7GSMqaZPV85HMzkeRIHtMYHwYYUvAgAjMIry
   Im8CH0QerMZLdug+SPi+8JIPNIISMgL/XQ2ghyF1mOrcNOGc+fTOBzorF
   s7nctN/uMBiDunXK8dbIKvY5pY3VT926D+J0O8kxgjAqC+D4fPkNK/VyO
   Q==;
X-CSE-ConnectionGUID: H+eHNKVqSsq1L7/IZQ+TEQ==
X-CSE-MsgGUID: B4EVaHoCR725ZZIaFwOZnQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="10883418"
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="10883418"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 02:41:14 -0700
X-CSE-ConnectionGUID: Mpw85z4kS+OmIMHLabEB2A==
X-CSE-MsgGUID: vNJgwuMqTfWVgkJjyfyoyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="28629189"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 02:41:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 02:41:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 02:41:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 02:41:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQ7UTmuSsa9h3kbdND6Ong84BO3BvKL8AO2yjc8i4bWGwtDjrO5Dp5b8cpS/NODF0+8fMWmIt2Y1RSYXHfsmb6f6WjaAY8N6S1GHoNbtYpG+EJUOhC3hXmKPuaCoLzvOyqfYcuyVT1sS7kSYo3gW0Z6grdLKVDCZhj47YiZFZkXFAtDNAO++f9vC262KdpxRRuHgzFKPC3GyXKiKDkBzB1A29LxZ4wK7eBJKQE+JOfD+MD3qgL5DCHjRvnXrQ3v5MpueBwL+VDAPSeJ3k8Sv1vIVjZUhE0B3KctUlzoE10USfX3Jh4hgTfwKKLCw5AiB7olzOObts3lVg0CO2Scqog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tqEQ21TgVoqSG8/mYwofIROuTfCTUKbdiJCtue3R3c=;
 b=SWXsi5tzi+rzXRcyuPf6fepk/qchH0Aj4kfHwWLm4u2h8XJn7r33tyUVnzPo3DbbLu5l30AnGixgkocw41ynlJK05mSVocBm0JHo3gY3Y7FgjtMi/tEnsKjSWlj4lI+hJHGCyj9RKljPMAqbAroH9a+XM4MpMBDqxu2JTT3D/LRd6y2yAbwUa4CckCq0ILyNipliRK+OJyQ0KrNpVrBjAmBhjuiIkQu6JUiH6/il5VvnIw2u1Xo3T+tkH1FvbJfRPjm2CO6iNVL20URH28T7j6vRBtGVjwL98CLAPDQz1+Lrx7gfkSSfVvCXJWjLXbPXkTjnuTd2MiajfcI8GztN4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5245.namprd11.prod.outlook.com (2603:10b6:5:388::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 09:41:12 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 09:41:12 +0000
Message-ID: <83bb5f3f-a374-4b0e-a26d-9a9d88561bbe@intel.com>
Date: Mon, 6 May 2024 17:41:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLRnisdUgeYgg8i@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjLRnisdUgeYgg8i@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0003.apcprd06.prod.outlook.com
 (2603:1096:4:186::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5245:EE_
X-MS-Office365-Filtering-Correlation-Id: a387e2df-8e08-4be6-c8bc-08dc6db0aa69
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VG9USnFDNTZxNmVvZlVYSklmaXFWeFNjUFcrdVBrN0t5MVF0c2FyY0dLNjdK?=
 =?utf-8?B?OWRCenJsRGR1N1QxUTlQN3kzM3J0Yk5Ya000aGtsdERIRVMxRzEraGo0bk5v?=
 =?utf-8?B?cCtFUFlwbTdQQXo3Rk1US0FYSWx1Z2V2K2VvMEl1ejVwWG83dHhKWlNUdXVm?=
 =?utf-8?B?bkZJMEhOTUlFQ2dMTmVmaS9TYkxrSDN4R1BDQitqUk9NRFo2YkdjZ2JyOThC?=
 =?utf-8?B?dnR4NHYvRkhkZzM0VUdVa1ZyUURMWDBMT1B4T1BHTUVOWmZpSzVZRStQR2ZU?=
 =?utf-8?B?c25PbEEvcTB3cllIVExyeVNSaDdYWnB1bWxIRnE3YTNJUFFxWHFua1I4bXhY?=
 =?utf-8?B?ajdEdmxJbG0wdG5FbWsyWXhLaFNaejh5MXlSUjdxdFFGZmpZZ2lNTXZLVWI0?=
 =?utf-8?B?ekpvVEFKTXpGSm04WXd3S295RFI4ZVFYRldFdG5SbENhd0F0TThxQWY3dEZF?=
 =?utf-8?B?VVpYa0FYdDF4MElJK2MxcEQ0ZmJuNFdlTjNsNElhSVJ5QXVBRi9aZXVwOExN?=
 =?utf-8?B?UEdJR1F2R2V3dm9ndGJvQTNYWnVCMmhNNFFkV1RqM3lIb2tkNTBMK29aRUpl?=
 =?utf-8?B?WFdwK05WcGhDak5wWUUreWNBZW5wWmVlcDlxdGRaeE41U1dQVEJ1WmdvTjFB?=
 =?utf-8?B?aE1BeWtQTC9wRHc2NWszMXBleFpKZ2lYdC8zNFU4NVI5S3pwazZxMnROR3ZJ?=
 =?utf-8?B?ZG1Vb1N1TFR5emEzN29LL2pIN2dPdnN0YWc5L1dOMCtkeGpsSUVDdUFSelpN?=
 =?utf-8?B?UDJUcGpZUWRUdTgrS3kxNmJFdm5HbWU3cXFpV0tLVTl6ZUF2ZmFqU2JzOVpP?=
 =?utf-8?B?VTk5dWl2cWloVm9UMWxweTBPNlBDWjJXdG5VRVYyaDJ5aDR2MlpLeU4vZVVG?=
 =?utf-8?B?cGJvL1IweXVzeTdyWXRnS25xUVUxR0p6djJGNWtRaFBYMVFwTVZjWEw4MTZw?=
 =?utf-8?B?SFJldnZjY05BRVNjeWF3dGpmYTJ6RzZEV2tNMDhpQ2o2ZlNwbTdMcEc0ZnNW?=
 =?utf-8?B?NlBySUFSRTZPTFdBRUhqRGxBTWVWdkJKWTZqTVc5cWZRV0l3N0hoZXhOQmcx?=
 =?utf-8?B?VHlJNzVPeXJGajB1RzhBSHZpNWtTUEZLNSt2QTl2azBxdVhJK0tnK0V4L200?=
 =?utf-8?B?NFFQZDVEZlJkenkvLzA4ZWh0Snk2WHdYSDVpOG92NkRKY0pwMXFHd0ZiRWFN?=
 =?utf-8?B?SDNwa3RQMGh4d2NhMVY5RGZ3cjV3cWN1eFdqTVM2em5ZK2hPbTI3WVJhVHo5?=
 =?utf-8?B?RDRPZzQ0ajk3UzBoRzJaUUZXOS9OL3ZOdjEvZXhzcC96ZE45V2w0QlZCeGhB?=
 =?utf-8?B?V2N0T2dwUHl0SjJIcU1qTEhXK3pBQkFBZ1NBWVZEZ1E2MjhNS0FLZHk1RUpy?=
 =?utf-8?B?SHhtOWdoTGppRTVqWmlxZ2NHQ2x5bWZkc2JzcVQ0Wi9INC81VWlXam5jNkNZ?=
 =?utf-8?B?d1NRK0VCOW5uUlFFaFVoVTdBbDd0Y3RTbUw3anRLbnJWWno4YXozTFdHWWRy?=
 =?utf-8?B?K3FVcWp2bS9wOEswdEQ1SHZwRlBrTW5RZ2RxeG5QL0NxcnplMUR4Qk01MmN5?=
 =?utf-8?B?T1VNQWdFZ1lvS0xoOTBnMjVUM2U4aHVCcUNYNDYyM2MyVEZndEJLN29IdHB2?=
 =?utf-8?B?Zk53M3JSN2xPZ1BoOTZ1bkJOSE8vRlRBN01DTk1PNHhMUWFyNUxqQUpPdURL?=
 =?utf-8?B?UjU1WGpXSitPVVI0NmNsQm5BY3lMWmhMeUJiTTRtV2U3QWZUTk9uUDh3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WG9DREUxV1NXbEc5THc1emlMY0FqaWE0S2ZqZ3MxeTNKeXlLVXd0ejhNMzNX?=
 =?utf-8?B?MDJ3Y3IyZFlzM0FvSUtZc0R3RHRLVm5GL1YrMlFyRnA2bngvdGxNYm5ZanRT?=
 =?utf-8?B?L2FXc2syUHE5R0FPWUVPcFVxRjB2VmJxWHFOWTZlU2FHR3F5TUVCV1o0eVpH?=
 =?utf-8?B?bXNPMURsSkVFUlllb0s2QjQzRDlvR1I5NUk5VXJUS2V4NVJWaHJhbk5oUjRU?=
 =?utf-8?B?cUJkZEs4OHltNGdpSFc0cDJRQXNFQUdFQnBaMDM3ak9xWVpIeGE0RmI4eWVJ?=
 =?utf-8?B?c1FYYUpON3VxKzcrWEI2OWoxWUVqaHE5NzZsMmQzWFN4T3NiRnNuOWVlT3N4?=
 =?utf-8?B?NFI3QnhBWTU1V0xKNUxpVERqSnBXTXZNSHIvOVh0WnQ1dTlDengrc1NvOXdV?=
 =?utf-8?B?MWNoaWFsSDdZMk5HcWpPRGlPeEtrS0FZcXMyWDV3cjNsekkzWllwWFUwdnZt?=
 =?utf-8?B?T1RkZ2xUQkpqY0UwbUJlemJGZjNNWTBjemladEZOamgwZDh6bm5xZ2xmN3BZ?=
 =?utf-8?B?QlA0eDVZOGlzUUdaU0MwTkJZMUdvTVpIc2N2ckljOFBEcitUTmNqanNZS29P?=
 =?utf-8?B?RjA5MllzUmdFNlUxNWVkQjB6dEQ4amVwUjF2Mk9uM1JSSjNpZW4zWVNJVGxH?=
 =?utf-8?B?a3h1WTZhdGpsV1VGbUM5SWx2T3ptbEt5OWxwQnZlT1dzM0dzMDg4SlZBTnZl?=
 =?utf-8?B?QThZWERmNmRVc041K0llVUdpbDFuaVVHSklpNHEvdm5jZEM5OUNQUUhsNEFX?=
 =?utf-8?B?dURNdnFWTHVhU0xncWhqLzFwTkhIWEZHTFBYSFRhcTVvOGxaNEFPeXF2UjBV?=
 =?utf-8?B?L0RkTGsyM3RHWTRLbjRXSHRSQVhIY21TQ0VRd1pwWVUwOXZnS2JySlFEQlpw?=
 =?utf-8?B?MUd5SXNuMCtpdVQ5NEFxdjlJems2d2h1MTRHZnE1eVR1emNJaXFSaHNTOVZn?=
 =?utf-8?B?dHUwbXNLVHh2Tmc4Z1Q0RzFUQThoT2h2YVBXOGVLSjhDb0hUMW1RS0VBV215?=
 =?utf-8?B?QTI0OGNiMVM1WjdtNU1KNHVRZ2tRdTk4M0FqWGxJdldqakVVMEhvaGhOandD?=
 =?utf-8?B?TmVZeXhuQnArU1VHUEVsSzlvb2dPclhha2xBUnY2RzR1ZG95ankxcm1vR1VQ?=
 =?utf-8?B?Z3grYzJocmo4dUh1NmNLQy8zdFZhWkkxL3habURwYlVIanFyalhsaDVRR25s?=
 =?utf-8?B?STQ0QzNQOXRBblhNemw1RkhFRnBhS0J4dXNVVldodlAyNzY1dTJKS2tIZmVQ?=
 =?utf-8?B?N2oxVDBtL1k0eTFoQTdITEt2QmdwblZ6LzRLb0YwRnE0dWp1UEJadE5kM24r?=
 =?utf-8?B?ekVzUm4xaEhhWERNM3JUTThSeGVWVHVXMFo2YVVJYlpneXEvdWJicXoxemJS?=
 =?utf-8?B?QVpVMi8yQ2VnVHk0dzdPYmpKbUFlZ3VRY1lmL3UybGM4bU9KWWZGampMd1p0?=
 =?utf-8?B?dFJVNzhNRXA5MURkRUNLaWdXdDdGbm5FWDUxNHZQTnRxcGxZZ3VzejV0YUxT?=
 =?utf-8?B?SlZXM2JUc1BlenhzS091T1JMcnpzLzZFT2M2YW9oakptSXRzS0NHbXl1NVJH?=
 =?utf-8?B?cmE4MkNSZ0dhTU1ibE9NeVpEMnZ2UnhLakEraVJzV2ovQWZIeHJFb1k5ekgx?=
 =?utf-8?B?T1RpRDNENTNuMExrUWE5c3A5MjhlRE1RU3F1Wjk0N3UwVjUvenUyMEduWDlj?=
 =?utf-8?B?UnVBaXcvWlRQdTlHZnpDOWVRYU5yVzV1WTlIZ29lYnlTQTRQTWZudEd5YXIw?=
 =?utf-8?B?WVh6ZTZ4QTM2dkRkMnp6ZlB2V0hSNXJramowNmVhWXpsc3drTHZuZDlzU3Z1?=
 =?utf-8?B?cWxzMS9WbXhmeHI3WnNlN01NTTkyOFZ4WGp5YU5NQnp3ZHlxUWJCQWJtUWFl?=
 =?utf-8?B?K3gxSlVYN0xjQUQ3cHNMZngxN0ZmS0RpTHBlcUhIYU5QbTg2aTlQNTJ5NGZL?=
 =?utf-8?B?WGxDeGdXWUpOQmg2c1lSNlhkUDI4QytwaGdtc3BvYnJsMlBMYlZZMHJtOWd5?=
 =?utf-8?B?TVF2czEycmhFZUZQZzZ1VFoybVBOVG1kakZjRmkvazhLM0VEN1hVbUpPVkVz?=
 =?utf-8?B?S0E2WFBwM3hQRTg4TWcxQVE2NDFkNjBWa1U4c3dsRVFSb0VFeUpKMnlvWm5Z?=
 =?utf-8?B?cmZiQ3RmL2lWWHlMOFlxVHhUamwxZXF4OE45Q3U4OE16am9FbmlvT1AwbkxL?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a387e2df-8e08-4be6-c8bc-08dc6db0aa69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 09:41:12.3984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ykL7fLOoAS+t0lWok7SBDKwACa7GzqcH+Xy5AZ4ec0Gf3z9cIm3CpsyZQ6XfGzrJugTkl6CF+Vd2XpQYEePrxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5245
X-OriginatorOrg: intel.com

On 5/2/2024 7:34 AM, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> @@ -665,7 +665,7 @@ void kvm_set_cpu_caps(void)
>>   		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>>   		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>>   		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
>> -		F(SGX_LC) | F(BUS_LOCK_DETECT)
>> +		F(SGX_LC) | F(BUS_LOCK_DETECT) | F(SHSTK)
>>   	);
>>   	/* Set LA57 based on hardware capability. */
>>   	if (cpuid_ecx(7) & F(LA57))
>> @@ -683,7 +683,8 @@ void kvm_set_cpu_caps(void)
>>   		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>>   		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>>   		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
>> -		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
>> +		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D) |
>> +		F(IBT)
>>   	);
> ...
>
>> @@ -7977,6 +7993,18 @@ static __init void vmx_set_cpu_caps(void)
>>   
>>   	if (cpu_has_vmx_waitpkg())
>>   		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
>> +
>> +	/*
>> +	 * Disable CET if unrestricted_guest is unsupported as KVM doesn't
>> +	 * enforce CET HW behaviors in emulator. On platforms with
>> +	 * VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error code
>> +	 * fails, so disable CET in this case too.
>> +	 */
>> +	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
>> +	    !cpu_has_vmx_basic_no_hw_errcode()) {
>> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>> +	}
> Oh!  Almost missed it.  This patch should explicitly kvm_cpu_cap_clear()
> X86_FEATURE_SHSTK and X86_FEATURE_IBT.  We *know* there are upcoming AMD CPUs
> that support at least SHSTK, so enumerating support for common code would yield
> a version of KVM that incorrectly advertises support for SHSTK.
>
> I hope to land both Intel and AMD virtualization in the same kernel release, but
> there are no guarantees that will happen.  And explicitly clearing both SHSTK and
> IBT would guard against IBT showing up in some future AMD CPU in advance of KVM
> gaining full support.

Let me be clear on this, you want me to disable SHSTK/IBT with kvm_cpu_cap_clear() unconditionally
for now in this patch, and wait until both AMD's SVM patches and this series are ready for guest CET,
then remove the disabling code in this patch for final merge, am I right?



