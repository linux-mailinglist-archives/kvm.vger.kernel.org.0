Return-Path: <kvm+bounces-22150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2952293AB60
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 04:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3CA2285453
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 02:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749361BC58;
	Wed, 24 Jul 2024 02:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jV+2ddGl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DA21757E
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 02:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721789260; cv=fail; b=ELOjazA78NFMH7WEE+HjHkf7I8eA1nsVocXryULUtsF37g85LrazMtnWwtUxgcZ6qAuwMsgrAyKyCW3nkfyhWAvs1qPKiw9aLBL1usNwAg+NFEqeqxRgt8jGWk23U6fvG/tEgBjzB39N0F4tWuo2S/StPEXSAAY9eivDlL0/WkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721789260; c=relaxed/simple;
	bh=Hvklg31snTWJZNkoij7aFvXTBr6DdQvtkr1NrXLXRLc=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bhwV7hB/s7tM2RONvoE8YMQrCsfMrzYopSHWPvD8LQo3wvTLrmpCenV/BVEJBUtYfVXjg9PTZjtqiRdSQSsgem3TwYdUqNx2DPWtWJtmpnqHKvcxp+Y4+EVtu1A5KHvKXOEQx/RzmolHDTeQGtjcBmCnyDnNzmDBAFfeeLs9sAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jV+2ddGl; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721789259; x=1753325259;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Hvklg31snTWJZNkoij7aFvXTBr6DdQvtkr1NrXLXRLc=;
  b=jV+2ddGl797ukJ8lk+GP7l7Srlrt+hjBA+rnUpeqawslmfkidC/zcdtn
   TbWLrkJFgGnbqJvUczF2RC02WKXVFlQXLkSGF8ceaksFEcB9kbbzfCmGC
   tIRD/BIRb86jvzYKQFc8iIse15gBf+GGG9mL4vFWHUbBdcy9jqiXyKuQM
   o1iamL9bZ1P2vg1F7kmsh+mgPi3I/qtQ+ynuWozWEQSLBQfC1o7PGKHGB
   N9toBUqNlA7wqIPA0nYgiwwoyKcqELwkgrWnmtt6sJcYsRCtkhTWYcmX+
   cJXbsFIjtus4xxZXALOYEx2qRs7E3t7GPpYLbs/LBZB2LUxG+iwyGcEwy
   w==;
X-CSE-ConnectionGUID: qG53N0y8RjiaCRLargLSVw==
X-CSE-MsgGUID: sVfVX1ZIQBiHGQFHi4YHeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11142"; a="36892665"
X-IronPort-AV: E=Sophos;i="6.09,232,1716274800"; 
   d="scan'208";a="36892665"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2024 19:47:35 -0700
X-CSE-ConnectionGUID: fm0MUwwYSEKquZ3NlZMIsQ==
X-CSE-MsgGUID: vxsfjhOyQq+vS2szQX9MNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,232,1716274800"; 
   d="scan'208";a="52314893"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jul 2024 19:47:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 23 Jul 2024 19:47:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 23 Jul 2024 19:47:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 23 Jul 2024 19:47:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 23 Jul 2024 19:47:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OEEjPFBwkbs5EMjAvzGMh9Sl+d9nSHp5516gPkfLkefD7eaU+TVJ2FcBfn4qWxxlo3v0K+8BHzOUvgxp2m+kuI31GYs5JBF55oBtbTuFKIS7NswOAWczwSYKdqngZ4+ThZtdNcqPF9lq2SRdXE4Sj64fKTf3OymUzFff9C9tkQei/iNG1CIndFx6GsJiNqnzwE5o3HVi8cIksgM887qHQBMXWaYNI/M0vExjPaPqH4rWsnB5fhRF/4v4hkg45jxn+s3/1Tyu2u+dggpWCVL1u5Bbjvl3wkLNDT6XXqO8ooW92uD4dbQDx2IATUMMq8+3i6iPVoK2/9+j0PNsDU/lyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3tsCg10fbnYTGx4ASAm/SazrMCPuaHLHoyBiWE8HQI=;
 b=wRNkL5pyy6A1bTNMp2cogay4KCcogL//cOehBBBGOe7HY8VRldhhWoQTgiR5ufaVYX5VTyWdEP66U6JDh0VDzAkLD5Oubb1hoEKRQ8YRPUqduBwIACRbzNM7CqyMcshB3EYkGFf31xk7fHxPY/LXDn1DPSYoApwYqPHPjZ6ijuAIvzro9ze3dgycZ9ghz/JelQRLCRP9o7mN/6Wq6kLETceglZvNASu4w/eMpmjwyg4D1UnCuU2c+v16LQmTK19MY5Uom4xtPj7n2kb6eGiX3u+sz9CcMbeUNFHpoRSdOM971+gPhj9wen5pzMcSz2s3t/cDwI8f0dShT9kqrx11hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB8178.namprd11.prod.outlook.com (2603:10b6:8:18f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Wed, 24 Jul
 2024 02:47:32 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7784.017; Wed, 24 Jul 2024
 02:47:32 +0000
