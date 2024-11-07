Return-Path: <kvm+bounces-31062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0942E9BFE9A
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 07:42:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 239051C22513
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 06:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1C5194C6F;
	Thu,  7 Nov 2024 06:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KmgvlhQu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F529194A40
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 06:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730961718; cv=fail; b=TSJdGLL9QgnQK9bQy/F5zfHQb8mLLOqEBDSabAE/ebBFPsLc1+itk5Fbu+ptfKpxm9dOZPdjLgWYxPR9HWT8P6iw1h2+9joKax+wuJF5haq9V9EcJ3D1oOA8+WgFn2qe0oG//gb6Ji+vIKZ8E40bnMaBu9HA2R868xcYK/Kp1wA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730961718; c=relaxed/simple;
	bh=6xnEAeToc6YYfQSC0A2zUIojPdDFr/QYvWfuH/7JlC0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SqdEHkHnWVvVGoV2N8pRD9jvqRUqUQM1yvEzkKY+CwMMJpXQ40YMteOGVm+zEcEfpPP8cqiLkJP1/GlaHFTL3vcAM9mrYhPHQ4QBcuK2b8xjPDeF9s5jmUfC++4NpgRoyoeQ3rbejL+ogZYMkwpyWMTZzNn7j2D/qAXsFZ5MviU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KmgvlhQu; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730961716; x=1762497716;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6xnEAeToc6YYfQSC0A2zUIojPdDFr/QYvWfuH/7JlC0=;
  b=KmgvlhQuh8hHnrhf5BziyyyOv/veHTeIzwADtyo2PJl5jLzy6PUTM2OC
   cuWlrfIw58RKL+7TQiGG7Xe12ARkopYnO0DkGTfrQbDlnrw7yL3y+Zd/N
   W+Oj54zUEMOWsgSZJSjDckE8CCNn8znqVym6bKwRSbGCph5pTT8g6bYhN
   GhcobvIv0MeGKjhfoT7yngA0T37ml/wAKcyCvzxhOw7Y5f+u5diaizHSm
   bkX8NsHdk3Fhu6+5zvWbxqH55wCsllfbi+Y21/NPNtFiRAttdl4CPhlFW
   642dM7rflEmiACJNBcK/9c3ctWis9Loa2xMKLrHCNnZbMJGlsormHqYKY
   A==;
X-CSE-ConnectionGUID: nGZX1rCWSROmN2qAJ79+EQ==
X-CSE-MsgGUID: iisoFpfbTz2fOrQAr60yQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="30212098"
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="30212098"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 22:41:55 -0800
X-CSE-ConnectionGUID: jzd1sAFVSrmIXXDoioHS3g==
X-CSE-MsgGUID: 0hmGNjuoQYy1AE03jOPFqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="89572230"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 22:41:55 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 22:41:55 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 22:41:55 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 22:41:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gzY4VXK0Ns7FF/b+EImMv2+a1l+jydg4XCgfl0G+Ml+7/Y8nl97Avcs2dU8WOK6HAS0jGwEzbz5HhRGi580ow+UuRHhfb/SaP3sG8ulpFf6M/kC45LfMh5FJvZhy4/10irRgU+gZmKotQtzSh1nBFJfN841n6iL2Oj4JwWakv/YSsyICvSE2sr8KAKmNpGgmX3Ao99mYIs2BpHtmFgdNeZx/Rr79bsoqrNnJjyxjcvSHe6VtHFqdYlLJioetnYGbbuWO/wf4z4Iwvzpb+fzCWTQgf+bGgckefHcvwpSkC2rHcAJpaz6AbQ0jmAnuLm2EYToxWFHiPbbSQUIMvErmFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naDdxnD3xe/HSuMoxaejM2BThgdzJkNmfLSI9UlgMLs=;
 b=maOBUS77FROxpaxASrH+gyzZMDRcbX46HQeIqaeqA/qOc3Pp72pOWWy9ll5wXwapQZXffr22EL4YiyaAeUhEOG+jZ0YQ/AQjFEi79VNQvQFMv6it7d9I45FQY31I+u4yWlZI6VUc1PXOBLFOYWqpzoR90JE/94r4Z85FY0hQ0UJH4gd5ZDWqwSUlaGEqCzM5wfyR+3mPN+0XEHn+FHPqk1F2es411ARGbhRG42HaIjCG3wm/35YjQEF16DQS+AXY3143Qs+3/1s4J1LfJfsFUlqZqF8aAUGnUSV74QeN8TFH2mg8Fx0vvUhDHB39V99FvVb6AzwC5zPkBlLMvr3+fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6353.namprd11.prod.outlook.com (2603:10b6:510:1ff::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 06:41:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 06:41:52 +0000
Message-ID: <7d4cfaef-0b3e-449b-bda3-31e3eb8ab300@intel.com>
Date: Thu, 7 Nov 2024 14:46:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/13] iommu/vt-d: Add pasid replace helpers
To: "Tian, Kevin" <kevin.tian@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"willy@infradead.org" <willy@infradead.org>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
 <20241106154606.9564-5-yi.l.liu@intel.com>
 <268b3ac1-2ccf-4489-9358-889f01216b59@linux.intel.com>
 <8de3aafe-af94-493f-ab62-ef3e086c54da@intel.com>
 <BN9PR11MB5276EEA35FBEB68E4172F1958C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276EEA35FBEB68E4172F1958C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0023.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB6353:EE_
