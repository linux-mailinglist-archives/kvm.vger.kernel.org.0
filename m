Return-Path: <kvm+bounces-35526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F93A11F5D
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 11:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B4F31885EAC
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 10:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5FD23F29B;
	Wed, 15 Jan 2025 10:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S8/ILfU7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58B11DB130
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736936854; cv=fail; b=MqBEq5HuTsnF/eg8hTIxsKEGPuGutKFQ0j7sw88RnhFadWTb8X+ODjyiHlbXhWfXc/UULvgZALZrrbMrl8zybsXLpFKylt004AhqVyrN3Nt7JBWiBbj0VJ/yeeROOienQkkiwBYQLgOsRRK43SboCEDWY0I8v/bmKzrPuDvTbuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736936854; c=relaxed/simple;
	bh=R9qZU1mW/qXltMS74ogt2I4eV4eJjSr/GdtmwSqkDKE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gqvZ2wdHlVgLb5UZY/ARwS1oJUbjqU2uf1INsY9eEiW+U0961hvOdlWeB1Qb/pe5/eVShWPLNX0jYcHA9vwNsj/3BLoht12n9n2h6CQoSCew3+4ND/0rRs83K+FrxD940GEyNAXxxxaLWUh4m+OA3QxHOtXMf3EMaKxroz+ZgbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S8/ILfU7; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736936853; x=1768472853;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R9qZU1mW/qXltMS74ogt2I4eV4eJjSr/GdtmwSqkDKE=;
  b=S8/ILfU7E0X7oVXuz5K/A2RbF1pO9d93WNjSzt2PurijOMDi6Ao2X8ls
   CPCZtqehclDZNF/hA1X2T9WBqEx8fycgkubkfJknWkECsTw/RZspELnTo
   D+78T3hT365Qm9A6BY2Snt+QetK16xEE00f+TURhRiQLHdaZKb5Tr9JRZ
   1QCwXSKX3TXxRIJQ/9RZQGF3q5TYwa/2i09hvjXaJkX2xtjVcrTYvl1ke
   1MBLSrkw6DxZSND/PZwAqzL2OTSSUTVnfMcMEERRa1lVeted+B6yJr2Ys
   /d1zkC6W5cucI6+cXBdw/7PIUIvWZr09BCH9KLNrPyj6QuCZtqJsfBuxb
   Q==;
X-CSE-ConnectionGUID: wVUWdwpGTwqUpNnwkFWGFA==
X-CSE-MsgGUID: tCBOEWhWQ+ODhumxLLv/zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="37377733"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="37377733"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 02:27:32 -0800
X-CSE-ConnectionGUID: GiilWFfPRsaoElTEIfmvnQ==
X-CSE-MsgGUID: TW/lUmX0QAG7th7DBgffLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="109715575"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 02:27:32 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 02:27:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 02:27:31 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 02:27:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LX9Y1/ojTk6VtzARKDW530rk2mllfVMlBe7TksFDWLNRS8yd7lbq7aNf6IHydKzPdHicew0/pVXCnbAZaXDaQjUBfzR3a589Eh91szmkk/ZzaON0n57hTp21wI7oT6Wo8f233q1HDzajy4ucYg+0Vftfi2QKTi5P2mUEqufRKJ4aGy7ok6dPmtr4TbfrVf+zKUvFbJMjDIHEhardHWmP2v0eTXU9UAbS0Z3bEdRclP3/b/M8sala66SLS9ir05G+Qkgjz+dquKi/xMCFv0pIdHl89gQ55iY+x8/0pSkeqaqG40dOeecxAvR1osmVpqC1QFthvOIEFYdqfwRodZhPcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wq9Ur4YU67sVxk2niDsgZtNtDNvEGYa0vQvNjNDv+k4=;
 b=kvOQAWMvYXPuBJglD5fglLxo9mCnJ9v0R61VSAO4sC+Nyq8vgliygYHsT8Q5RxEQ2WCSH+/fe4BSoM9EyKp50UUyhFkKXVcQ/Ubr4dU5MSRiydh12E8FPb5MlbM+RM/0hA3RVayplTNYq/JSPa+rVf3AgD9lXMhdDtHz3QPAzFEk/ckY5itgTmMAoUJw2j0EUGbTbOxZyjzGesl0mgAJQsMfe6qZSy+oFzVK33XGsEf9ZKvOgbk2DxnHLlTRRNrUnx+xvYBCAdzFHzwtrKjkNg5WXrI1vr5UYIm1fJA8RDw4RJCboUbCLqWAMeo83Ys0xLZnKCitbZpWCksDvqTtTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB8026.namprd11.prod.outlook.com (2603:10b6:806:2dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 10:27:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8335.011; Wed, 15 Jan 2025
 10:27:28 +0000
Message-ID: <345842c3-f9d9-49bd-8c27-295eb85baf41@intel.com>
Date: Wed, 15 Jan 2025 18:32:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/5] iommufd/selftest: Add coverage for reporting
 max_pasid_log2 via IOMMU_HW_INFO
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"willy@infradead.org" <willy@infradead.org>, "zhangfei.gao@linaro.org"
	<zhangfei.gao@linaro.org>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
 <20241219133534.16422-6-yi.l.liu@intel.com>
 <BN9PR11MB5276F5857A5F0851D6EF6BF68C192@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276F5857A5F0851D6EF6BF68C192@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SN7PR11MB8026:EE_
