Return-Path: <kvm+bounces-39224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D30A8A45558
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 07:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5B75177CE6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 06:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AE826773B;
	Wed, 26 Feb 2025 06:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gMKlLCbO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC153596D;
	Wed, 26 Feb 2025 06:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740550498; cv=fail; b=E331otouAneTGFBL6G8ZYs4YVsdiCvMNRgJGmqddSVKld8ney7TY+pUl/KJKrAwUwYcNDyGGiBAYC40500TxqWljJwJsibV/D9tkgTZehR/rfdD8RqPAhWh7tthVwTPfCI1AEqGsmaHlkJFwSTDgZdi70sHZi5MX7Y8RGsY2+HM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740550498; c=relaxed/simple;
	bh=A3qPFEG8ZTAUWAag6YhWRTEEiAL7rQV5QaToYrKHxfA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UxroZyU2fKmSvWqM1Aq1YKE0eZAG5MTM1GCdolj/yZkkNodldd1QEvPYzaMNz5hcSjzWfZmZG44l33h+4hmL5hSJn/H3RbrginzGLxRaUZMPB9Cee6NN5Av1R/E06YuOaEdHLYGaVjPSCp1l7Ku3iGnErvT6dmrd+MW2CZ+xRYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gMKlLCbO; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740550497; x=1772086497;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A3qPFEG8ZTAUWAag6YhWRTEEiAL7rQV5QaToYrKHxfA=;
  b=gMKlLCbOSZRMmoImQ7rwe2zUa1rqW308PqPoiMCXHseTe6GtTF8ynZHh
   hNV2w0b6aj0NKS/MFBx2zcRJ/Qgw/Ahwjij+uj7N26QTqnLQMoAKERm+Y
   UOikk8ww7oPTwlKMzRnWxCkQcXCp7FTOOePqk0NIWBruMWWSlT8/92VjX
   vVBVxo3hnK22P0dj9b85fA4g5sFI+bDQG/dLWCjYa9rGGmeNfr6x0XKt+
   OP1qOw/XYvh3c8gfJGLYs+lI3SAqXs439mmu99smyuet+UVDN1nK8vrh7
   +80TxXXXdQvZZyJBGj7BQ4hmG74ytV8HBAssdoIE1ayd0coa7snusfmjq
   w==;
X-CSE-ConnectionGUID: 1cNOKqKzQ8Gz07z8OJJvAA==
X-CSE-MsgGUID: syIttLzXTjSlHaLe6uVUkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="40618571"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="40618571"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:14:54 -0800
X-CSE-ConnectionGUID: LqbpsaTgSTusEprcUOW5Ag==
X-CSE-MsgGUID: tUofaKIcRNGibmVTZS8gAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="121854437"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:14:54 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 25 Feb 2025 22:14:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 25 Feb 2025 22:14:53 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 25 Feb 2025 22:14:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pMn3U/6PRFK5fUczUgdPRKXLfPhkyx9N1lOq9MwqmyK+GflfG7wEAQvuWm50x4E5A+wuIrN+SG06pFiWSYxdBr360C4MxkSLCjZaCeQs27t0x69gjxstOUZHxfzfE7dRoCxAAvA2dHkwVFEbZTHcVQty3FQWCY6Lgo3LCZ7xCfZiQRMnwFqOEYBYek9Ko4yN5bKAWBE/YoMYXE5lSjzKJK1bKhOFSVOlgafI65KncsO87a7r5WX9gxazZwufQgRambCRZFgY01xBM3G5JEwRlDL2a0XPDPizsMrRjzU2N3h4z7gBZiThthoV9Wmckz3oulv1V9dLb+PEyn6bVvhNwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ih6zF0buwLOWdj6Z5Tu46cKgEAvWhD65i06SVOuLj3E=;
 b=th8S1+OQACiwIufbUpnzVtRoS7gJP+VEyETYVvvOX12p+YtZ7XZvSyQ96g9udDL37XmwbVlCn/GDcCZ8zm1jjh92VhPXrQXU0vq63IhdYjtbnP4dp+JlNbtEtr/E1P6U4bxGisvRUpDA5zEY6iKmJ3MbVbCK/iwslhAcAmbVBEMd6snxt/c3oAgR79LbIvq53oDCikwnQyeosZfYMX0uAwYGCYHnjRhAUenk/G/fOLs8KyQ/eWnsMgdkXzbzCMD4ofO7n6WTKvhbeOaTCE3pZrpRUgg0a9PnNg3xxPEzc4SToyWMJM5mChZi+qZqTiUMiZ+T47rcxhr/YQxBQq3FlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SA2PR11MB5004.namprd11.prod.outlook.com (2603:10b6:806:112::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Wed, 26 Feb
 2025 06:14:51 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8445.017; Wed, 26 Feb 2025
 06:14:51 +0000
Message-ID: <2be4e33d-08e8-4f64-be4c-f485320ab368@intel.com>
Date: Wed, 26 Feb 2025 14:14:41 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/16] KVM: TDX: Implement non-NMI interrupt injection
To: Binbin Wu <binbin.wu@linux.intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <kvm@vger.kernel.org>
CC: <rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<linux-kernel@vger.kernel.org>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
 <20250222014757.897978-5-binbin.wu@linux.intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20250222014757.897978-5-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SA2PR11MB5004:EE_