X-MS-Office365-Filtering-Correlation-Id: e0777b50-23cf-4913-6608-08dcfef74348
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ODBGZmxYdkZYaXdWYnhld3lvemFsdDNWMlBzYXFpM0YvNkhlNHNWbnM2SGh5?=
 =?utf-8?B?ZGdoRjhkVGdVRCtLNGUvcUtJRTFpSytmLzFTRDJYblFnckFIKzV1blJVU05p?=
 =?utf-8?B?c2Z6YUUzb3I5aGQycWVJNkJMbkFGSEF2Sm03eGpXeHkyTURWSE1tN1hKbTdr?=
 =?utf-8?B?dDkzVzFrcTNlWU81WEFyazZrRllFT3ZVUmc4UUlXRXNHb0FqUnh6cjg4Z1g5?=
 =?utf-8?B?TVg5YUpUL2V2QmltazZpZ3NPd3JOcG93cFRtQzJwbVBoWEwxdmNJdnhKN01E?=
 =?utf-8?B?RFowWDVvM3NWVmRQbmdNOEg3cTNXaDZpN054UGRWODhwZmdHM1FDZll5dWsr?=
 =?utf-8?B?RXhtQW4vdHBIa000N05kTHZia1RYK3FWa2hPdkR6cUd4ajdXS2dNMHg2eTly?=
 =?utf-8?B?SFROM2xxTEtxUTBRUjZxK1hTRjFMU2p6S09IcC9Sdk85ekhkdVZNZUpzejdV?=
 =?utf-8?B?RE5aeUFQWVQ3cnhjL3hwU0daNlZHTGlvaHF5U1FiZmkzS1dqclJtOE1td280?=
 =?utf-8?B?TzBOeTcxZ3FUUmdyTHVySE1tMFRhbmNZOWxwd2loVzVhc21FZjlrTDdYMGJV?=
 =?utf-8?B?NGRRSEhLYmxvUmlUVTZ4c1BPa2kxRTg2emE0SjYrOFpUbjRQK1ppR29YcWZ0?=
 =?utf-8?B?SHdUdWRRRitMV3VCaUN6SE1HemloWkRGdTErd25pNUxRTjBDa1BBcW1reldY?=
 =?utf-8?B?YXZwdU5nNC9MU01mT1E3T0NQYWYvWDJUQjNkVWJQQXk4Z2Z5K01FTEJlZ3Fv?=
 =?utf-8?B?NnFMU3R3M3F2MDRPU25MQzdpVEFPWGd5Z1k2RHRCdEJnaGRQaDh1RmNLYmNV?=
 =?utf-8?B?cVhMTEU2N3RSeXRHZjNwY2RSMmZIa2dPd0swbVd1UU83cHBYYlB1dnArVVhB?=
 =?utf-8?B?Q3FtRXlsQmZRbm05STJxOENSWXd6a3BldGVEYlQyY0ZVWlBDZm1SSnpSdEJV?=
 =?utf-8?B?THdpNnFoZFQwVWtuSmtqM0taSmxsSmtUeTZVWml3MWZnRU9aNkJJa0FmNHN3?=
 =?utf-8?B?UE9xOVhuR3FuUGY0WHM4eloxS1Q1Uk1yWW5xdEc4SnpUc2RmeXFtMmxZS1VK?=
 =?utf-8?B?Rm5jTElhWGNteGJnQzJSRmpmYjlkVUIvRjJyTDlRMHFPeG84VGQzUngwN1NU?=
 =?utf-8?B?aG5Fdk1iK3VqeWl5ODFLZjR6cVAreFRwSTdHVjBqYnJqc0NiRlgyQm91Wlls?=
 =?utf-8?B?UW9YSGxxOERwZnlnSDBFM2w5OUcyd2xIQmFQcG9RUzlvczNoYUJHekJkSUVz?=
 =?utf-8?B?ZHM3SW5yRnA2aWtMUVhZcFBoRFg3SkVqc0h4RmR1K25BNGpqR3A3Sm5PV0RU?=
 =?utf-8?B?MDZ1R1RiaGRrVFdBY0pJZ2tsRzFzQzBoQmdLU0hEWVAwNUJidURSVXZJekp5?=
 =?utf-8?B?QkRSK0h2V01JU0JNZnR1cUJtM0N2cjY0YWpwVzBVMWhwUVlpR2RaQVFUWE1u?=
 =?utf-8?B?cytvSklpSDF0eWJISTVkeUtYQ1hnMWdENWdvL1hpdHJiTlZrTTNMTVFVdnJD?=
 =?utf-8?B?eU4vQWpXVnJmYmtxYm1sSmorKzN2a2Y3T3BlaVZwVGJWMTJ5Zm5EcW5PNURK?=
 =?utf-8?B?VFRlZC9EOWt1SkxPTFpxdG92clJMZllKUDRzM1JtcEVqY3BmSEVpS1RVVzlH?=
 =?utf-8?B?T0xEcXkwZ2Y5U3ptRDd0TE9DMUZHaXdHeGgrWHNnZnpZK2dabFRFNmpnWHpi?=
 =?utf-8?B?MkxqV1NHak1yWDlZbHFlM3hZVGliTVlNeGx1QUE5d0RkMGlrRERudzJWTW5P?=
 =?utf-8?Q?GSrYVSPuka52r7wgLc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2ZPVGRmNmxYUWhWeFJZeHB6K3lkYUxqSlVROW5jRWNLQ3pSVTg1ckhxdHlX?=
 =?utf-8?B?S1JuczdMOWJJYjBVdFV5aTg4YW16ckp2OEYxS05mZGloaXZ3SUJ2ZGlsZXp3?=
 =?utf-8?B?SG1XekhZL3Y4aC9xK2pVTEtqU25Hb1lhVE1FdUNyV3ZmajVLWFA0MEtzY3lh?=
 =?utf-8?B?dUxLM2piTm43R3dVeStZcTkvZUJqNW5JUk8xcmtTSjZ5OFRLSldWc1hrR0RY?=
 =?utf-8?B?QXlaQlh4SU9aMHFnQURSNUVjbk9WdWdWS2hRRHNDRVlpQUg1U28rdSsvbE9x?=
 =?utf-8?B?d3VDOHZadjNoK0VybE5rUFdaNklOUHFjdDhkS0Nab0cvQXgvcUpMQmlSdHBs?=
 =?utf-8?B?RzB2RXhnMmlNUjFzbmIzQmNmR1d1dVl1aDR5Z3RJazg3SFhuOFNESnRwMmlv?=
 =?utf-8?B?N0p6ZjdtNENuL3l3S1hiL0hMeXg0STVjMFFJcm9NSVljbVlkZWZPMlloL2k2?=
 =?utf-8?B?Y3hhTDJzQlJNR0FmNTRyUDBFNC9SNDBKQlVIaFFsREpmSHZTQ3U0MW12VWRq?=
 =?utf-8?B?ZytvNWlqMnYvemRjcWhHT0plVWlvUmcwTEp5SHlOK1VKa1ZkQWVXeXpBMGMw?=
 =?utf-8?B?K0pDeVVjbWNvaXU1M0Z6ZTFEcmxGQklOczJGblp6bnYzZ2llQjcrcDlOMk5P?=
 =?utf-8?B?NnhKeHg4QjJCcXVRaUY5VWxmN3dHcEc5TzZ5TjQzSGZ0cFdMQkh0OVpZa3N5?=
 =?utf-8?B?ZUJ1TzEzZ1VmR1RvNXlHL0xEZmd0bU1xNi8yVG9SOWYwRk1rMnI1Ky84am5E?=
 =?utf-8?B?dTBuZ0R5TEg2MUNIUDhWWnlOblVNK25FQ3c4L2pvb3g0TWNQU3N4U0RzQkY1?=
 =?utf-8?B?RWxOTmZCZndreXkrMlh1ZS84QjdHR3A1VytDZzU4SWZEYnZ3bjZzSmZYT3Ev?=
 =?utf-8?B?SnVUcm5xLzZOeENMcXFqWURxMVRFcEYvVWttR2VsZU9rMFhPV052L0R0eWdY?=
 =?utf-8?B?UXJFZXlNSVRhY2tEc0d3NFhBdWFBRUJYMTYvdVh3cU1mOUk2My9UMklwY1V4?=
 =?utf-8?B?SytSc3lvUzRGdVd0dmNsM0dzb0pXT1l2Y0lCdWJhWDhOKzZWUHJETzJwOTNu?=
 =?utf-8?B?amNYMXFhdllyVGtyd09kWDZnelk5eFMxQndpdUhFc1pBU1FxazBjQlJseWdt?=
 =?utf-8?B?NXBYaXBSVTl6YUxRcGp1QTlIeUNmWVEybENaRjk1MVVDRnJkeFNMY1pzMnFN?=
 =?utf-8?B?MXJzUVhQMFhXVGs3NEJoZE1DSUk2WS9mZy84N3hBUDZHUUIyOTM0WnRFNmYr?=
 =?utf-8?B?Ny82d21qN0xvOW5iUnozbnhyNHBsM2sxSnBJVEtzMTlRTVFQeW5ZUG1CbWdD?=
 =?utf-8?B?aTJXZ2V4Y3V6RmJCS2Qzb0k3U3pWcHpMUHVrNTFIQkRSSDdlaGk5WWljb3Ay?=
 =?utf-8?B?Q0VJRU9QdXBZbVh0OEVGYyt3eUNIUVRtQmJBNTJzVERnU3pnZXZDOTJleGJz?=
 =?utf-8?B?WXRRUXFsQXJkSGQ1c29raUZXR3FRM1dCVHp1TW9pZEtZdmZOT0tUVnQ5UElJ?=
 =?utf-8?B?WnZzNzYwZlVFVmlPaDRZTkthY1R3R1NuQkN3cVRGay9sUnRkRVpBRTg2UTQz?=
 =?utf-8?B?azAvYXVqUVFzNFpHZllXemUzQzQ0TERmeDVGbUJQMVNOb0pmVmtpdUZjS0Y2?=
 =?utf-8?B?Wm1hWXdtbUVjcXJVQk51aE4yYU8wVitIN29hUVJTNHVZb1ZhdUhvNHA2L29n?=
 =?utf-8?B?RjJvcmx5eExTeVpRNENuRyswV1VnMjZwRmZtOEJSVnQya1RXV3hubUtHd2ho?=
 =?utf-8?B?M2xNUlRRVkZHRFc4bWw2cnRDWHhiK3Z5dmZQMWdLcGxtVDVSZGkvSytZNEVn?=
 =?utf-8?B?YXptcThLcnB3MXlnRlZXTmdyVE5GaGkzbkc3V0U2UWRoRFA1VWtlamtrRklh?=
 =?utf-8?B?aHRJb0RuR2g0Zm8zSjZoZXdtWXRmVDRHYW5iZzhJVk1VUlJ3N1RNNTM2YktN?=
 =?utf-8?B?U285cGNaUnNlN1A0M0krNjZGRkZ3Uk9aS08vaHRnQkxoL0o1TWlOWnAxeElQ?=
 =?utf-8?B?aTdrS0hLTGlSOHFjaCtFakVpWkNKZXM3dWpqMkNQM3dwTFBpOFJncnJva0hT?=
 =?utf-8?B?ZUlwcmZST1M3Z3JCbSszZExXRjUxM0pxQ3VrdUxYV2Fad1pPUXhuNXBHT0Fj?=
 =?utf-8?Q?MdarfPdDvtKveNANmxelaebEw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0777b50-23cf-4913-6608-08dcfef74348
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 06:41:52.2478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zelpjUp0nGmb45XQY7mIVLDKBI19/UvnwZXbjkaV7lf4MTTQchyoMtRkvkclyOKj+kIXu2Kx+lYAIcgZY5ay6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6353
X-OriginatorOrg: intel.com