Message-ID: <034e27df-e67f-410f-93ce-ac7f3d05ded0@intel.com>
Date: Wed, 24 Jul 2024 10:51:44 +0800
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_FW=3A_About_the_patch_=E2=80=9Dhttps=3A//lore=2Eker?=
 =?UTF-8?Q?nel=2Eorg/linux-iommu/20240412082121=2E33382-1-yi=2El=2Eliu=40int?=
 =?UTF-8?Q?el=2Ecom/_=E2=80=9C_for_help?=
To: XueMei Yue <xuemeiyue@petaio.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "joro@8bytes.org"
	<joro@8bytes.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <SJ0PR18MB51863C8625058B9BB35D3EC1D3A82@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <903517d3-7a65-4269-939c-6033d57f2619@intel.com>
 <SJ0PR18MB5186AD98B2B0449BF097333FD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <859fc583-6aca-4311-ad9c-ffbea68c5b17@intel.com>
 <SJ0PR18MB5186B961317770AE36A58A3AD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <SJ0PR18MB5186B961317770AE36A58A3AD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGXP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::32)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM4PR11MB8178:EE_
X-MS-Office365-Filtering-Correlation-Id: 52282cf9-e2b2-49d8-4499-08dcab8af754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020|220923002;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SE9vZlB5MDBYazVibU9IdVE3RHV5Y052MjkzczFEOEp0Z1d2NjBCOXZnSkNW?=
 =?utf-8?B?UWlOandXNFVFMVFvcWhVSmJFM2ZGWjNhNmNBNmJiV0pLcWJYUE5TdWVLRlhZ?=
 =?utf-8?B?b2pUNjF4YlNTUW5uUTU4dDNzNFN4VnpacUJBait4djdQQ3BEMHNDVjFPcTNo?=
 =?utf-8?B?THMrdGlzR2FYRXFxMFFiWVNmS0R5RkhSZXRycGM5V3VIZkJtdGVtcUJLbWpv?=
 =?utf-8?B?eitac1lmMXA4K3RZd0I5NnRjTlF3TTRIRzNBOHM2WE1ndXRrYjg4V3VJZ2dx?=
 =?utf-8?B?TmhyWGkrb0lFcVFBekx5TzB4T3E2Q04vQWtSUW96NlNhdXpmeXN2K0UyMUhr?=
 =?utf-8?B?eUYxQmREcENrc2wvQUdENHpyQWwyUXJMZCtoWWNTb3Z5aGZ3ZjNpdnNob0JL?=
 =?utf-8?B?QWFKeXE3a1BRRmZGNERiZzNicFFwMGlWa1p2dUhQVi91S2tRRDRua3phVUdw?=
 =?utf-8?B?aDY2WmJzQkVDRXZGc2VEOUJCWFAyaEFremhSOTNhUzAwbjhFcDJLbVoya3Z2?=
 =?utf-8?B?elB6d0tBclJUN1VMUlJlSFNBRi84RzcwRjM1L0phR0ZxYjRSSHJVKzZPb2tG?=
 =?utf-8?B?UkxscFl3ak5YZXZ0L05nWGV6NVZJNDAwQ3VDMW9ZUTFwMmQ0TTd4VVJOQStZ?=
 =?utf-8?B?TWxNcUpRK3Z5R3JTSFl3c0RYcUlLTThzM2ZrdXV1bzgzOWlSZUVHelpCWFV4?=
 =?utf-8?B?dTZNdVBZdVNXSWZaQ2FNRGVFZXpGb1VzMFhWb0tyT2Izemt5NzVTZGJHdUYw?=
 =?utf-8?B?cWFvWUcvTWRXSWtob3JUMkgwWEtsRVpiSHJLbTFxdVVJQVFBRnViVWdmcjg1?=
 =?utf-8?B?dkFJemF3bWxWVUFNYkhVNDdXNjJBSituYlZleVdQYlRZRGhTNjd4QUs3WW01?=
 =?utf-8?B?ZVp5YXErbDgvNUdjanloeXpuUE9UeUl2dWxrYWJFdTk1MnBlSjhFZjBFLzZF?=
 =?utf-8?B?YTgrWG1Db041ZE9BbzVYSW1ad0VJQmovdnFTRENoVXdLL2ppUVFvUFlWUkVM?=
 =?utf-8?B?Vk0rZ1A3OTMwSk5DcEp2aG1aQktsdTZLVldYQit0L3cvNzBDYXBIenhlRmtU?=
 =?utf-8?B?TGJ6cG1UWm03RmhhRDdORHdCcDZkUzhtbHdOa0N3M3FybjhHSnVnWS94cTRR?=
 =?utf-8?B?WTUxK1BNdzYyVDRlTUJpcllmWnBpWVk4YUtzVUxQSWtCV1EzN0xCZkFVK3Zl?=
 =?utf-8?B?MVBlSWZqNm93ZENUaklOUzhSZ21UZkdzNDFkRnMrL1E5VU8yVXcvaDVjZFIr?=
 =?utf-8?B?eG9xVS9rc3FBWHlwcFc0RWxRWjVzWlNlczN3SCs1UldnZ3ZGdjhEcUxOWTBv?=
 =?utf-8?B?L1N1THlYaHFldlIvUGFCM3M1cTBRa0NYZjNCb3FwY1FKbVlNVVZlT1Q5VE5F?=
 =?utf-8?B?QXdEV1ZlNWRCcEJCUVFZY1V2OWVBbjNTcFJVYm5IQS95TDI1cUs1ZnBjcW5O?=
 =?utf-8?B?S3BKYlh6UW5CMmFmZm9mbExydU5rbGtFdkNaV2ZLbnlEYkVrc3NRYlF5dVA2?=
 =?utf-8?B?TmVtU0hEaklrMkJuR2V2UFdIVHBWbmxUQmtMUy9TVjdYdWZSZWRyR3VkZzg2?=
 =?utf-8?B?bFg1NXJJaCt4UXk0VFVLbWo0K2QvZ3NWZ1F4c1d2YWVMWVVYMHhMajZrQmtS?=
 =?utf-8?B?WU41Q1JxMjFndzRjQlhSdnFEaWZFOTd1U0hhbVJjVXdlcytjZ1RWZDN1Skt2?=
 =?utf-8?B?YnFtajRxb2l1dGU2ZmowTUJRb3RZTzY4RkJkbU5lc2ZXNERCTFQwaStmUU9X?=
 =?utf-8?B?TDV2ak9uTDArbEFYM1RKY3JrUCtuSnNwc1JUcEhwNkhKNUQ3RDBTOGlYMWpY?=
 =?utf-8?Q?htL8M7Bai6b5x6lkc4vPJleCYhg0p61S9tTJI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020)(220923002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzdlVzRUcE8wV3BFZzNnNUYwN0duOG5CdG5oNlZQWXZoZGw1c0J6cHRwY1hZ?=
 =?utf-8?B?T1A5VytNVHUwdi9TSkV4eERxVDdyYkh3c1pGaFVyMEVIeFplVHJiTnEwMTUw?=
 =?utf-8?B?dFBDMnhSTE5rbG5yQVZxOGRNM1FkRUwzc2JtcmhlSkN5RUh2djhldTNIRzlF?=
 =?utf-8?B?T1BuVEtiMnBrU3doekIwNVBJRFFqTXdIb3pSUnRlN0VMZmhrNkFRWXZIdURo?=
 =?utf-8?B?WDNoaGswWlJVMEFXYTlZYlJHNWNFZlBjck81dUJPMk9aaVRocmwwWE1ib1RY?=
 =?utf-8?B?SC9nRC81dVJVNHhYelljUjFia2FEdGNGNUI2aXlTOFVObUVIelZyNnZVMkF2?=
 =?utf-8?B?WHZycllETTBzakF0V2FjdHJ2T0ZpY1ZTOW1sNDNvWTJZYXRrR3NjZmJKbHNC?=
 =?utf-8?B?NWMxL29RL3labXZtMmpjTkRuUW4wQmdSSCt6T1ZVWmlvU0VHdEdLRXQrMnIr?=
 =?utf-8?B?M0l5TjlTQ3o2RnIxSnQ0a2phbzV1b3Rlck1YNzBNbExDa2NCM0ZNMFBZYm15?=
 =?utf-8?B?Zm5iclIvODhNYW43eWRVNjMxV0xHdHBaR0dkSzFWbEQrcnM5Z0FFb2tuRHNL?=
 =?utf-8?B?OXcrVFZBY0xWdWRxRi9oRnUwQVpxbjA2OTY5ZWg0bnE2b0R4UFFaVlFITlZO?=
 =?utf-8?B?SW9OTDVSOGMyOTd0cjNObjBkQkJ4d2lWQm5jTU93ZWhxUUI5dnIxQ1lvWFJH?=
 =?utf-8?B?Snlmb3VNVzhURGNHMVFsaGpRL1JqZDZzQitxaWExa21NMlJCUzlUNkcxby9a?=
 =?utf-8?B?emVqRXk2SlFSWi9wWkpqQVRwQXpNeXlySlFKb1FOQ1hraGl0dnlqZGlONk9t?=
 =?utf-8?B?Wkh2YTVrMlB2VmpXVzE5eURGZHFwODVrVHVPQ3pENDRDZVNYblVwb0hQWE1O?=
 =?utf-8?B?YUs3QklHZTFWcUEyOWdlNFNvZzRSRHdrOFgwL3F0UU55ZVVmclJqS2VWRnRH?=
 =?utf-8?B?REFQRHV4RmsyL3RRQ0tEWERoa0tWbSt0QS94Smk1MUZYUEtlSlArVEdXazho?=
 =?utf-8?B?UEZYeC9aLzR3UGhlMzlwMmFYRmhLRHphYVBpYmRSbE00aUpkeGhkcXlPbHRD?=
 =?utf-8?B?dGF3YlFMODdNMVMvanNxOFYrYTJKNlFrdWJuaTk5ajI2Wk13SXJKMEVSUkhN?=
 =?utf-8?B?SkhuZTcwY2phbkRDSW1Fb2d1ckNpRkZ2c2JDQXJDOHRTMWxPelkzVlNXV082?=
 =?utf-8?B?WUJhVkFndWd3cGI3UDZ6QTc5dy80dHZPdVh5bmttaU1tWGdINysxOHM4S1Rj?=
 =?utf-8?B?NUxFZ1docENzeVZkeXdjUWNNOGpvS25FYUhaL2wwblRjbm1RVDRLWW9Ya05Q?=
 =?utf-8?B?STRONjVUWllQVG5SNjNFU2xnb1p0SHp1S0dDczUyU2xkdEJTSUlCdHNiUEtR?=
 =?utf-8?B?Qkl4WjlLTXVtNkR5dmpSdVdiMEU1T2RCbVZPZC9CblVvMWtrekZQMnUyNzVP?=
 =?utf-8?B?YW0rbGN1SjVVVUNiVFppenl4M2lXRmNvL2haZ2VNR1BXdTRQSHVZSnQ5Zk5P?=
 =?utf-8?B?QzhuWHZVejBzUVhZblZoNVljOXpUamhIMDNRVGkreUZTYXJSZTdqTjlTcEZw?=
 =?utf-8?B?Qkx2dEc0WXhzeGhDaWJmQUdKU1VVR0dGZnNMNXhYN1BmZzdnNTRqTldGbnRj?=
 =?utf-8?B?blNlckZIblBWdGd6ZzM5STlsSGJhRENSTk5ZeVBtTzJTc2ZVMjFjM3A5a25n?=
 =?utf-8?B?VG1uZXJLaTR1UldCbkg4SWRwMXJFOVducVFpWS9YZTcvNkg0bmI5YjNQeGR0?=
 =?utf-8?B?d0FIdElxT1hNYWhYUklEbHVKc29jbWhLcU1hNXh6NVNnVUdQK0UyNTV2N2tv?=
 =?utf-8?B?RWNnKzBITEdnQWNaWVN4K3hhLzU5VkdKRnA5MHlkdlhIcWo1V1NJbmcrdVlo?=
 =?utf-8?B?MWcxTnJYK2tlMkVpTFpKZHhiUzNZSWdTbFFQbHVzRS9rdU8vUE5aeWhlcTRx?=
 =?utf-8?B?MXNZOXNNMC9tSVFWRkloRHY2UG1hYS9SSndta0J5ZExWMUFiRWowaGNFdjNO?=
 =?utf-8?B?bWRJK0lzcGZOYi9UME9TR1JmblVycjRSZ0hjQjBUT3RQVXpQYis0Qnp5aXRx?=
 =?utf-8?B?anNSSk8vN2U5a2ZLQlRRd25udk9GTkprOWNVWko2aWxXZkRxRjBYMnY1T0hS?=
 =?utf-8?Q?1enfLBq00yXrXQ0UhlQOz1s92?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52282cf9-e2b2-49d8-4499-08dcab8af754
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 02:47:32.6231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qSyI8854DZ0/UvKiHbiSQ7T9tiVDOslNbJj6R2DXrendmBk+EAJJ/K6NJbGkTOMt8d6UHyr6HJZsNOEPpHsnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8178
X-OriginatorOrg: intel.com

On 2024/7/23 14:52, XueMei Yue wrote:
> Hi Yi Liu,
> Thanks for your suggestion!
> we have tested ATS without PASID successfully.
> Now I want use PASID to verify other function.maybe not related to ATS.
> Could you give some suggestion about my example "iommufd0716.cpp", How to make it run successfully via linux user API ?
> Thanks very much !

you need to make the pasid attach path work first. As I mentioned, the AMD
driver does not support it yet.

> -----Original Message-----
> From: Yi Liu <yi.l.liu@intel.com>
> Sent: 2024年7月23日 12:06
> To: XueMei Yue <xuemeiyue@petaio.com>; iommu@lists.linux.dev; alex.williamson@redhat.com; robin.murphy@arm.com; eric.auger@redhat.com; nicolinc@nvidia.com; kvm@vger.kernel.org; chao.p.peng@linux.intel.com; baolu.lu@linux.intel.com; joro@8bytes.org; Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Subject: Re: FW: About the patch ”https://lore.kernel.org/linux-iommu/20240412082121.33382-1-yi.l.liu@intel.com/ “ for help
> 
> CAUTION: This email originated from outside of PetaIO. Do not click on links or open attachments unless you recognize the sender and know that the content is safe.
> 
> 
> On 2024/7/23 11:22, XueMei Yue wrote:
>> Thank you for your reply！
>> My pc has the PASID capability, See the attachment.
> 
> ok.
> 
> BTW. A heads up: you are looping the mailing list, so you'd better use the plain text format and avoid including pictures if it can be expressed by text.
> 
>>    " I don't think the AMD iommu driver has supported the set_dev_pasid callback for the non-SVA domains."
>>      ------ xuemei :  So if I want to use the PASID to test PCIE ATS request messages,could you give some suggestions ? usr SVA domain can solve thie issue ?
> 
> You should not mix ATS with PASID, ATS does not rely on PASID. You should be able to test ATS without PASID. ATS is a performance feature, so if you want to test it in system level, you need a benchmark to do it. Or you can test it in pci transaction level, you would need tools for it then. It's up to you.
> 
> --
> Regards,
> Yi Liu

-- 
Regards,
Yi Liu