X-MS-Office365-Filtering-Correlation-Id: a686929c-bb7d-4ef3-0e8b-08dd562ce116
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NHc0WW54dW91WEZPT2VDSkFHVkNXMVU4Wjc1cEpTTTZCdy9vc3JjUC82RkJT?=
 =?utf-8?B?bHd2QWUvTTRwMnQ4eEErWUpZR1A1bTk2NnJ3YnNjUzc0YzgyclUrYkRnZFlR?=
 =?utf-8?B?NklHMkNVNFY1Y2kwYTN1cUFOT05xU0pYNDdKOXF5L2srR3ZZNWhveUVwN3ZR?=
 =?utf-8?B?V04rbzJVeXhCOXpZcjM3bG90dmh3NGZ2YjlMalU4bzdXSEJuRlBMeGdNMjRu?=
 =?utf-8?B?a29yaVR0dWFLbXE4S25nL3QwMjVyclZOaFBUVkcxUVhBdTJLZUZqcDF4dEFu?=
 =?utf-8?B?RHhRaStIVm5jVlhpYnNCT0FpK1RrV2pNRTYvdVRkVWdYNmV2SXNhcVk3dkNl?=
 =?utf-8?B?ajZqTzRMT0hqNDNDK3lJNHJ1TTJpem8zckRvZG1lSVJKblRhd29sd2Voc09I?=
 =?utf-8?B?SmFUUHZtYUlHM0s3UkNCZ3dnWHhwVFNjckZ6RmJKa3ZzUUdVdHFicGZrOTkr?=
 =?utf-8?B?eHcvUE95SDZCRUpSV3JnK3NqanZxYmphMkt5M2tvNVNBbkgwTS8zSDNMVGF6?=
 =?utf-8?B?Y3hMcjB5ZUJxTUZ0cjBrSVBuYXl0TWpMTTI5TGplMkxuWWE5WFgvSGYyaG9F?=
 =?utf-8?B?NFdkZS9JNDlkVDM4ZjcvN2Q1cUJaMitubzJMeTBkekw3aDVSYXppSHI4U255?=
 =?utf-8?B?ZnVsbS9GLzNmVk9zZDJENVpDMkNNV2FHVzZTN21Hb0Z0NkFmaUhEQXFSTjhS?=
 =?utf-8?B?dUFCbjJBeUV6dkwzeHB2eFNIUlJhWWs0dUVEWDM2eWxxei9tTHZadUpCVCtx?=
 =?utf-8?B?Y2VZZnhKdWtCUCs3ZlFXUlh1TWdYeU5lSkdtR2JnQmpoZThKckk3NjJ4cWxh?=
 =?utf-8?B?ZHBzVHRWcFI3bTR5emJST1hFRVNkc2JjSFFjSEtpQWF5RUw1YnhyalRhSFpW?=
 =?utf-8?B?MnZ0cE4vK01pa3FlMEI5Sk5wTVg0N29MeWJoMVBKK3d2RkRwTDFXeTloRUJN?=
 =?utf-8?B?dFZTOWN3OElvL3ltVEJOM1BwbzhPTzVMZE84TkpibXN4SklnV1dqR2YvWWI1?=
 =?utf-8?B?N2hDSnk1OVg3Rm4wNWZRT3lJZzNqblZ1dmFJT0RzamxudzFRcHBKZ1Q2Vmpu?=
 =?utf-8?B?OWtpSTZyNmdMSitIMmJkelBZU2dTN0dOUHdaY3FxL0M1Y3BIK1hRMVpuUG5U?=
 =?utf-8?B?S0NZS3hudXVRTmhKeTNoQy9CVVdxdG04YUFtc05rL3BkUGZsU25LRDJxQ2t5?=
 =?utf-8?B?VVg3NkVwMC9JSXFEMEd1d3IySlZTKzNYeGZON3h1elhQS1EzUTh2Lzl5alpx?=
 =?utf-8?B?eWpwWTdCenovcGVIdCtubjFwZDdiQWlwYWhxbXZjOVliZ2NSbkRMdlppbUpt?=
 =?utf-8?B?RTl2eVBON2tHMjlvZlFzaFFiT3JYdXJneDJhbTBBU0psem51dEdPcE9NKzF4?=
 =?utf-8?B?SXFqM0RoTEc0NlJOTzZJN0JVd2ZBWFpKVWFrbkNrYS9aUE5pdVJJNmswa21a?=
 =?utf-8?B?ZVFkcGJIUHZpakpKWXVHblZqeE1PTVd1RnJ3Q0xxQ0Q3amJJK2lwZjRFQzZM?=
 =?utf-8?B?aFEzZXBGMGZPNzZBZnVYMUFHTXhPVmVuZElwOVM0Sm9STjNYWFVSU3RFcFRK?=
 =?utf-8?B?Vmw4bE4vUlRvZ2l5VEh6S3FSUnZHM2VITHQvd0pEMmxjYklNMWFBNXEzTjh0?=
 =?utf-8?B?SlBUSzBoUklYYmJiaU8rOEI2OEljdnlhUUxOaWs3NnNxSEQvRmREdUFsSU1i?=
 =?utf-8?B?eSsxLzJiZzgybTM1SVJpV3Q0TGY2WnFMQkNjSW85K04rZDZyVXBFVVZvZFlG?=
 =?utf-8?B?N2JyRENibk5jREgrVWh1R0R3SGtsTXVIY1ZKTWc5RHRsZDA1SW9aVGZDd1RG?=
 =?utf-8?B?M2E4MlFDNmhLVVRxcVErL2t0aTNBalpKcWlLM2d5eGtCeURpZTlud3g5NHZx?=
 =?utf-8?Q?GEP9gzJZGZk3B?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEVFVk1JWG5WVjVHeWpGM1FyNnJKdHl6NGx3dEg1L0d2SHJITktNbHladWlB?=
 =?utf-8?B?RU4zZFRPZDJLU1V1SmV5UnJiNjRWMWxDRmFPYmtEMEM2NWYvZURiNzV6eVBn?=
 =?utf-8?B?U2orK2dOZlF5b25JUTNUbXIvOXlmTnZpTWd4Zkp6VFBPZ2xYZVF5TDNuRllL?=
 =?utf-8?B?VGxSM3JQWFpTL3BVZCtOWDIweWh1aWJVY3l4UmgyVGhLK2FyaUFvS2FIblZG?=
 =?utf-8?B?TUZmWGx2a1FqazJUVFFzbG9ocHloUDVNRFp3NmFFUEphWkFHNDEzdFVqaG5P?=
 =?utf-8?B?TjFDN0EzK1ZsVzVJWWh0WGZjdVVqUnJDTEVBbkt1UUlPV3ZTem1BSGNPMnU1?=
 =?utf-8?B?ZDJpV2JUUDE2bldWQnliei9sR0pIQ3ZGano4TzZ2bFBPOXFiVURvOEVkOGZK?=
 =?utf-8?B?VXcreFp6NDJwc2pDaDBzc3NhbU8wS1BycnprUmdnQlZqaDYvbDMwaXVkQTZI?=
 =?utf-8?B?SlpZRnRzQm5ETFA0RlRDWVptYlJ6dlZkU3pKZi90TXFCb3VyZFF1OUJLR0cw?=
 =?utf-8?B?d2FjdVpFcnJSSDA0SkNaaUFlYXJvWmxZNGY2WEw1dS9tRWJ0SGNkNzBZYUhK?=
 =?utf-8?B?WGE4NTMxMlJZV1Fyb3VZcTJpT05iR2U0R0Z0OUZLU2dDemQrck9ObUNCRWZJ?=
 =?utf-8?B?dVBCMUlmZG0yaWNrQi9qbzlnQ0ppNUtnckNXem1XZUZHNXIyQ0I2bVNRTHp1?=
 =?utf-8?B?RGg2QTZOa2tIcVFYNkJLRTJSOHJ2aDgxYzlSV0R6bUNEN2oyV2ZucHE4d3I0?=
 =?utf-8?B?dXB6ZVd6RmlwY3BGOWRvTW9rSVVTTmMrZG9HQ1FlUUppYWpJQUthRVZyc2FB?=
 =?utf-8?B?RGxwaVdSclVLcXBzWnZxYkdyRlNtR1BRV3pvVVY4Rzd5dExVNzMzczh1dkFQ?=
 =?utf-8?B?NnFVUGNsc3VjUGZVRERmckdBV1NCdjdNeGN6UlYxMzR0bldPR1UvUVBJc0tW?=
 =?utf-8?B?NHN4L0pScEMrcEs1OWhpNGg0cC9GZmRja0ZYeFF3SE5BM0JKVkFxQjEvYlFY?=
 =?utf-8?B?V052SVRGWlV0bDZCbEx0YjhDWndibmJVeXdSUTZFWms1aERaZDlMTG9wNTRo?=
 =?utf-8?B?ZEdKOEdHTEJhSGxtdDNsZDVOMXYzUFhVSU0zUThQU0MrVjlMaG1YYkFzMXVR?=
 =?utf-8?B?VkZBeDlyalh3U09aMkFpQWk1d2krRzZzME5XMWsvR1g4c3QvcWk0cEJSNkIz?=
 =?utf-8?B?VnFyNjZQdk5TVmxFSEhQZTVBZlc5NGZ1d0ZEUDB2UmhEdE40MVlYcG5wTWo4?=
 =?utf-8?B?cGZFMVNRVkxsUytIZWJoYmo4aDIycUU0WTZjU1RBWTZvcjRvcGRoSzR3QlU3?=
 =?utf-8?B?S1Q2d09FZzRXdzJLc3p6OU9QNFRYVlhoVCs1c05GQWdpQmVIQ3doM2JMOGpM?=
 =?utf-8?B?MlRibE1DY21sN084VmhTaWRSVG1YdkprVEdYaFJUUnVEZW5zZyt4Z29QSWxJ?=
 =?utf-8?B?aTNyQnJSaEZVMlVCMkx3YVdVUHQ5OE9hMmVFVXRUa1lqTFFSNjdTMkFjOGpU?=
 =?utf-8?B?dEVrTXg5UktWMUlnclZWZy8wSk9HdzcrcjM3RkZpdlRvK0Z3cDQzYUE3aFFD?=
 =?utf-8?B?ZFRkemZuYjVRcEtOZDFON0FtcTVySHAvNjBubkVZTWdJZXl5Ui9sUDBOc2p3?=
 =?utf-8?B?TkRpVnkyVVVEUnRIT1UwNXRrZi9aTVdNcXozWWdVRUJSd0drdXhDSm9oRk1p?=
 =?utf-8?B?MXN6MVArbVZBU05IWmUvSWJLUkc1KzhvWlpodmc3dlV0cEVuanVlNzBUWVZE?=
 =?utf-8?B?L1NFTTVKK05kNFZRZmM3QmFkUHpGd1pKUVo0dHZPbHdOdWthdy93ZWZxZUVZ?=
 =?utf-8?B?Vmc0MEw4b3duZFg3UnhXeXpvdUdpek5DUVF4eDVhdkxhbzdZMStVNEJHTnk2?=
 =?utf-8?B?cFhKcTF6aFhnOVJqRWNzVERkNEpFcDFIdU4zR3U5SmcycHFaa3JsZXZYVWVD?=
 =?utf-8?B?Q1hseDc4SGRvdVByWnM2dklWQUo3Z0hmWWZsQ0VEQVRGaHMwdHMveGlVd010?=
 =?utf-8?B?YXBCMmJ3bXBwVWZrS0ZiMm5DYWh6a1FkS2pJd01oTjZ1RU9FYXJuaU03NS9s?=
 =?utf-8?B?VWRCb080VDN4amZCQ1hqMmhSQkRLTnl0dndIRlJMeEt3RWR5OHk3OXFsWDh3?=
 =?utf-8?B?T0NGUS9sNGJsR2tZTHV6SUQ5NlpjY3A5RVFOQTMzTHpIRUNVZkhkYlFSTGJ6?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a686929c-bb7d-4ef3-0e8b-08dd562ce116
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 06:14:51.2680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kGiazY5U4C/KuuUbNc/9MID0l6PnFgx94Y31qx47Rkrz+x24T2XnA7f3p83RajJVgyLJnrjqyRWSZM6Bc1+gwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5004
X-OriginatorOrg: intel.com



