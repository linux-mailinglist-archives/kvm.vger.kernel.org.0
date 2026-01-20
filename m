Return-Path: <kvm+bounces-68653-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CH8GHbP+b2mUUgAAu9opvQ
	(envelope-from <kvm+bounces-68653-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:16:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EFCE4CD4F
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 40FC772E7C9
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 20:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4E244CF5D;
	Tue, 20 Jan 2026 20:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YnvMcGx1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4030244A725;
	Tue, 20 Jan 2026 20:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768942257; cv=fail; b=Y0Z+5CIbbcqXLucubYt9Ox/rhy6/jBiHxbJZkaxn7XxNvbvkUNkAPaF4tmUBBKFwz9CpBsvj5LnjewUFF7TL2e/RRtrmkrCIqZBF9TcuMoa3GPVM3IfJf4t3pMjZvLxXobAP0Jo+gzzfw0Ter6iSUq39SzscrOanj6bnOH7Y0kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768942257; c=relaxed/simple;
	bh=QL+B+ZDcuMRMazBTVuucteMB+uZ/Ti8haV8sGvRhLQ0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s2Xr/nYS6jwvlRemfln5V8b7atmm8Lmq9p1EpYWYmlOYh1OkYVy+e7eE4z3S//AHbTLKC5B6X6vBph0w5TmYvOLOBMj6jZl1z8MJOEDjHjzh3Bb9MPeO1incQSqgvysguRUcENVhBKzwPLXr+3ORcxj2zxvrrydQe0XVIno9rAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YnvMcGx1; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768942255; x=1800478255;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QL+B+ZDcuMRMazBTVuucteMB+uZ/Ti8haV8sGvRhLQ0=;
  b=YnvMcGx1X0iZBOqIo6gSfsZ2yvU18uvgGgBo2sDj2XhkzdqKkHx+fJf6
   PXNsLvR5bQTmV01OXbdWuNw6qhAB/UswP+hXp0BsbHT6KHKqsmqIW2Xoz
   utSVVA7Fz8DVKvgvNigP68uRZ161YJx2xKadOGpXFblWrmUiXq0pcZTMZ
   JDtY/vIzxSzDd4t8A8yl65jrGJEjd3AtjLLkIdAH+62POZ8FOnjUbJnPD
   CVZIF3cGarKDFPRJ+ivJvDMnizBtCf1W6lk5U5+s91UPc4WzTnVLhG/DV
   5YVAsillesok6i4EFd+B/4fJt7JdFvFjbuOGcLRpZgb6uPjqyhlaUr3R0
   w==;
X-CSE-ConnectionGUID: aQfT1IonSnqt/WEDu4iKvA==
X-CSE-MsgGUID: sVY3ha1JSdqGFK2TAsThqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="70135902"
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="70135902"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 12:50:54 -0800
X-CSE-ConnectionGUID: 5rkqnHVQRtOdR23cuuNCZA==
X-CSE-MsgGUID: eQE66rb4R/yFUNnnDlmWlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="206567179"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 12:50:54 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 12:50:53 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 12:50:53 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.67)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 12:50:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=spUDv2oGjhgvHlifswzB/ANm/isPhIGbt3DRuZYd8CJ5irIJ8dcEG7yM/u6fJZ407Y1qLdzxJG3wWdAUrsa6/6tt8+4woQFN6ACs+BepjSI8B0AaTqf6y7JZq9sNZ2bmht7AjvgW861v7rwzOrbPvGOVdqmeowZjmtnvQKKB+FaanD6He0CGo1ZqO8HoxIO1iHmqvfivkEbUk0eEYRnuDF496Z4n1Hu2vEZlYEWIMqgvwSktUX0DEpbANypZ+0Vs9AifWQ4XgdPLBejrC1oDnJJbjDfFhuCFK8QA8PrDucnrINCDQyHyfbKi3Mk9Kgy6jJSW60C4xa2BoC3oA25pmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nl+zzXU8ydv+wK5X+De8pHVgj8pHZNSb2wswL98H07g=;
 b=DMUgWvFKsO+Kd8TXUZZdgsvnuV9amLXrgYAwxc8q0wILDsFo0OZtTEbLfbvFub02LpiLpim1asS28swBBxVhGAXTKiUbGOHu4V32jAk8dh3C/bHrudvMs8MVDY4xPNH/dVO8bIhM/lDQRSQKtIDdBpIrc828hvsTgSvJ+4Euk0HXZ4xxtU2Up7ylv8nyr8wAMmoL8D1EqKoysP1ekFE/3XifsI2wR2BcuPRHwmn+bEIZep7sSKniQV3qzafYr6wkARGZGzihZwpzSkDJn0VkLNqE2lCtxi3wXW5tZxkFCZfdlzIZ/Q9mWx496yVOOuhBVGnije3L3bSJ/sDN/Jf9Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 MW3PR11MB4633.namprd11.prod.outlook.com (2603:10b6:303:5b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.12; Tue, 20 Jan 2026 20:50:51 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84%3]) with mapi id 15.20.9542.008; Tue, 20 Jan 2026
 20:50:51 +0000