X-MS-Office365-Filtering-Correlation-Id: fb1d0af7-328e-47ea-8d81-08dd354f363c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bjVYeFpqSDREWmxMcFdHT2t2emtTdFlZQWI5RlVxemZkRk04UU9YM08xY1dl?=
 =?utf-8?B?Vks0YTA5OFB6NDJxR21tNS8rNG1JQ2tOZERaU1h5ZFlQODUzeGVDTWFuVG90?=
 =?utf-8?B?MUdITG82K0hOaXAzeS9YUUs1Tk9wckM2K2NkMHI2UGhuVlJzSXcyRmF0dWo0?=
 =?utf-8?B?MzNaRlhUNFd3Nm5PSHVDeWNDOGNHRHFyWFdlRUVOQTZMNDJHaXdRRzZGcEV1?=
 =?utf-8?B?QjFIQzNoMXFYaW5SNm9LM0dmVDZTU0VVS3FGRCtaOVVTZENsQW83SGt4Y29i?=
 =?utf-8?B?Vk5TMDZVOFlGK3NXSlE0Nmtvb0tIdU9XYkxBMWswWUttcGcralBYN1RiMXJh?=
 =?utf-8?B?RTlxUVA5c2Y4dTBWaTQyVWZFd0Z2WDVBYU16WERYbEhweXV4RUg5Vmp3eU05?=
 =?utf-8?B?QkIzbEhDZ1RhOTQxaWsrb0Q0ZlRsS2JIWStZZHYxSGRpZ3JNUkNvajdOWTFO?=
 =?utf-8?B?WitaVzcrRlNUQW4xTVYvVTVvcHpFZTBEZkNZS0pQNmJRQnUxamM1TkovQlk4?=
 =?utf-8?B?cVZwT1dKUmJ0OEZLRnYrRDhFUVg3ZWpYZXh1V2VkU1hlUWxpejc0RmxaMXE5?=
 =?utf-8?B?ajR3SHQrekNSaVNxRFpKeTBxOHQ2ZDNWZzRGYmhsbEhPdzkxQXBzcWl0QVRj?=
 =?utf-8?B?MmJ5MFBqY2lDNjZmcnl3dXFlNWp0d0NZOHhnRndmRlowcXBjaXU4eTRiWEZl?=
 =?utf-8?B?aWVHN0dzVmhrbHlkL1JVWmI5Tm55K3A0MnhQQnZxclJSbTVIaEVZUXNMWEdR?=
 =?utf-8?B?NnFlWG8xY1B0d2xPZzlhVjV1dlc4eDF6QWQvTnBLcFgvempVNzJoMi9oVUlB?=
 =?utf-8?B?OWh3VVFWK21mOE9FaU5TYTZKOUZuQVd4Yk94cS82TG9KcFkrbVRSMjhac01p?=
 =?utf-8?B?L0dHOWpmWFRmbTJqeDRVM1Q0bUhZTDQ1VlA5dlEwMjh0YlUxajJJQnM4ZXAx?=
 =?utf-8?B?OW83dmpid2E5YXREbG42em5rZEFFbHZGWUpNaUY1bFdsNXZYM0ZTa2VyTi9Y?=
 =?utf-8?B?YllwaUJXWjNuWnliY2NLS0VKckNvK1h6dTB5MXdoUVZheS9KU0dCYm9DVllv?=
 =?utf-8?B?TjhMZGI4ZXR3ZHVjTUY3UkNCV2tzSHVjTTFKU3pTcGp1bmFqQnZXSTlQd1ky?=
 =?utf-8?B?MVY4U1dXRElSbGo0QkVqcHJ4UzN1dU1ScXJwd0F6VmhEYnJoa3FOaGc0aE1W?=
 =?utf-8?B?R01jRm5aKy9SNjF6Yi9Qb0dmVTl3QjBPWVovUmgyN0IrSUpSYW54a3B5K2FI?=
 =?utf-8?B?M0RxTXNrYWxYbVM5K1JORWRoNHdUYzBjTEo4Tm8xS3ZxVWxoMGd2L3VNL3U0?=
 =?utf-8?B?UkFGQ21GTnVBVHpBYlhCR1dyVDZXbDBobWVGRlJVWTFWc05JaUpzN3Q0cjJD?=
 =?utf-8?B?WFNwQitQRHdwZGdDckpaL1RQRERramFmM2MrREdsd1lBaEoydkR4YmxnakJq?=
 =?utf-8?B?OElpYlphS21wSEtEdnJzc1ZEOUh0ZUtkOGpNUlNRand1S2JpQ2RyQWdiS1Na?=
 =?utf-8?B?Z3lmL2hLQkM5ZlJTbVRZd1RWUW5GUElIcXBZRlJxZUNuZUFjR25rMHlIM25K?=
 =?utf-8?B?TWZMQTRFalh4Uzlvb1ViZm9saTJ5UUw4S1h2QzUvNlVhMFczbUNlVU52dnhq?=
 =?utf-8?B?dTRzMncrS1pRbElGbWlaODlFSGJPd1lObCsvSFJUdTBYT2lNaVRzUVFLTGlj?=
 =?utf-8?B?MFRuWEYxaExMQUwrMTVERG9VWUZMT3VYNFAvaXJqRWU5TEltbU5rYzRRWDBm?=
 =?utf-8?B?L1pwZ2FuL3dmbDBHYmdNaVNlOVFhbklEZGpsVVFVMWZPODQreVB5YzZHK2xR?=
 =?utf-8?B?ayt5amtlUEZRanNMZjltUEtnTUtNeTdUYzJWMm8vUW8vc3p5SkNvREdheUdB?=
 =?utf-8?Q?OwlLGSqSmwBs5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGExUGtpTGl4ZTBsR3YvMENVNFYwYUorRUpiQXBMVTdCYm1OZDhINU5LWU1R?=
 =?utf-8?B?aC9KWW9lZWpGbjZtM1I3YnZGS3ZyZVpnSXl5R21idm9ubTB6eUpQQkgzWHBl?=
 =?utf-8?B?VXlXd04yWGx3c0pxOWczYmMxV0QvWHFEenMvU1Rnc0FKYTdySkJ2cVVKT3Jq?=
 =?utf-8?B?WjQzaURFblRtcDVVd1Z6aCtHS2N6QUhPc1NQUmY0d0FtckdGWFhTYVBjeWg5?=
 =?utf-8?B?QTBRNWNmRnBoeXFwdi9lK2NsNXRKTDhTWGhaVDVBOVRQRmswMlhxY2pjZVln?=
 =?utf-8?B?SGlhM1d5aG05d3gyZnBwZ2g1Y3Y1MmM1OTB2cnU5Qjh6SnkrTDNHWFRRYllw?=
 =?utf-8?B?NFF5dXNOcmJicE1hZnUwL20vRzRGSW5JNVUzRCs0OVdteEx6a2YraFo0c3l6?=
 =?utf-8?B?U2xOYkphNW5vRVZ4Vy9OQllOM0FuMUtMaHpCY1VlS1hMYnUrbnNPY0pRTDNr?=
 =?utf-8?B?QWJmc3ZiRmlSTDE4SndORnI3TkVuMHFnRysrcy9KcGlpU2JpdnVERFB2dWp0?=
 =?utf-8?B?aW1idHJvZC83TnZheDR0dlhQZmFDNE1jWkFZclZIQ2gxTVRsamhUK0ZlZ3FZ?=
 =?utf-8?B?VEZMZUo5VmxXOE10Zyt2VnJCUnZKMzdxOEV5Q3YrK2M1NjRYcjRwU1dsZGVp?=
 =?utf-8?B?R05laVQ4eGxQT0p2RktYRkJOcWIrdTVnemRPQmVDZVBVQWZsTFNwWHBuRWEx?=
 =?utf-8?B?MXNYQzE1TUFESy81RkwyRG1FRjgrUnFhRGxqM1RmSDZRbVhtWmZCZElBQVl3?=
 =?utf-8?B?UHJGeWVwK2VBOUE4Vm5qeC9ieHd1d2lXR2Zhc2Vtc2h5cE5JVG83TmtUNG85?=
 =?utf-8?B?MFhyNXkzNnF1MWNJeDhKb2NRM1ErS3BYWGUxYzRVenJ0Nnp3TmJIdStWU1Mx?=
 =?utf-8?B?ODFOQWVJdHdFL016TWJDSmJoeWhyVmdwSGxxSHFQeHBBZnltaDE4Vm9ZREtD?=
 =?utf-8?B?VXpjQzRaMG1PaHVJTjF5ZFJvTXhTSktzSVM5ODRnYktWVkVPUlJLMXRadVFu?=
 =?utf-8?B?bUhLcWFLazJoTWV0NitSOTJjQXV6RHhUOGNBM2RwVGVzaWZXSUpSdEwwRVN0?=
 =?utf-8?B?dUY2ZVk3WmgrUVhsKzZUZWhQbC80S3lIWHdUVnYyTUt5QlR0TFFFVWE2djUz?=
 =?utf-8?B?MWIrRXY2VzB3cVV4eDFKekhzRWNhTVNlM2lvajhPdXIrS3ZVTjk2RUVKVEdi?=
 =?utf-8?B?QWV5NnVtTjFmbFFDbGVTSkk2em5UVU5vSmt6SDFyNWFIR1JwR2VNQVh3cEo1?=
 =?utf-8?B?UWRhdGhVTEZ5eVcwMGVPSHBoV1kzSXF1eTF3WnBPSjB4bHRreHJLdVJKNGFx?=
 =?utf-8?B?UzMxUmNSaVJqVjNuS0h3dVhFcnlRV2dMNWR3blM2REpvU0tpS2VzNzVrdjlM?=
 =?utf-8?B?R0ZJQVZiS0Z5M1A0V0lDQTlqeFJVV1l0eEdaVWRISjZhejZDS2lBU0NXd2dz?=
 =?utf-8?B?dlBmYlhDemdyZUNJd3hmZ295WllmbDl3NGtORUpWVnZSMGIzbnFRM0xxUE9E?=
 =?utf-8?B?aFBZakhET1lQTHpMdnA4bmN0MlF6WHhvbVhTQU81WHNtdDN2YktsblgyTzBM?=
 =?utf-8?B?eXQrRGVKM2wzUmtCK3NISVllbG9TbFlqTDM3RFF2eEdKcWl1UUljWDRHTllk?=
 =?utf-8?B?NHBMYWVITW9qa21uOTEzd0xSeWp0VXlDT294SFNnUUZrZ3QyQ20rMWU4cGRJ?=
 =?utf-8?B?ZnNuS0ZuZDlQSmI5WkV4RlpqMVRXRG9UL1FvNEVCbVJmRGNIbHl5MUtXdm5k?=
 =?utf-8?B?R3l5dThQaksxcVk5cGFyR3dZK0Vqc1h0YW9yRDl1UTVOWXFkWDR6WEVFTHhn?=
 =?utf-8?B?Z1VZNUp3UmJvMVZCaWVZWUxVc3VNZmJLWkw0UlNZOHlYVS9aVjI4bHI2dmJ0?=
 =?utf-8?B?SW50VmtzdUpyUWFUQ3FYZEw0blpLZkl6TWpDZEdZWUl4WEMreFdtenJYenJm?=
 =?utf-8?B?RjFjVU1xN05lcDE3Z0Q5K0FPTnBrQ2JlS2ZrMVp6YVNXanA1YnpoUjR6YjN4?=
 =?utf-8?B?MWFwbkZNemIzaklYandka0xEOUIycHBGOThlb3BBLzBKMHBEWjRvb25TUTlX?=
 =?utf-8?B?QkdYa25QcWMwcTdrZzJkQ1lCYmJyTUljcGlHT2wzSzdUWkZSTU9qdk93elJk?=
 =?utf-8?Q?qyptk42bwuNNzPHVzYpcrsmXe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb1d0af7-328e-47ea-8d81-08dd354f363c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 10:27:28.8237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNNWi1wihjhM3eWxjtyxQ+Ty4XMtKo6NKee2eLvmekCnSP8M/eaQ5ybJ9ikwiliCGHDKk6k1LWq2zG6GDfi+gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8026
X-OriginatorOrg: intel.com

On 2025/1/15 16:16, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, December 19, 2024 9:36 PM
>>
>> @@ -762,6 +773,13 @@ TEST_F(iommufd_ioas, get_hw_info)
>>   		 * the fields within the size range still gets updated.
>>   		 */
>>   		test_cmd_get_hw_info(self->device_id, &buffer_smaller,
>> sizeof(buffer_smaller));
>> +		test_cmd_get_hw_info_pasid(self->device_id, &max_pasid);
>> +		ASSERT_EQ(0, max_pasid);
>> +		if (variant->pasid_capable) {
>> +			test_cmd_get_hw_info_pasid(self->pasid_device_id,
>> +						   &max_pasid);
>> +			ASSERT_EQ(20, max_pasid);
>> +		}
> 
> I didn't' find where in the mock iommu sets max_pasid to 20. Does it
> rely on another patch or did I overlook here?

yes, it is added in another thread.

https://lore.kernel.org/linux-iommu/20241219132746.16193-1-yi.l.liu@intel.com/

-- 
Regards,
Yi Liu