On 2/22/2025 9:47 AM, Binbin Wu wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Implement non-NMI interrupt injection for TDX via posted interrupt.
> 
> As CPU state is protected and APICv is enabled for the TDX guest, TDX
> supports non-NMI interrupt injection only by posted interrupt. Posted
> interrupt descriptors (PIDs) are allocated in shared memory, KVM can
> update them directly.  If target vCPU is in non-root mode, send posted
> interrupt notification to the vCPU and hardware will sync PIR to vIRR
> atomically.  Otherwise, kick it to pick up the interrupt from PID. To
> post pending interrupts in the PID, KVM can generate a self-IPI with
> notification vector prior to TD entry.
> 
> Since the guest status of TD vCPU is protected, assume interrupt is
> always allowed.  Ignore the code path for event injection mechanism or
> LAPIC emulation for TDX.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> TDX interrupts v3:
>  - Fix whitespace (Chao)
>  - Add trace_kvm_apicv_accept_irq() in tdx_deliver_interrupt() to match
>    VMX. (Chao)
> 
> TDX interrupts v2:
> - Rebased due to moving pi_desc to vcpu_vt.
> 
> TDX interrupts v1:
> - Renamed from "KVM: TDX: Implement interrupt injection"
>   to "KVM: TDX: Implement non-NMI interrupt injection"
> - Rewrite changelog.
> - Add a blank line. (Binbin)
> - Split posted interrupt delivery code movement to a separate patch.
> - Split kvm_wait_lapic_expire() out to a separate patch. (Chao)
> - Use __pi_set_sn() to resolve upstream conflicts.
> - Use kvm_x86_call()
> ---
>  arch/x86/kvm/vmx/main.c        | 94 ++++++++++++++++++++++++++++++----
>  arch/x86/kvm/vmx/posted_intr.c |  2 +-
>  arch/x86/kvm/vmx/posted_intr.h |  2 +
>  arch/x86/kvm/vmx/tdx.c         | 24 ++++++++-
>  arch/x86/kvm/vmx/vmx.c         |  8 ---
>  arch/x86/kvm/vmx/x86_ops.h     |  6 +++
>  6 files changed, 117 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 42a62be9a035..312433635bee 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -191,6 +191,34 @@ static int vt_handle_exit(struct kvm_vcpu *vcpu,
>  	return vmx_handle_exit(vcpu, fastpath);
>  }
>  
> +static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
> +{
> +	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
> +
> +	pi_clear_on(pi);
> +	memset(pi->pir, 0, sizeof(pi->pir));
> +}
> +

[..]

> @@ -379,11 +455,11 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
>  	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
>  	.load_eoi_exitmap = vmx_load_eoi_exitmap,
> -	.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
> +	.apicv_pre_state_restore = vt_apicv_pre_state_restore,

[..]

>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2d4185df1581..d4868e3bd9a2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6908,14 +6908,6 @@ void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
>  	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
>  }
>  
> -void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_vt *vt = to_vt(vcpu);
> -
> -	pi_clear_on(&vt->pi_desc);
> -	memset(vt->pi_desc.pir, 0, sizeof(vt->pi_desc.pir));
> -}
> -

We can remove the declaration of vmx_apicv_pre_state_restore() in
x86_ops.h after this change.