Message-ID: <48bc5534-05f0-4d5f-ae21-4ee7f7a15cad@intel.com>
Date: Tue, 20 Jan 2026 12:50:49 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/16] KVM: x86: Expose APX foundational feature bit to
 guests
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>, "Fang,
 Peter" <peter.fang@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
 <20260112235408.168200-15-chang.seok.bae@intel.com>
 <2dd73d71-ae88-4b17-8229-2cebecca7782@intel.com>
 <ecde45c32b56b4954d2220b8686effd6622866cb.camel@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <ecde45c32b56b4954d2220b8686effd6622866cb.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0081.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::26) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|MW3PR11MB4633:EE_
X-MS-Office365-Filtering-Correlation-Id: a776931d-8cf5-4e5a-1eee-08de5865988c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VEVQRkZ5NktjaytyNEplRnYrTG96ZExmNXhHRG14Y0VqL0V6RnYveEVZdUdq?=
 =?utf-8?B?Skw5WjR3dlVpN3FicnprMHlURDJiMlpqcVQzQk85QjJxOHJZTytNL1NxQlFp?=
 =?utf-8?B?eUhjek5KeTNnWlRaSnUwdFRQUmNxMDIrR0pPZTYzc0lzU0dKOWFMWmx4NEVY?=
 =?utf-8?B?N3RpNmJMME1vSXZ6R1VVaDRHS2FLelU4UE1xZ1lLbURpM3hrRjkxdHhLakg4?=
 =?utf-8?B?aUpzeDQxb0lVS1hDNGc5UUhsa3VJc0hoWHBtc1RJWDdBeXpxd1lhc3hWaVhJ?=
 =?utf-8?B?a1FLSlpEenRTZHltc05HUEowM3ZxWjJwL0tvdDR0VHJDYnQ1SHpoWDhRUTd6?=
 =?utf-8?B?OXdXVDRxQ3lqNGk5QVdKOFFIbm5XMytsYjJuSkUwak9QMUZZbE5jUjM1MXJs?=
 =?utf-8?B?Vy9WMVFTVTFNSHZQYkdTYzFuZXpocWs1VDJ5NkhDSnZYR2YzNHl0MkF6cjBr?=
 =?utf-8?B?WmRvVm43SkZ5V2l2aTdCTTdUQ0lCazBjTEsyKzZvckxicWdQaWZyZlF1cjg4?=
 =?utf-8?B?VE5TM21MTCt6Q3MwVmV5Tkl3dVhuVjdTMmdlK21zUmkweWIyMWhFMlRFS1lL?=
 =?utf-8?B?cnVyeU9sKzJXMEFtVTQ3a0pXcm9Oc3ZPNnlsdytHbXhCL1I5c2ZHQmhXT1I3?=
 =?utf-8?B?UENvZlppeFV2OGNpMFZxZDJjcHVTbjhEaU1wRzNDWGNQSkF6MkM3dmoxampC?=
 =?utf-8?B?WUprSzJ5ZTR3L2ppcDIyeHgrOXJJZzViNjBYOW8yOHppYi9jU1dlcHcwVzk0?=
 =?utf-8?B?R2ttTXAyR1BBb2FxWVg5Nm0zdjFudWJZd2FjZVNob2VnVmFJbGEyejlzZGZp?=
 =?utf-8?B?eXc5MXZ2Rk0yNVVUa0pRVm05MWVrVTNFUkFBdVhjOUtUWGpZZmpoTEpDWHVm?=
 =?utf-8?B?ZGZBUk03SEs1SlpNb2tuOEFtQ1lVQzl3d1M4WWdmeXpjNFZpRWM3UXBNeUhk?=
 =?utf-8?B?OFJaTnAyd1FieTlnclNZak9kcnN2YUpLMXpIRzYzbmFDTXpndGJqVnRncVBu?=
 =?utf-8?B?djd0V2o5U2FhcnJQNUYyemQrQ09la1NWUmJ3TTRsbG1RUXV2UUxPeGdidlov?=
 =?utf-8?B?N2lhTFdveVBVdWlESmlrM3V3VlFxMU40ZjE1ZTRaeEYvNXBkS0ZXOWQ3WVJw?=
 =?utf-8?B?a0hPYzZNWXhsUnBWVTBkVkdkdEZLdDJYU2QyNjZweTJkdE5ZL05xU3JHNG52?=
 =?utf-8?B?N0dhUk1UUExSQ3ZkaW9pYkFvZFdvSEI1Tyt5QlAvd3dYQkdSSzY5M3FGOWQ5?=
 =?utf-8?B?SERMczNUcWVYZnlRU0srNGxEdmJ3SXgwd08xYkNIZTF6WXdGc3duR1NmRHUx?=
 =?utf-8?B?dmFWZDY2a3k0bGJCQTdLNU1aOUJVZDUxRFVkRVBkQXRja1VxdG1ieHlxT1Bu?=
 =?utf-8?B?c0taQjl0aHFicjMreFBHYkYyZ0JIeE4veW11V1hqS29hMG5NUHg2bmxKM0Ry?=
 =?utf-8?B?eHFLb0NDRHV4Tk5XVGUrT0VVVjFtc3gwejZPVmVwNXNlN2lpa3ZCVGlEMEdD?=
 =?utf-8?B?ZkhTazlkZ2dYWDV1T2Q4czVlR2VzVmZGVGRJaENZR1NjRFVLUzdjRUN6akF6?=
 =?utf-8?B?Y3JZV3g5bUVpS2VMM2s3VWtpbE5TaGpEaXZ4WWdjQVN4QlRqRE0zdjg0aEVr?=
 =?utf-8?B?L2N6S0JrNzNSRkl1eVNFdUFJeVluRjkwZERIdkxWNC9uY3VwWnVxV2NZUlp5?=
 =?utf-8?B?VisvYyt1SWhqZDhkUG0yQW82S0YwcjRwVHhsU0U0dEVTcmkxRTY4bkxWMFdP?=
 =?utf-8?B?V1hZcDF1Snp2TFRJbXhCek1uYkZ1NEl5L1dSbDUxZXJ2Z1VMdVJIaG92MXZS?=
 =?utf-8?B?NEljM25OSDJSYmxlUkZXM0VFQ3VSUnV3dzFKNjkyTDhiMUZSN2tIUWVDY2M0?=
 =?utf-8?B?RjNGOVlycG1wQmtuaG8wSGozS2xjVzZXRHZuZDZwL3l5WmErb0Z6TmZzb0NL?=
 =?utf-8?B?UnpkL2c5WVNNVnRKdzRXQjNNaGZGak14ZUtabVlNRlh1aHdJb2tUdVphQ2po?=
 =?utf-8?B?dmdHakd2bklFTDFqREkrN3dzOUpEbVF5WU5ZOGkvdk5PdHR5aXVmWWxXMVRT?=
 =?utf-8?B?UGZjdHk5aVZLNURpV0tyd1o3amxpUHFaVVV4WUdlR0tuV3NmVzJOVThoNkpv?=
 =?utf-8?Q?YstY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3VsbTNtWEo4YTZtQllWd0swcUNaZUlVdzBFUzl1THcvR09KeWpYRVBOSE9u?=
 =?utf-8?B?SmhtNEZlL1VDa2xPNWdjVDhrWTR0SUwwZEFmY1lERHBrNVY1RURBVzZxVm1I?=
 =?utf-8?B?RWpJditsMUtBTVRJMmRhTnJjV3AvcGFIT201Y212WXRNWTI2bUpiRFhleWUw?=
 =?utf-8?B?YmoveHlWVkNKRnRFSksrbEYzczN0N1ZpQ1FrWG83YjlXVEdaUXcwNGhHV2tR?=
 =?utf-8?B?NndMYUZ4L1pBR2dzRFA4dzBkMVAvMUp1UitSbEVpVHRpZlNqNUZCRkRiMlNm?=
 =?utf-8?B?RFZCTER1OVVlQUNzMmtISXMyU0xveFBGL0RXWVR1aHRQSTh0Ym4xOTFnblZp?=
 =?utf-8?B?ZXQrWTdHajdEUWtncUlGTnVEQU5DSnhLN1hhNHF5SUY3ekt4QWZFQXdJd2E3?=
 =?utf-8?B?bGRxKzJkeDF3Y1YrYmdicTRaeE9yWHJ0NXlWYS9qeGJTK0JISlVnUmZIOFh5?=
 =?utf-8?B?TG1nTVJKUlpOaDRoZndRQmIvbE16RFhBM3BQU201eVVOcW95Z3Z6MVBaSWhB?=
 =?utf-8?B?bkhmckl4ZVhpMU93NFBHQ0UxNzIrOGFPMFJvU2lHeWd6Q2lIbmVPWlE0TFJT?=
 =?utf-8?B?SWFMMEN3ZG5QOElpRStRL0tqSzZGaXJKeHNUaHVjd3JtOWJUUGxxY0tvSHk5?=
 =?utf-8?B?ZnZpU1MwYzZqeE13azlaa24yd1g0a0l3Mk5CWEk1THdHRnRXWEZWS0FFWEJD?=
 =?utf-8?B?NEJxVkdVY1FLN0RGeHR1UXJNR0krV0tPb0J3bS9WYlhGdm9Cc2lOZ1A0dTJY?=
 =?utf-8?B?RU1vc0FjNWtzSys0Y1ZsN0hwV0RtQ05wWlU2TWlQNDBabEFOWHQ1RUFFRlkw?=
 =?utf-8?B?S1BPb1NoNGpWVzNmS3ExMHZDTll1VWdhVzgzekkxTDZQRUErQTJCV3pnSllQ?=
 =?utf-8?B?YmlFMDhXNmJWZVRlaGVCRU5sWjFFSVZCZEltZGhuUGlENmFPWCt3czh4YVB5?=
 =?utf-8?B?WXRnOGZzWDE5UTVBZksvYktMVW5NazJHWHNXUDdJcUxwcGdhdEc4UkhOeDJn?=
 =?utf-8?B?ZExhR3pGTFlDaGJRbmt4azZrYTk0ajV0RmNWam1oaWVjK0JLdjN4RENiWGVJ?=
 =?utf-8?B?encyTkdHdUpnWHp2UmU5eGJiaXgxZFlzdndaaU8rZDRKV1NOSWIwTXJsbit1?=
 =?utf-8?B?QlozemhLZGpXTHk2VE1uaXBwSHZacW5nampwanJLbFZUZHFKNjArZS85clRS?=
 =?utf-8?B?eFlTZ2NEL1lUSU9GcXlTbTFSemphazh3UUNoY1d5aCsxNGVablJwLzRFMEVT?=
 =?utf-8?B?YjRzMjNEQ210SXpKaUdYNkVXK0lWdHQ2TUROdDk0bFZrRU1rZnJhejZHOFFl?=
 =?utf-8?B?aEV0THp0Z3NWazFYL0NFMUsxWG1jb25sVHpVS1ZjQnRrdlZ3bnBBKzRGZXBO?=
 =?utf-8?B?djN1d2R2aFUvMWYzR0RHSTk2ZnJGVSsrNTl4WWF5R2czbTI5MmsxME5MeTZr?=
 =?utf-8?B?VDBvL0JGSkNnNUk1ODJPdVExRk9qRFNQdzV1eml2WkE1bTQwdW12NHIrK0Fl?=
 =?utf-8?B?NVJNT1dlR2IwSVE1TitwUnhaaVdEVXdjN2paaVBodVhadysvRTZ5QjhMYkI0?=
 =?utf-8?B?b2JJTjhLT3dFc3BOVytDbnhvRktXaGU1TGpFK3U5SGlndWhaNmVwa2FzSHNL?=
 =?utf-8?B?bnYrZU1kb2t4Z2FFV085QUorUDNiYVZHZmZnRWZYbWR3dys3bmNabkd6K2Ji?=
 =?utf-8?B?K3Z2U0Myc2xyRkdJNUNpSWpUb2RmdVZ6MGo4aUhNWlE2ampmaVNBZjFoQk5o?=
 =?utf-8?B?N2VaaFBRUXhaMDVuaTZGRmdNaUF1bEdEVHRZNmd1RDdaUXltcU82QlZ2QmVs?=
 =?utf-8?B?UkxlNWEzekRGdWd3SnBKYmVIbExLUzVZWUplNkVrYitONDYwMUJGRDdyN3hX?=
 =?utf-8?B?VWlmVVc4YzdpMitMWW11b1Z3ZkdFT2g1YmpvaTRBcG1kM0RMSjJNZzlMcWx6?=
 =?utf-8?B?a2dXZUJ2ZUVWK3NhekZSbmI2YWw4dnlZOXV3dnRQWURXbzVrSmg0ek85emZq?=
 =?utf-8?B?U2hvNnF3dTZPbmMrbVN4Q0pQR2RrRHk4Smc1bUNpMmx0cCsyU1ZUSjRWZ2k0?=
 =?utf-8?B?SjBhNisvcGhheHBRUUwzRjFacHcwRG1ieGpNRXJ2OGd5YXhzVERIK2lRYjNB?=
 =?utf-8?B?THV6YXlpUkhSR09US2cvWDRxTENiKzM5UzBpRTBaNUtHSXp2azVkbDRmVm10?=
 =?utf-8?B?RDNQTDlpM3ZnUFZ5QzVyM3BibTNBcmpHTGxnd0JXVGRzV2Q4YkRVS1puSytm?=
 =?utf-8?B?WVQyMEJ5U2JpdzJXTTNPV3J1NEJGa0ZvcWJwK0lza3QzL0FyalRlL09YbS9R?=
 =?utf-8?B?SnJVQ1NicGJmeWkzeUFXQW1aMW9mODdGRnZETGJEVTNHcWswYk05QT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a776931d-8cf5-4e5a-1eee-08de5865988c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 20:50:50.9452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dRqZuFHZ7XfPbBuN9EA01cTkKZGhJCwuPlTLUHGQwEJO7HlsrbTrc2OD9HI3LJNYCiDyJpLR8JiLol8PxxfdF3e0jjLPAciMnRFKnMrSanA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4633
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-68653-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,intel.com:mid,intel.com:dkim];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chang.seok.bae@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 1EFCE4CD4F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/20/2026 10:07 AM, Edgecombe, Rick P wrote:
> On Mon, 2026-01-19 at 13:55 +0800, Xiaoyao Li wrote:   
>>
>> Not any intention of this patch, but this change eventually allows the
>> userspace to expose APX to TDX guests.
>>
>> Without any mentioning of TDX APX tests and validation like the one for
>> CET[1], I think it's unsafe to allow it for TDX guests.