On 2024/11/7 13:46, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, November 7, 2024 12:21 PM
>>
>> On 2024/11/7 10:52, Baolu Lu wrote:
>>> On 11/6/24 23:45, Yi Liu wrote:
>>>> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
>>>> +                    struct device *dev, pgd_t *pgd,
>>>> +                    u32 pasid, u16 did, u16 old_did,
>>>> +                    int flags)
>>>> +{
>>>> +    struct pasid_entry *pte;
>>>> +
>>>> +    if (!ecap_flts(iommu->ecap)) {
>>>> +        pr_err("No first level translation support on %s\n",
>>>> +               iommu->name);
>>>> +        return -EINVAL;
>>>> +    }
>>>> +
>>>> +    if ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)) {
>>>> +        pr_err("No 5-level paging support for first-level on %s\n",
>>>> +               iommu->name);
>>>> +        return -EINVAL;
>>>> +    }
>>>> +
>>>> +    spin_lock(&iommu->lock);
>>>> +    pte = intel_pasid_get_entry(dev, pasid);
>>>> +    if (!pte) {
>>>> +        spin_unlock(&iommu->lock);
>>>> +        return -ENODEV;
>>>> +    }
>>>> +
>>>> +    if (!pasid_pte_is_present(pte)) {
>>>> +        spin_unlock(&iommu->lock);
>>>> +        return -EINVAL;
>>>> +    }
>>>> +
>>>> +    WARN_ON(old_did != pasid_get_domain_id(pte));
>>>> +
>>>> +    pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
>>>> +    spin_unlock(&iommu->lock);
>>>> +
>>>> +    intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
>>>> +    intel_iommu_drain_pasid_prq(dev, pasid);
>>>> +
>>>> +    return 0;
>>>> +}
>>>
>>> pasid_pte_config_first_level() causes the pasid entry to transition from
>>> present to non-present and then to present. In this case, calling
>>> intel_pasid_flush_present() is not accurate, as it is only intended for
>>> pasid entries transitioning from present to present, according to the
>>> specification.
>>>
>>> It's recommended to move pasid_clear_entry(pte) and
>>> pasid_set_present(pte) out to the caller, so ...
>>>
>>> For setup case (pasid from non-present to present):
>>>
>>> - pasid_clear_entry(pte)
>>> - pasid_pte_config_first_level(pte)
>>> - pasid_set_present(pte)
>>> - cache invalidations
>>>
>>> For replace case (pasid from present to present)
>>>
>>> - pasid_pte_config_first_level(pte)
>>> - cache invalidations
>>>
>>> The same applies to other types of setup and replace.
>>
>> hmmm. Here is the reason I did it in the way of this patch:
>> 1) pasid_clear_entry() can clear all the fields that are not supposed to
>>      be used by the new domain. For example, converting a nested domain to
>> SS
>>      only domain, if no pasid_clear_entry() then the FSPTR would be there.
>>      Although spec seems not enforce it, it might be good to clear it.
>> 2) We don't support atomic replace yet, so the whole pasid entry transition
>>      is not done in one shot, so it looks to be ok to do this stepping
>>      transition.
>> 3) It seems to be even worse if keep the Present bit during the transition.
>>      The pasid entry might be broken while the Present bit indicates this is
>>      a valid pasid entry. Say if there is in-flight DMA, the result may be
>>      unpredictable.
>>
>> Based on the above, I chose the current way. But I admit if we are going to
>> support atomic replace, then we should refactor a bit. I believe at that
>> time we need to construct the new pasid entry first and try to exchange it
>> to the pasid table. I can see some transition can be done in that way as we
>> can do atomic exchange with 128bits. thoughts? :)
>>
> 
> yes 128bit cmpxchg is necessary to support atomic replacement.
> 
> Actually vt-d spec clearly says so e.g. SSPTPTR/DID must be updated
> together in a present entry to not break in-flight DMA.
> 
> but... your current way (clear entry then update it) also break in-flight
> DMA. So let's admit that as the 1st step it's not aimed to support
> atomic replacement. With that Baolu's suggestion makes more sense
> toward future extension with less refactoring required (otherwise
> you should not use intel_pasid_flush_present() then the earlier
> refactoring for that helper is also meaningless).

I see. The pasid entry might have some filed that is not supposed to be
used after replacement. Should we have a comment about it?

-- 
Regards,
Yi Liu