My original assumption was like what I just mentioned in the RFC cover:

   The specification deliberately scopes out some areas. For example,
   Sections 3.1.4.4.2–7 note that initialization and reset behaviors
   follow existing XSTATE conventions.

With there in 3.1.4.4.2 Intel® TDX,

   Intel® TDX has an XCR0-derived interface called TDCS.XFAM. Bits in
   XFAM act as an opt-in for state and ISA controls. Therefore,
   XFAM[APX_F] acts as a control for enabling Intel® APX within Trust
   Domains (or TDs), and the XFAM settings are established at TD INIT
   (TDH.TD.INIT).

Conceptually, APX enablement for TDX could be explicitly gated, which 
helps to narrow the scope of the KVM changes (perhaps, at least for the 
early review).

*However*, once the APX bit is set in supported_xcr0, it can flow into 
XFAM through the code path as:

tdx_get_supported_xfam(...)
{
	u64 val = kvm_caps.supported_xcr0 | kvm_caps.supported_xss;

	if ((val & td_conf->xfam_fixed1) != td_conf->xfam_fixed1)
		return 0;

	val &= td_conf->xfam_fixed0;

	return val;
}

So I agree that, in the current codebase, whoever updates the KVM-side 
bitmask should ensure that TDX guests are okay with it. I also now 
understand the idea that TDX guests are yet another guest type, which is 
under the impact of whatever kvm_cap changes.

>>
> 
> That was an especially odd one.
> 
>>   E.g., the worst
>> case would be KVM might need extra handling to keep host's
>> states/functionalities correct once TD guest is able to manage APX.
>>
>> I'm thinking maybe we need introduce a supported mask,
>> KVM_SUPPORTED_TD_XFAM, like KVM_SUPPORTED_TD_ATTRS. So that any new XFAM
>> related feature for TD needs the explicit enabling in KVM, and people
>> work on the new XSAVE related feature enabling for normal VMs don't need
>> to worry about the potential TDX impact.
> 
> We might need it. But in general, I agree KVM enabling for new features needs to
> consider the TDX impact now. For APX, it looks like we don't need to add a new
> type of supported feature tracking because the TDX APX arch is public.
> 
> Chang, let's circle back internally and figure out who owns what.

I'd come back here with positive TDX test results once available. For 
now, I would leave additional guarding or geting outside of this 
enabling scope.

Thanks,
Chang

